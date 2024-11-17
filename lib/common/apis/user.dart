
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class UserApi extends ChangeNotifier{

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  UserApi();


}