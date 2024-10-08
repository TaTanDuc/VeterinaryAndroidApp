import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({super.key, 
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF5CB15A),
    this.textColor = const Color(0xFF000000),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor, // Màu chữ
        backgroundColor: backgroundColor, // Màu nền
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 30,
            fontFamily: 'Fredoka',
          ),
        ),
      ),
    );
  }
}
