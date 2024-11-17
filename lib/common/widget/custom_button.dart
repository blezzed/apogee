import 'package:flutter/material.dart';

import '../../theme.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final IconData? icon;
  final Color? buttonColor;
  final Color? buttonTextColor;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.transparent = false,
    this.margin,
    this.height,
    this.width,
    this.fontSize,
    this.radius,
    this.icon,
    this.buttonColor,
    this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButton = TextButton.styleFrom(
        elevation: 0,
        backgroundColor: onPressed == null
            ? Theme.of(context).disabledColor
            : transparent
            ? Colors.transparent
            : buttonColor ?? AppColors.primary,
        minimumSize:
        Size(width == null ? 280 : width!, height == null ? 50 : height!),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 10)));
    return Center(
      child: SizedBox(
          width: width ?? double.maxFinite,
          height: height ?? 50,
          child: TextButton(
            onPressed: onPressed,
            style: flatButton,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon != null
                    ? Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      icon,
                      color: transparent
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor,
                    ))
                    : const SizedBox(),
                Text(
                  buttonText,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: fontSize ?? 16,
                      color: buttonTextColor ?? (transparent
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor)
                  ),
                )
              ],
            ),
          )),
    );
  }
}
