import 'package:get/get.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';
import 'package:velvet_iron/features/home/models/todo_model.dart';

class HomeController extends GetxController {
  final selectedMood = 1.obs;

  final todos = <TodoModel>[
    TodoModel(
      title: "Breakfast",
      sub: "350 kcal",
      time: "Wed - 8:30 AM",
      iconPath: IconPath.todo,
    ),
    TodoModel(
      title: "Ozempic (4mg)",
      sub: "1 Injection",
      time: "Wed - 09:30 AM",
      iconPath: IconPath.todo2,
    ),
    TodoModel(
      title: "Walk the dog",
      sub: "30 minutes",
      time: "Wed - 06:00 PM",
      iconPath: IconPath.grass,
    ),
    TodoModel(
      title: "Vitamin B12 Shot",
      sub: "1 Injection",
      time: "Wed - 07:00 PM",
      iconPath: IconPath.injection,
    ),
  ];
}
