import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/widget/top_app_icon.dart';
import '../../../theme.dart';

class ProfileTile extends StatelessWidget {
  final TopAppIcon appIcon;
  final String title;
  final String? text;
  final VoidCallback? onTap;
  const ProfileTile({super.key, required this.appIcon, required this.title, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 20.w),
          constraints: BoxConstraints(maxWidth: 350.w),
          child: Row(
            children: [
              appIcon,
              SizedBox(width: 20.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.rifleBlue
                    ),
                  ),
                  Text(
                    text ?? "",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: AppColors.signColor
                    ),
                  ),
                ],
              )
            ],
          )
      ),
    );
  }
}