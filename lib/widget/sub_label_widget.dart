import 'package:flutter/material.dart';

class SubLabelWidget extends StatelessWidget {

  final String data;
  final EdgeInsetsGeometry? padding;

  const SubLabelWidget(
    this.data, {
    Key? key,
    this.padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
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