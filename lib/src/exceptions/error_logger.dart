import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//for errors outside providers like services

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    debugPrint('$error, $stackTrace');
  }
}

final errorLoggerProvider = Provider<ErrorLogger>((ref) {
  return ErrorLogger();
});
