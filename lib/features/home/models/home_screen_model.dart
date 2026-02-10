import 'package:get/get.dart';

class HomeScreenModel {
  String title;
  String sub;
  String time;
  String iconPath;
  int xp;
  RxBool isChecked;

  HomeScreenModel({
    required this.title,
    required this.sub,
    required this.time,
    required this.iconPath,
    this.xp = 10,
    bool isChecked = false,
  }) : isChecked = isChecked.obs;
}