import 'package:logger/logger.dart';

class LoggingService {
  static final LoggingService _instance = LoggingService._internal();
  late Logger logger;

  factory LoggingService() {
    return _instance;
  }

  LoggingService._internal() {
    logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    );
  }

  void debug(dynamic message) => logger.d(message);
  void info(dynamic message) => logger.i(message);
  void warning(dynamic message) => logger.w(message);
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) => 
      logger.e(message, error: error, stackTrace: stackTrace);
}

// Create a global instance for easy access
final log = LoggingService();