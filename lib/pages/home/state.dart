
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeState{

  Rx<int> page = 0.obs;

  RxList<String> tabTitles = <String>[].obs;

  RxList<IconData> listOfIcons = <IconData>[].obs;

  List<Widget> pages = [];


}