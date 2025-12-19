// import 'package:connect_four/features/core/ui/theme.dart';
// import 'package:flutter/material.dart';

// class MainMenuButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;

//   const MainMenuButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 375,
//       height: 56,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           textStyle: lightTheme.textTheme.headlineMedium,
//         ),
//         onPressed: onPressed,
//         child: Text(text),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:connect_four/features/core/ui/theme.dart';

class MainMenuButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final VoidCallback? onAnimationComplete;

  const MainMenuButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.onAnimationComplete,
  });

  @override
  State<MainMenuButton> createState() => _MainMenuButtonState();
}

class _MainMenuButtonState extends State<MainMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _contentScaleAnimation;
  late Animation<double> _contentOpacityAnimation;
  late Animation<double> _contentTranslateAnimation;
  late Animation<Color?> _contentColorAnimation;
  late Animation<Color?> _textColorAnimation;
  
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Анимация масштаба содержимого (прожатие)
    _contentScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    // Анимация прозрачности содержимого
    _contentOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );

    // Анимация перемещения содержимого вниз (в пределах границы)
    _contentTranslateAnimation = Tween<double>(
      begin: 0.0,
      end: 56.0, // Высота кнопки - содержимое уедет полностью за нижнюю границу
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );

    // Анимация цвета фона содержимого
    _contentColorAnimation = ColorTween(
      begin: lightTheme.colorScheme.background,
      end: lightTheme.primaryColor.withOpacity(0.8),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    // Анимация цвета текста
    _textColorAnimation = ColorTween(
      begin: lightTheme.colorScheme.onBackground,
      end: Colors.white,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
        widget.onPressed(); // Вызываем действие после завершения анимации
        _resetAnimation(); // Сбрасываем анимацию для повторного использования
      }
    });
  }

  void _resetAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.reset();
      _isAnimating = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isAnimating) return; // Защита от повторного нажатия во время анимации
    
    _isAnimating = true;
    _controller.forward(); // Только запускаем анимацию
    // Действие widget.onPressed() будет вызвано в слушателе статуса
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375,
      height: 56,
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: lightTheme.primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: lightTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.transparent,
                    ),
                    Transform.translate(
                      offset: Offset(0, _contentTranslateAnimation.value),
                      child: Opacity(
                        opacity: _contentOpacityAnimation.value,
                        child: Transform.scale(
                          scale: _contentScaleAnimation.value,
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            color: _contentColorAnimation.value,
                            child: Center(
                              child: Text(
                                widget.text,
                                style: lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _textColorAnimation.value,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}