import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:velvet_iron/core/common/widgets/custom_back_button.dart';
import 'package:velvet_iron/features/bottom_nav/controller/bottom_nav_controller.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});
  BottomNavController get bottomNavController =>
      Get.find<BottomNavController>();
  @override
  Widget build(BuildContext context) {
    final navController = bottomNavController;
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            title: FigmaBackButton(
              onPressed: () {
                navController.changeTabIndex(0);
              },
              appBarTitle: 'Quests',
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
          ],
        ),
      ),
    );
  }
}
