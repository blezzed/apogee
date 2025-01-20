
import 'dart:convert';

import 'package:apogee/common/entities/entities.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';
import '../services/storage.dart';
import '../values/storage.dart';

class UserStore extends GetxController{
  static UserStore get to => Get.find();

  final _isLogin = false.obs;
  bool get isLogin => _isLogin.value;
  set setIsLogin(login)=>_isLogin.value=login;

  String token = "";
  bool get hasToken => token.isNotEmpty;

  final _profile = UserData().obs;
  UserData get profile => _profile.value;


  @override
  Future<UserStore> onInit() async {
    super.onInit();
    /*token = StorageService.to.getString(STORAGE_USER_TOKEN_KEY);
    var profileOffline = StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
    if(profileOffline.isNotEmpty){
      _isLogin.value = true;
      _profile(UserData.fromJson(jsonDecode(profileOffline)));
    }*/
    return this;

  }

  Future<void> setToken(String value) async {
    await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
  }

  Future<String> getProfile() async {
    if(token.isEmpty) return "";
    return StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
  }

  Future<void> saveProfile(UserData profile) async {
    _isLogin.value = true;
    final profileJson = profile.toJson();
    profileJson["created_at"] = profileJson["created_at"].toString();
    StorageService.to.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(profileJson));
    _profile(profile);
    setToken(profile.access_token!);
  }

  Future<void> onLogout() async {
    await StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
    await StorageService.to.remove(STORAGE_USER_PROFILE_KEY);
    _isLogin.value = false;
    token = "";
    Get.offAllNamed(AppRoutes.Sign_In);
  }

}