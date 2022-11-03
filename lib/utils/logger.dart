import "package:logger/logger.dart";

final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);

void info(
  String message, {
  Map<String, dynamic>? data,
}) =>
    logger.i(
      data != null ? "$message: $data" : message,
    );

void warn(
  String message, {
  Map<String, dynamic>? data,
}) =>
    logger.w(
      data != null ? "$message: $data" : message,
    );

void error(
  String message, {
  Map<String, dynamic>? data,
}) =>
    logger.e(
      data != null ? "$message: $data" : message,
    );
