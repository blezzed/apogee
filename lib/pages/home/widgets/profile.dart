import 'package:apogee/pages/home/widgets/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/values/storage.dart';
import '../../../common/widget/top_app_icon.dart';
import '../../../theme.dart';
import '../controller.dart';

class ProfilePage extends GetView<HomeController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final auth = controller.user;
    Color iconBackground = AppColors.buttonBackgroundColor;
    Color iconColor = AppColors.darkBrown;

    final state = controller.state;

    RichText _subTitle(title, value)=>RichText(text: TextSpan(
      children: [
        TextSpan(
          text: '$title: ', // Label part
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: AppColors.signColor,
              height: 1.5
          ),
        ),
        TextSpan(
          text: value, // Dynamic satellite name
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: AppColors.darkBrown,
              height: 1.5
          ),
        ),
      ],
    ));

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
              "Settings",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: 24.sp,
              color: AppColors.rifleBlue,
            ),
          )
      ),
      body: Obx(()=>Column(
        children: [
          Container(
              height: 200.h,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                      width: 2.w,
                      color: AppColors.rifleBlue
                  )
              ),
              child: Stack(
                children: [
                  GoogleMap(initialCameraPosition:state.cameraPosition.value,
                    mapType: MapType.satellite,
                    onTap: (latlng) async {
                      await launchUrl(Uri.parse(
                          'google.navigation:q=${controller.station.value.latitude}, ${controller.station.value.longitude}&key=$STORAGE_GOOGLE_MAP_KEY'));
                    },
                    markers: Set<Marker>.of(state.markerList),
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    indoorViewEnabled: true,
                    mapToolbarEnabled: false,
                    myLocationEnabled: true,
                    onCameraIdle: (){
                      // controller.updatePosition(state.cameraPosition.value);
                    },
                    onCameraMove: ((position) => state.cameraPosition.value = position),
                    onMapCreated: (GoogleMapController googleMapController){
                      controller.setMapController(googleMapController);
                    },
                  )
                ],
              )
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: Colors.grey.shade100,
                    offset: const Offset(-5,0),
                  )
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GROUND STATION",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                _subTitle("Name", controller.station.value.name),
                _subTitle("Altitude", "${controller.station.value.altitude}°"),
                _subTitle("Tracking Elevation", "${controller.station.value.startTrackingElevation}°"),
              ],
            ),
          ),
          ProfileTile(
              appIcon: TopAppIcon(icon: Icons.person,
                backgroundColor: iconBackground,
                iconColor: iconColor,
                iconSize: 20.h,
                size: 35.h,
              ),
              title: "Name",
              text:  "Fill in your name"
          ),
          Divider(
            thickness: 1,
            indent: 25.w,
            endIndent: 10.w,
          ),
          ProfileTile(
            appIcon: TopAppIcon(icon: Icons.info_outline_rounded,
              backgroundColor: iconBackground,
              iconColor: iconColor,
              iconSize: 20.h,
              size: 35.h,
            ),
            title: "About",
            text: "Description . Status . Developer",
            onTap: (){

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
            text: "Sign out",
            onTap: (){
              // controller.onLogout();
            },
          ),
        ],
      )),
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
