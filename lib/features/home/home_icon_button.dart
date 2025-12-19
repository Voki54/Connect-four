import 'package:flutter/material.dart';

class HomeIconButton extends StatelessWidget {
  final EdgeInsets padding;
  final Icon icon;
  final double iconSize;
  final VoidCallback onPressed;

  const HomeIconButton({
    super.key,
    required this.padding,
    required this.icon,
    required this.iconSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: padding,
          child: IconButton(
            icon: icon,
            iconSize: iconSize,
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
