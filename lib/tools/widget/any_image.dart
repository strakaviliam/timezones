
import 'dart:math';
import 'package:timezones/tools/widget/font_awesome.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timezones/tools/widget/progress_indicator.dart';

class AnyImage extends StatefulWidget {

  final dynamic content;
  final Color color;
  final AnyImage errorImage;
  final Size size;
  final BoxFit boxFit;
  final double opacity;

  AnyImage(this.content, {this.color, this.errorImage, String value, this.size, this.boxFit, this.opacity = 1.0});

  @override
  State<StatefulWidget> createState() => _AnyImageState();
}

class _AnyImageState extends State<AnyImage> {

  BoxFit boxFit;
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _setState();
  }

  void _setState() {
    boxFit = widget.boxFit ?? BoxFit.contain;
    opacity = widget.opacity;
  }

  @override
  void didUpdateWidget(AnyImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.boxFit != boxFit || widget.opacity != opacity) {
      _setState();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {


    if (widget.content is String) {

      if (widget.content == "") {
        return Container();
      }

      String path = widget.content;
      if (widget.content.startsWith("images/")) {
        if (!kIsWeb) {
          path = "assets/" + path;
        }
      }

      return Container(
        child: LayoutBuilder(builder: (context, constraint) {
          double useWidth = widget.size == null ? constraint.biggest.width : (widget.size.width == 0 ? constraint.biggest.width : widget.size.width);
          double useHeight = widget.size == null ? constraint.biggest.height : (widget.size.height == 0 ? constraint.biggest.height : widget.size.height);

          Widget image;

          if (path.startsWith("fa_") && FontAwesomeIcons.faIcons.containsKey(path)) {

            double size = [useWidth, useHeight].reduce(min);

            image = Container(
              alignment: Alignment.center,
              child: Container(
                  width: size,
                  height: size,
                  child: LayoutBuilder(builder: (context, constraints) {
                    double useSize = [constraints.maxWidth, constraints.maxHeight].reduce(min);
                    return Container(
                      padding: kIsWeb ? EdgeInsets.only(top: useSize * 0.12,) : null,
                      child: Icon(
                        FontAwesomeIcons.faIcons[path].icon(),
                        color: widget.color ?? Colors.black,
                        size: useSize * 0.8,
                      ),
                    );
                  })
              ),
            );
          } else if (path.startsWith("http")) {
            image = Image.network(path,
              fit: boxFit,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: Container(width: 30, height: 30, child: Progress(color: Theme.of(context).primaryColor))
                );
              },
            );
          } else {
            image = Image(
              width: useWidth,
              height: useHeight,
              image: AssetImage(path),
              fit: boxFit,
              alignment: Alignment.center,
            );
          }

          if (image != null) {
            return Opacity(
              opacity: opacity,
              child: Container(
                  width: useWidth,
                  height: useHeight,
                  child: Center(child: image)
              ),
            );
          }

          image = Container(padding: EdgeInsets.all(5), child: Center(child: Container(width: 30, height: 30, child: Progress(color: Theme.of(context).primaryColor))));

          return image;
        }),
      );
    } else if (widget.content is IconData) {
      //icon
      return Container(
        child: LayoutBuilder(builder: (context, constraint) {
          double useWidth = widget.size == null ? constraint.biggest.width : (widget.size.width == 0 ? constraint.biggest.width : widget.size.width);
          double useHeight = widget.size == null ? constraint.biggest.height : (widget.size.height == 0 ? constraint.biggest.height : widget.size.height);
          return Container(
            width: useWidth,
            height: useHeight,
            child: Icon(
              widget.content,
              color: widget.color ?? Colors.black,
              size: useHeight*0.8,
            ),
          );
        }),
      );
    }

    return Container(
      child: Placeholder(),
    );
  }
}
