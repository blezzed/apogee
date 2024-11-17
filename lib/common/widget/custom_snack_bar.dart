import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme.dart';

void showCustomSnackBar(String message, {bool isError=true, String title="Error"}){
  Get.snackbar(title, message,
      titleText:Text(
         isError? title : "Success",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          )
      ),
      messageText: Text(
        message,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: 12,
        )
      ),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.redAccent : AppColors.rifleBlue,
  );
}