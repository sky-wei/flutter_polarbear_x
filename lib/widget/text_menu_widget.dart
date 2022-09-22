

import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_svg/svg.dart';

class TextMenuWidget extends StatelessWidget {

  final String data;
  final String value;
  final EdgeInsetsGeometry margin;
  final GestureTapCallback? onTap;

  const TextMenuWidget(
      this.data,
      this.value, {
        Key? key,
        this.margin = const EdgeInsets.only(top: 10),
        this.onTap
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: const BorderRadiusDirectional.all(Radius.circular(6)),
      child: Ink(
        child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 10),
              child: Stack(
                alignment: AlignmentDirectional.centerStart,
                children: [
                  Text(
                    data,
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).mainTextColor
                    ),
                    maxLines: 1,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).mainTextColor
                          ),
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                            "assets/svg/ic_right_arrow.svg",
                            width: 26,
                            height: 26,
                            color: Theme.of(context).iconColor
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}