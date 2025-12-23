import 'package:flutter/material.dart';
import 'package:velvet_iron/core/common/styles/global_text_style.dart';

class RememberWidget extends StatelessWidget {
  const RememberWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (value) {},
          activeColor: Colors.white,
          checkColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        Text(
          'Remember me',
          style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        Spacer(),
        Text(
          'Forgot Password?',
          style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
