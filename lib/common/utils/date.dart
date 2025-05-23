
import 'dart:io';

import 'package:intl/intl.dart';

String timeFormated(String? time){
  final DateTime now = time==null?DateTime.now().toLocal():DateTime.parse(time).toLocal();
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss',Platform.localeName);
  return formatter.format(now);
}

/// 格式化时间
String duTimeLineFormat(DateTime dt) {

  var now = DateTime.now();
  var difference = now.difference(dt);
  if (difference.inSeconds < 60) {
    if(difference.inSeconds<0){
      return "0s ago";
    }
    return "${difference.inSeconds}s ago";
  }
  if (difference.inMinutes < 60) {
    return "${difference.inMinutes}m ago";
  }
  // 1天内
  if (difference.inHours < 12) {
    return "${difference.inHours}h ago";
  }
  if (difference.inDays < 3) {
    final dtFormat = DateFormat('MM-dd hh:mm',Platform.localeName);
    return dtFormat.format(dt);
  }
  // 30天内
  if (difference.inDays < 30) {
    final dtFormat = DateFormat('yy-MM-dd hh:mm',Platform.localeName);
    return dtFormat.format(dt);
  }
  // MM-dd
  else if (difference.inDays < 365) {
    final dtFormat = DateFormat('yy-MM-dd',Platform.localeName);
    return dtFormat.format(dt);
  }
  // yyyy-MM-dd
  else {
    final dtFormat = DateFormat('yyyy-MM-dd',Platform.localeName);
    var str = dtFormat.format(dt);
    return str;
  }
}

String duTimeLineTitle(DateTime dt){
  var now = DateTime.now();
  var difference = now.difference(dt);
  if (difference.inHours < 24) {
    return "Today";
  } else if(difference.inDays < 2){
    return "Yesterday";
  } else{
    final dtFormat = DateFormat('yyyy-MM-dd',Platform.localeName);
    var str = dtFormat.format(dt);
    return str;
  }
}

String duTimeLine(DateTime dt){
  final dtFormat = DateFormat('hh:mm',Platform.localeName);
  return dtFormat.format(dt);
}

String duTimelineDays(DateTime dt){
  var now = DateTime.now();
  var difference = now.difference(dt);
  if (difference.inSeconds < 60) {
    if(difference.inSeconds<0){
      return "just now";
    }
    return "${difference.inSeconds}s ago";
  }else if (difference.inMinutes < 60) {
    return "${difference.inMinutes}m ago";
  }else if (difference.inHours < 24) {
    return "${difference.inHours}h ago";
  }else {
    return "${difference.inDays}days ago";
  }
}
