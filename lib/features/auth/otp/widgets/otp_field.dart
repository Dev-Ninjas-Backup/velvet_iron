import 'package:flutter/material.dart';

class OtpField extends StatelessWidget {
  const OtpField({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          return Container(
            width: 80,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF521212),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: const Color(0xFF6B1717), width: 1.0),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: '',
                fillColor: Colors.transparent,
                filled: true,
                contentPadding: const EdgeInsets.all(0),
              ),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          );
        }),
      ),
    );
  }
}
