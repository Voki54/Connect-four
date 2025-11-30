import 'package:logging/logging.dart';

final Logger logger = Logger('AppLogger');

void setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print(
      '${record.level.name}: '
      '${record.time}: '
      '${record.message}',
    );
  });
}
