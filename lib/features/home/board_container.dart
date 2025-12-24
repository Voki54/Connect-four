import 'package:flutter/material.dart';

class BoardContainer extends StatelessWidget {
  final Widget child;
  final ThemeData theme;

  const BoardContainer({super.key, required this.child, required this.theme});

  @override
  Widget build(BuildContext context) {
    final BorderSide baseBorderSide = BorderSide(
      color: theme.dividerColor,
      width: 4,
    );

    final BorderSide wideBorderSide = BorderSide(
      color: theme.dividerColor,
      width: 5,
    );

    final List<BoxShadow> boardShadow = [
      BoxShadow(color: theme.dividerColor, offset: Offset(5, 0)),
      BoxShadow(
        color: theme.scaffoldBackgroundColor,
        blurRadius: 0,
        spreadRadius: 0,
        offset: Offset(0, 0),
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Expanded(
        //   child:
        Container(
          width: MediaQuery.of(context).size.width * 0.55,
          height: MediaQuery.of(context).size.height * 0.77,
          // margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              top: baseBorderSide,
              left: baseBorderSide,
              right: wideBorderSide,
              bottom: BorderSide.none,
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50),
              bottom: Radius.circular(0),
            ),
            boxShadow: boardShadow,
          ),
          child: child,
          // ),
        ),

        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,

            // height: 52,
            decoration: BoxDecoration(
              border: Border(
                top: baseBorderSide,
                left: baseBorderSide,
                right: wideBorderSide,
                bottom: baseBorderSide,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18),
                bottom: Radius.circular(0),
              ),
              boxShadow: boardShadow,
            ),
          ),
        ),
      ],
    );
  }
}
