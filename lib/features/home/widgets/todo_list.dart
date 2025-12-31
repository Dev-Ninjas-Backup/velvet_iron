import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';
import 'package:velvet_iron/core/utils/constants/colors.dart';
import 'package:velvet_iron/core/utils/constants/icon_path.dart';

class TodoSection extends StatelessWidget {
  const TodoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TodoController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "To-do Lists",
              style: getTextStyle(color: Colors.white, fontSize: 18),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textFieldBorderColor),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text("Today", style: getTextStyle(color: Colors.white)),
                  SizedBox(width: 8),
                  Image.asset(
                    "assets/icons/dropdown.png",
                    width: 22,
                    height: 22,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...controller.todos.map(
          (todo) => _TodoTile(
            title: todo.title,
            sub: todo.sub,
            time: todo.time,
            iconPath: todo.iconPath,
            isChecked: todo.isChecked,
          ),
        ),
      ],
    );
  }
}

class _TodoTile extends StatelessWidget {
  final String title, sub, time;
  final String iconPath;
  final RxBool isChecked;

  const _TodoTile({
    required this.title,
    required this.sub,
    required this.time,
    required this.iconPath,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Checkbox(
              value: isChecked.value,
              onChanged: (bool? value) {
                isChecked.value = value ?? false;
              },
              shape: const CircleBorder(),
              activeColor: AppColors.gold,
              checkColor: Colors.black,
              side: const BorderSide(color: Colors.white),
            ),
            const SizedBox(width: 4),
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:  getTextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    sub,
                    style:  getTextStyle(color:  Color.fromARGB(255, 149, 4, 4)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("+10 XP⭐", style: getTextStyle(color: Colors.white),),
                 SizedBox(height: 4),
                Text(time, style: getTextStyle(color: Color(0xFF914C4C))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TodoController extends GetxController {
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
  ];
}

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
