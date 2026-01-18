import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class ExerciseNameTextField extends StatelessWidget {
  const ExerciseNameTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        cursorColor: const Color(0xFFDCAA64),
        style: getTextStyle(fontSize: 12, color: Colors.white),
        decoration: InputDecoration(
          hintText: "e.g. push ups",
          hintStyle:
              getTextStyle(fontSize: 12, color: const Color(0xFF723737)),
          filled: true,
          fillColor: const Color(0xFF3A0303),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 1.11),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFFDCAA64), width: 1.11),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFFDCAA64), width: 1.11),
          ),
        ),
      ),
    );
  }
}
