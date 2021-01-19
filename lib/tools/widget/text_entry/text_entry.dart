
import 'package:timezones/tools/widget/text_entry/validator.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../any_image.dart';
import '../progress_indicator.dart';

class TextEntry extends StatelessWidget {

  Function(TextEntry) _beginEdit;
  Function(TextEntry) _endEdit;
  List<Validator> validators;
  TextEntryModel model;
  TextField _textField;
  final LayerLink _suggestionsLayerLink = LayerLink();
  Function(TextEntrySuggestion) onSuggestionSelect;

  TextEntry(this.model, {
    String icon,
    bool progress = false,
    String name,
    String hint = "",
    String text,
    bool secure = false,
    int maxLines = 1,
    ValueChanged<String> onChanged,
    Function(TextEntry) beginEdit,
    Function(TextEntry) endEdit,
    this.validators = const [],
    TextInputType keyboardType,
    bool enabled = true,
    bool editable = true,
    bool autofocus = false,
    bool enableSelection = true,
    Color fillColor,
    Color iconColor,
    this.onSuggestionSelect
  }) {
    _textField = TextField(
        obscureText: secure,
        focusNode: model.focusNode,
        keyboardType: keyboardType,
        maxLines: maxLines,
        enabled: enabled && editable,
        controller: TextEditingController(text: (model.text ?? text))
          ..selection = (
              text != null ?
              TextSelection.collapsed(offset: (model.text ?? text).length) :
              (model._field?.controller?.selection ?? TextSelection.collapsed(offset: ((model.text ?? text) ?? "").length))
          ),
        onChanged: (text) {
          model.text = text;
          if (onChanged != null) {
            onChanged(text);
          }
        },
        autofocus: autofocus,
        decoration: InputDecoration(
            suffixIcon: initIcon(icon, progress, enabled, iconColor),
            filled: fillColor != null,
            fillColor: fillColor,
            hintText: hint.tr(),
            labelText: name?.tr(),
            errorText: model.error?.tr()
        ),
        enableInteractiveSelection: enableSelection //todo: this is because of bug https://github.com/flutter/flutter/issues/14489
    );
    _beginEdit = beginEdit;
    _endEdit = endEdit;

    model._field = _textField;
    model.validators = validators;
    if (text != null && model.text == null) {
      model.text = text;
    }

    _initFocus();
  }

  void _initFocus() {
    if(!model.focusNode.hasListeners) {
      model.focusNode.addListener(() {
        if (!model.focusNode.hasFocus) {
          if (model.suggestionsView != null) {
            model.suggestionsView.remove();
            model.suggestionsView = null;
          }
          if (_endEdit != null) {
            _endEdit(this);
          }
        } else {
          if (_beginEdit != null) {
            _beginEdit(this);
          }
        }
      });
    }
  }

  static Widget initIcon(String icon, bool progress, bool enabled, Color color) {
    if (icon == null) {
      return null;
    }
    Widget suffixIcon = Container(
      width: 24,
      height: 24,
      padding: EdgeInsets.all(9),
      child: AnyImage(icon, color: color ?? Colors.black),
    );

    if(progress) {
      suffixIcon = Container(
        padding: EdgeInsets.all(16),
        width: 8,
        height: 18,
        child: Progress(color: color ?? Colors.black),
      );
    }

    return suffixIcon;
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(milliseconds: 100), () {
      _showHideSuggestions(context);
    });

    return CompositedTransformTarget(
      link: _suggestionsLayerLink,
      child: _textField,
    );
  }

  void _showHideSuggestions(BuildContext context) {
    if (model.suggestions == null || model.suggestions.isEmpty || !model.focusNode.hasFocus) {
      if (model.suggestionsView != null) {
        model.suggestionsView.remove();
        model.suggestionsView = null;
      }
      return;
    }

    if (model.suggestionsView != null) {
      model.suggestionsView.remove();
      model.suggestionsView = null;
    }

    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    model.suggestionsView = OverlayEntry(
        builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _suggestionsLayerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 4.0,
              child: Container(
                constraints: BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                    itemCount: (model.suggestions ?? []).length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: model.suggestions[index].view(),
                        onTap: () {
                          _handleSuggestionSelect(model.suggestions[index]);
                        },
                      );
                    }
                ),
              ),
            ),
          ),
        )
    );

    Overlay.of(context).insert(model.suggestionsView);
  }

  void _handleSuggestionSelect(TextEntrySuggestion suggestion) {
    if (onSuggestionSelect != null) {
      onSuggestionSelect(suggestion);
    }
  }
}

class TextEntryModel {
  TextField _field;
  FocusNode focusNode = FocusNode();
  String error;
  String text;
  List<TextEntrySuggestion> suggestions = [];
  List<Validator> validators = [];
  TextEntrySuggestion selectedSuggestion;
  OverlayEntry suggestionsView;

  TextEntryModel();

  Future<ValidatorResult> validate() async {
    error = null;
    if (validators == null || validators.isEmpty) {
      return ValidatorResult(true, null);
    }

    bool isValid = true;
    String hasError;

    for (Validator validator in validators) {
      ValidatorResult result = await validator.validate({ValidableParam.text: text});
      if (!result.valid) {
        isValid = isValid && result.valid;
        hasError = hasError ?? result.error;
      }
    }
    this.error = hasError;
    return ValidatorResult(isValid, hasError);
  }

  static Future<bool> validateFields(List<TextEntryModel> fields) async {
    bool isValid = true;

    for (TextEntryModel model in fields) {
      ValidatorResult result = await model.validate();
      isValid = isValid && result.valid;
    }

    return isValid;
  }
}

class TextEntrySuggestion<T> {
  T model;
  Widget Function(T) display;

  TextEntrySuggestion(this.model, {@required this.display});

  Widget view() {
    return display(model);
  }
}
