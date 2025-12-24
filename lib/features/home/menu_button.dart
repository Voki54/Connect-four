import 'package:connect_four/features/core/ui/theme.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final int width;
  final int height;

  final BorderSide baseBorderSide = BorderSide(
    color: lightTheme.dividerColor,
    width: 4,
  );

  final BorderSide wideBorderSide = BorderSide(
    color: lightTheme.dividerColor,
    width: 6,
  );

  final List<BoxShadow> boardShadow = [
    BoxShadow(color: Color.fromARGB(70, 77, 84, 81), offset: Offset(0, 0)), //Color.fromARGB(77, 84, 81, 50) lightTheme.dividerColor
    BoxShadow(
      color: lightTheme.scaffoldBackgroundColor,
      blurRadius: 0,
      spreadRadius: 0,
      offset: Offset(5, 9), //6, 7
    ),
  ];

  MenuButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.toDouble(),
      height: height.toDouble(),
      decoration: BoxDecoration(
        border: Border(
          top: baseBorderSide,
          left: baseBorderSide,
          right: baseBorderSide,
          bottom: baseBorderSide,
        ),
        borderRadius: BorderRadius.all(Radius.circular(50)),
        boxShadow: boardShadow,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          textStyle: lightTheme.textTheme.bodyLarge,
          foregroundColor: lightTheme.dividerColor,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
