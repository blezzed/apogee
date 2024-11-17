import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme.dart';

class CustomFmdTextField extends StatelessWidget {
  const CustomFmdTextField({super.key, required this.hintText, required this.controller, this.keyboardType, this.color, this.onComplete});

  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Color? color;
  final void Function(String)? onComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15.w),
      //margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 350,
      height: keyboardType == TextInputType.multiline? 110 : 50,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).primaryColor.withAlpha(20),
        borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
                color: AppColors.paraColor.withAlpha(30),
                spreadRadius: 0.5.h,
                blurRadius: 5.h,
                offset: Offset(2.h,2.h)
            )
          ]
      ),
      child: Material(
          color: Colors.transparent,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType ?? TextInputType.name,
            textCapitalization: (keyboardType == TextInputType.emailAddress || keyboardType == TextInputType.visiblePassword)
                ? TextCapitalization.none:TextCapitalization.sentences,
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: keyboardType == TextInputType.multiline? 5 : 1,
            onChanged: onComplete,
            obscureText: (keyboardType == TextInputType.visiblePassword)
                ? true
                : false,
            decoration: InputDecoration(
                hintText: hintText,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
          )),
    );
  }
}
