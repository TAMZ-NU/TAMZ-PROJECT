import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyText extends StatelessWidget {
  String text;
  double size = 20.0;
  Color color;
  MyText({@required this.text, this.size, this.color, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: 1.0,
      overflow: TextOverflow.clip,
      softWrap: true,
      maxLines: 3,
      textAlign: TextAlign.start,
      style: TextStyle(fontSize: size, fontFamily: 'somar', color: color),
    );
  }
}
