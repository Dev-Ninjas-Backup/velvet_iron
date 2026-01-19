import 'package:get/get.dart';

class TodoModel {
  final String title, sub, time;
  final String iconPath;
  final RxBool isChecked = false.obs;

  TodoModel({
    required this.title,
    required this.sub,
    required this.time,
    required this.iconPath,
  });
}
