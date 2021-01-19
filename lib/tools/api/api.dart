import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timezones/application/app_cache.dart';
import 'package:timezones/application/environment/environment.dart';
import 'package:timezones/generated/locale_keys.g.dart';
import 'package:timezones/tools/tools.dart';
import 'package:http/http.dart';
import 'ignore_certificate_client.dart';
import 'result.dart';

enum HTTPMethod {
  get, post, put, delete
}

class Api {

  Client client;
  bool printResponse = true;
  String endpoint = "";
  HTTPMethod method = HTTPMethod.get;
  bool publicAPI = false;
  int timeoutBase = 20000;

  Map<String, String> headersCommon = {
    "Content-Type": "application/json"
  };

  Api(this.endpoint, {this.method: HTTPMethod.get, this.publicAPI: false, this.client}) {
    if (client == null) {
      client = kIsWeb ? Client() : IgnoreCertificateClient();
    }
  }

  Future<Result> call({
    Map<String,dynamic> parameters: const {},
    Map<String,String> headers: const {},
    String key
  }) async {

    key = key ?? Tools.randomString();

    //prepare headers
    Map<String,String> headersToAddInRequest = headersCommon;
    headers.forEach((key,val) => headersToAddInRequest[key] = val);

    //build url
    String url = Environment.value.path + endpoint;
    if (endpoint.startsWith("http")) {
      url = endpoint;
    }

    //parameters
    Map<String, dynamic> paramsToAddInRequest = {};

    //replace in url {...} - dynamic parts - with parameters
    if(parameters.isNotEmpty) {
      parameters.forEach((key, val) {
        if(url.contains(key) && key.startsWith("{") && key.endsWith("}")) {
          url = url.replaceAll(key, val);
        } else {
          paramsToAddInRequest[key] = val;
        }
      });
      url = url.replaceAll("://", ":///");
      url = url.replaceAll("//", "/");
    }

    //if get, create params in path
    if ((method == HTTPMethod.get || method == HTTPMethod.delete) && paramsToAddInRequest.isNotEmpty) {

      String apiParams = "";
      paramsToAddInRequest.forEach((key,val) {
        val = Uri.encodeFull(val.toString());
        val = val.toString().replaceAll("&", "%26");
        key = Uri.encodeFull(key.toString());
        key = key.toString().replaceAll("&", "%26");
        apiParams = apiParams + "$key=$val&";
      });

      if (apiParams.endsWith("&")) {
        apiParams = apiParams.substring(0, apiParams.length - 1);
      }
      url = "$url?$apiParams";
      paramsToAddInRequest = {};
    }

    if (url.endsWith("/")) {
      url = url.substring(0, url.length - 1);
    }

    if (printResponse) {
      debugPrint("_______________ REQUEST _________________________________________");
      debugPrint("url:   $url");
      debugPrint("method:   ${method.toString()}");
      debugPrint("headers:   ${headersToAddInRequest.toString()}");
      debugPrint("params:   ${paramsToAddInRequest.toString()}");
    }

    //token management
    String token = AppCache.instance.token;
    DateTime tokenExpire = AppCache.instance.tokenExpire;

    //check if token is valid
    if (token != null && tokenExpire != null && tokenExpire.isAfter(DateTime.now())) {
      headersToAddInRequest["Authorization"] = "bearer $token";
    } else if (!publicAPI) {
      return _handleFailResponse(ClientException(LocaleKeys.error_token, Uri.parse(url)), key);
    }

    Response response;

    try {
      switch (method) {
        case HTTPMethod.get: {
          response = await client.get(url, headers: headersToAddInRequest).timeout(Duration(milliseconds: timeoutBase));
        } break;
        case HTTPMethod.post: {
          response = await client.post(url, headers: headersToAddInRequest, body: json.encode(paramsToAddInRequest)).timeout(Duration(milliseconds: timeoutBase));
        } break;
        case HTTPMethod.put: {
          response = await client.put(url, headers: headersToAddInRequest, body: json.encode(paramsToAddInRequest)).timeout(Duration(milliseconds: timeoutBase));
        } break;
        case HTTPMethod.delete: {
          response = await client.delete(url, headers: headersToAddInRequest).timeout(Duration(milliseconds: timeoutBase));
        } break;
      }
    } catch (error) {
      if (error is TimeoutException) {
        return _handleFailResponse(ClientException(LocaleKeys.error_token, Uri.parse(url)), key);
      } else if (error is StateError) {
        return _handleFailResponse(ClientException(error.message, Uri.parse(url)), key);
      } else if (error is ClientException) {
        return _handleFailResponse(error, key);
      } else {
        return _handleFailResponse(null, key);
      }
    }

    if (response.statusCode == 200) {
      return _handleSuccessResponse(response, key);
    } else {

      String error = LocaleKeys.error_general;
      try {
        Map<String, dynamic> data = json.decode(response.body);
        error = data["error"];
      } catch (_) {}

      return _handleFailResponse(ClientException(error, response.request?.url ?? Uri()), key, code: response.statusCode.toString());
    }
  }

  Result<dynamic> _handleFailResponse(ClientException response, String key, {String code}) {

    Result<dynamic> result = Result<dynamic>();
    result.key = key;
    result.error = code ?? "500";
    result.status = Status.fail;

    if (response == null || response.message == null) {
      result.error = "500";
    } else {
      result.error = response.message ?? code;
    }

    if (printResponse) {
      debugPrint("_______________ ERROR _________________________________________");
      debugPrint("error:   ${result.error}");
    }

    return result;
  }

  Result<dynamic> _handleSuccessResponse(Response response, String key) {
    Result<dynamic> result = Result<dynamic>();
    result.key = key;

    Map<String, dynamic> data = json.decode(response.body);

    bool status = data["status"];

    if (status) {
      result.status = Status.success;
      result.data = data["body"];

      if (printResponse) {
        debugPrint("_______________ RESULT _________________________________________");
        debugPrint("response:   $data");
      }

    } else {
      result.status = Status.fail;

      String code = data["code"].toString();
      result.error = code;

      Map<String, dynamic> errorData = data["error"];
      errorData.forEach((key, val) {
        if (key == "message") {
          result.error = val;
        } else {
          result.message[key] = val;
        }
      });

      if (printResponse) {
        debugPrint("_______________ RESULT (ERROR) _________________________________________");
        debugPrint("response:   $data");
      }
    }

    return result;
  }
}
