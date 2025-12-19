import '../core/ui/theme.dart';
import '../user/user_model.dart';
import 'package:flutter/material.dart';
import 'home_controller.dart';
import 'main_menu_button.dart';
import 'package:get_it/get_it.dart';
import '../user/user_controller.dart';
import '../core/logger.dart';
import '../core/ui/my_icon_data.dart';
import 'home_icon_button.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomecreenState();
}

class _HomecreenState extends State<HomeScreen> {

  final BorderSide baseBorderSide = BorderSide(
    color: lightTheme.dividerColor,
    width: 4,
  );

  final BorderSide wideBorderSide = BorderSide(
    color: lightTheme.dividerColor,
    width: 5,
  );

  final List<BoxShadow> boardShadow = [
    BoxShadow(color: lightTheme.dividerColor, offset: Offset(5, 0)),
    BoxShadow(
      color: lightTheme.scaffoldBackgroundColor,
      blurRadius: 0,
      spreadRadius: 0,
      offset: Offset(0, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final userC = GetIt.I<UserController>();
    logger.info("HomeScreen: authId - ${userC.user.authId}, isGuest - ${userC.user.isGuest},");
    // return FutureBuilder<UserLocal>(
    //   // 2. Говорим FutureBuilder: дождись загрузки контроллера
    // future: _loadUserController(),

    //   // 3. Получаем snapshot — в нём статус загрузки
    //   builder: (context, snapshot) {
    //     // Пока future выполняется — показываем loader
    //     if (!snapshot.hasData) {
    //       return const Scaffold(
    //         body: Center(child: CircularProgressIndicator()),
    //       );
    //     }

    // Когда контроллер готов — достаём его
    // _user = snapshot.data!;
    // final homeController = HomeController();
    // logger.info("userId homeScreen - ${_user.localId}");

    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HomeIconButton(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
              icon: const Icon(MyIcons.documentation),
              iconSize: 75,
              onPressed: () {
                () => print('К докам');
              },
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 57,
                      vertical: 16,
                    ),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MainMenuButton(
                          text: 'Новая игра',
                          onPressed: () =>
                              context.go('/start_game'),
                        ),

                        MainMenuButton(
                          text: 'Продолжить игру',
                          onPressed: () => print('Продолжить игру'),
                        ),

                        MainMenuButton(
                          text: 'Настройки',
                          onPressed: () => print('Настройки'),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: 535,
                  height: 52,

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
              ],
            ),

            HomeIconButton(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 40),
              icon: const Icon(MyIcons.statistics),
              iconSize: 83,
              onPressed: () {
                context.go('/statistics');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ,);
  // }
}
