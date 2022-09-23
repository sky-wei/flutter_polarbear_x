

import 'package:flutter/material.dart';
import 'package:flutter_polarbear_x/theme/theme.dart';
import 'package:flutter_polarbear_x/util/size_box_util.dart';
import 'package:flutter_svg/svg.dart';

class SubMenuWidget extends StatelessWidget {

  final String? iconName;
  final String title;
  final String? desc;
  final String? value;
  final String? moreIconName;
  final EdgeInsetsGeometry? padding;
  final GestureTapCallback? onTap;

  const SubMenuWidget({
    Key? key,
    this.iconName,
    required this.title,
    this.desc,
    this.value,
    this.moreIconName,
    this.padding,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.circular(6),
      child: Ink(
        width: double.infinity,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Row(
              children: [
                if (iconName != null)
                  SvgPicture.asset(
                    'assets/svg/$iconName',
                    width: 20,
                    color: Theme.of(context).iconColor,
                  ),
                if (iconName != null)
                  XBox.horizontal15,
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).mainTextColor
                        ),
                        maxLines: 1,
                      ),
                      if (desc != null)
                        Text(
                          desc!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).hintColor
                          ),
                          maxLines: 1,
                        ),
                    ],
                  ),
                ),
                if (value != null)
                  Text(
                    value!,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                  ),
                if (value != null)
                  XBox.horizontal5,
                if (moreIconName != null)
                  SvgPicture.asset(
                    'assets/svg/$moreIconName',
                    width: 20,
                    color: Theme.of(context).iconColor,
                  )
              ],
            ),
          )
        ),
      ),
    );
  }
}