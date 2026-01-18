import 'package:get/get.dart';

class DailyLogController extends GetxController {
  final selectedTab = 0.obs;

  void setTab(int index) => selectedTab.value = index;
}

