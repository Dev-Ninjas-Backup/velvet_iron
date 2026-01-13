import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class NoteTextField extends StatelessWidget {
  const NoteTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 69,
      child: TextFormField(
        maxLines: 3,
        style: getTextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: "How are you feeling today?",
          hintStyle: getTextStyle(
            fontSize: 12,
            color: const Color(0xFF723737),
          ),
          filled: true,
          fillColor: const Color(0xFF3A0303),
          contentPadding: const EdgeInsets.all(12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.white12,
              width: 1.11,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFDCAA64),
              width: 1.11,
            ),
          ),
        ),
      ),
    );
  }
}
