import 'package:flutter/material.dart';

class TextLabelWidget extends StatelessWidget {

  final String data;
  final EdgeInsetsGeometry margin;

  const TextLabelWidget(
    this.data, {
    Key? key,
    this.margin = const EdgeInsets.only(left: 15, bottom: 5)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        data,
        style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 12
        ),
      ),
    );
  }
}