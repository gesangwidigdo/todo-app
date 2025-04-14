import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.buttonText,
    required this.backgroundColor,
    required this.buttonFunction,
  });

  final String buttonText;
  final MaterialColor backgroundColor;
  final VoidCallback buttonFunction;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonFunction,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
      ),
      child: Text(buttonText),
    );
  }
}