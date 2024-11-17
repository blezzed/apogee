import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../theme.dart';
import '../controller.dart';

class ProfilePage extends GetView<HomeController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final auth = controller.user;
    Color iconBackground = AppColors.signColor;
    Color iconColor = AppColors.darkBrown;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
              "Profile",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 24.sp,
              color: AppColors.rifleBlue,
            ),
          )
      ),
      /*body: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 20.h),
        child: Column(
          children: [
            //profile icon
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // name
                    ProfileTile(
                        appIcon: TopAppIcon(icon: Icons.person,
                          backgroundColor: iconBackground,
                          iconColor: iconColor,
                          iconSize: 20.h,
                          size: 35.h,
                        ),
                        title: "Name",
                        text: auth.name!=null? "${auth.name} ${auth.surname ?? ""}": "Fill in your name"
                    ),
                    Divider(
                      thickness: 1,
                      indent: 25.w,
                      endIndent: 10.w,
                    ),
                    //phone
                    ProfileTile(
                        appIcon: TopAppIcon(icon: Icons.phone,
                          backgroundColor: iconBackground,
                          iconColor: iconColor,
                          iconSize: 20.h,
                          size: 35.h,
                        ),
                        title: "Phone",
                        text:  auth.phone ?? "FIll in your phone",
                      onTap: (){

                      },
                    ),
                    Divider(
                      thickness: 1,
                      indent: 25.w,
                      endIndent: 10.w,
                    ),
                    //email
                    ProfileTile(
                        appIcon: TopAppIcon(icon: Icons.email,
                          backgroundColor: iconBackground,
                          iconColor: iconColor,
                          iconSize: 20.h,
                          size: 35.h,
                        ),
                        title: "Email",
                        text: auth.email ?? "FIll in your email address"
                    ),
                    Divider(
                      thickness: 1,
                      indent: 25.w,
                      endIndent: 10.w,
                    ),
                    // address
                    GestureDetector(
                      onTap: (){
                      },
                      child: ProfileTile(
                        appIcon: TopAppIcon(icon: Icons.location_on,
                          backgroundColor: iconBackground,
                          iconColor: iconColor,
                          iconSize: 20.h,
                          size: 35.h,
                        ),
                        title: "Address",
                        text: (auth.address == null)
                            ?"Fill in your address"
                            :"${auth.address!.street??''}, ${auth.address!.district??''}, ${auth.address!.country??''}",
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      indent: 25.w,
                      endIndent: 10.w,
                    ),
                    ProfileTile(
                      appIcon: TopAppIcon(icon: Icons.call_made_rounded,
                        backgroundColor: iconBackground,
                        iconColor: iconColor,
                        iconSize: 20.h,
                        size: 35.h,
                      ),
                      title: "Veterinary",
                      text:  "Call veterinary center, reading sources",
                      onTap: (){
                        Get.to(() => const ContactPage());
                      },
                    ),
                    Divider(
                      thickness: 1,
                      indent: 25.w,
                      endIndent: 10.w,
                    ),
                    // messeges
                    ProfileTile(
                        appIcon: TopAppIcon(icon: Icons.message_outlined,
                          backgroundColor: iconBackground,
                          iconColor: iconColor,
                          iconSize: 20.h,
                          size: 35.h,
                        ),
                        title: "Assistance",
                      onTap: (){
                        Get.toNamed("/chatbot");
                      },
                    ),
                    Divider(
                      thickness: 1,
                      indent: 25.w,
                      endIndent: 10.w,
                    ),
                    // logOut
                    ProfileTile(
                        appIcon: TopAppIcon(icon: Icons.logout,
                          backgroundColor: iconBackground,
                          iconColor: iconColor,
                          iconSize: 20.h,
                          size: 35.h,
                        ),
                        title: "Logout",
                      onTap: (){
                        controller.onLogout();
                      },
                    ),
                    SizedBox(height:20.h),
                  ],
                ),
              ),
            )

          ],
        ),

      ),*/
    );
  }
}
