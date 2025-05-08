import 'package:flutter/material.dart';
showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}


class HaveAccountWidget extends StatelessWidget {
  const HaveAccountWidget({
    super.key,
    required this.label,
    required this.labelAction,
    required this.onPressed,
  });

  final String label;
  final String labelAction;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            labelAction,
            style: const TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        ),
      ],
    );
  }
}
