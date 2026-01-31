import 'package:get/get.dart';

class MySubscriptionController extends GetxController {
  RxBool isPremium = true.obs;

  String price = "USD \$9.00";
  String renewDate = "Jul 15, 2025";
  String expireDate = "Aug 15, 2025";

  void cancelSubscription() {
    // API call later
  }

  void renewSubscription() {
    // API call later
  }
}
