import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../common/apis/auth.dart';
import '../../common/routes/routes.dart';
import '../../common/store/user.dart';
import '../../common/widget/custom_snack_bar.dart';
import 'state.dart';

class AuthController extends GetxController {
  AuthController();
  final state = AuthState();
  final user = UserStore.to.profile;


  final key = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    state.loading.value = true;
    final response = await AuthApiService.loginUser(
      usernameController.text,
      passwordController.text,
    );

    if (response['success']) {
      // Handle successful login

      Get.offAllNamed(AppRoutes.Home);
    } else {
      showCustomSnackBar(response['message'], title: "");
    }
    state.loading.value = false;
  }

  /*Future<void> signIn() async {
    state.loading.value = true;
    try {
      // Authenticate with Firebase
      final creds =
      await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

      final user = creds.user;
      if(user != null){
        await sp.getVeterinaryModelFromFirestore                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          (user.uid).then((value) {
          UserStore.to.saveProfile(value);
          Get.offAllNamed(AppRoutes.Home);
        });
      }

    } catch (e) {
      state.loading.value = false;
      showCustomSnackBar('An error occurred: $e', title: "");
      print("THE ERROR: $e");
    }
    state.loading.value = false;
  }*/

  void onLogout() async {
    await AuthApiService.logout();
    UserStore.to.onLogout();
  }

  @override
  void onInit() {
    super.onInit();

  }


  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
