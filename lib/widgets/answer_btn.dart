// widgets/answer_btn.dart
import 'package:flutter/material.dart';

class AnswerBtn extends StatelessWidget {
  final String title;
  final VoidCallback handleOnPress;
  final bool isSelected;

  const AnswerBtn(
    this.title,
    this.handleOnPress, {
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: handleOnPress,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            isSelected ? Colors.blue.shade100 : Color.fromARGB(255, 0, 54, 101),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.all(16)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.blue.shade800 : Colors.white,
          ),
        ),
      ),
    );
  }
}