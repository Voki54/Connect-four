// import 'package:connect_four/features/auth/auth_api.dart';
// import 'package:connect_four/features/auth/auth_models.dart';
// import 'package:connect_four/features/auth/token_storage.dart';
// import 'package:connect_four/features/statistics/statistics_controller.dart';
// import 'package:connect_four/features/statistics/statistics_model.dart';
// import 'package:connect_four/features/user/user_controller.dart';
// import '../core/logger.dart';

// class SyncController {
//   final UserController _userController;
//   final StatisticsController _statisticsController;
//   final AuthApi _authApi;
//   final TokenStorage _tokenStorage;

//   SyncController(
//     this._userController,
//     this._statisticsController,
//     this._authApi,
//     this._tokenStorage,
//   );

//   Future<void> authorizeUser(String username) async {
//     final localUser = await _userController.getUserByUsername(username);

//     logger.info("authorizeUser: localUser - ${localUser}");

//     if (localUser == null) {
//       // пользователь ранее не входил с устройства
//       await _userController.setAuthUserId(username);
//       final user = _userController.user;

//       logger.info("authorizeUser:  user.totalGames - ${user.totalGames}");

//       await _statisticsController.updatePendingStats(
//         StatisticsLocal(
//           totalGames: user.totalGames,
//           winsPlayer1: user.winsPlayer1,
//           winsPlayer2: user.winsPlayer2,
//           draws: user.draws,
//         ),
//       );
//     } else {
//       // пользователя ранее входил с устройства
//       // загрузить его, потом прибавить накопившуюся статистику гостя, удалить гостя
//     }
//   }

//   Future<void> refreshToken() async {
//     final refreshToken = await _tokenStorage.getRefreshToken();

//     if (refreshToken == null) {
//       throw RefreshTokenExpiredException();
//     }

//     final response = await _authApi.refreshToken(
//       RefreshTokenRequest(refreshToken: refreshToken),
//     );

//     await _tokenStorage.saveTokens(
//       accessToken: response.accessToken,
//       refreshToken: response.refreshToken,
//     );
//   }

//   Future<void> logout() async {
//     int statusCode = await _authApi.logout();

//     if (statusCode == 204) {
//       logger.info("Logout success");
//       await _userController.logout();
//       return;
//     }

//     if (statusCode == 401) {
//       logger.info("Logout failed: 401, trying refresh token");

//       await refreshToken();

//       statusCode = await _authApi.logout();

//       if (statusCode == 204) {
//         logger.info("Logout success after refresh");
//         await _userController.logout();
//         return;
//       }
//     }
//   }

//   Future<void> handleRefreshToken() async {
//     try {
//       await refreshToken();
//     } on RefreshTokenExpiredException {
//       await handleRefreshFailure();
//     } catch (e) {
//       logger.severe("Refresh token error - $e");
//     }
//   }

//   Future<void> handleRefreshFailure() async {
//     logger.info("Refresh token expired. Force logout.");
//     await _tokenStorage.clear();
//     await _userController.logout();
//   }
// }
