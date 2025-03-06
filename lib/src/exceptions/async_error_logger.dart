import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue_management_system/src/exceptions/app_exceptions.dart';

//for errors inside providers
// work with StateNotifier or FutureProvider
class AsyncErrorLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final error = _findError(newValue);

    if (error != null) {
      if (error.error is AppException) {
        debugPrint(error.error.toString());
      } else {
        debugPrint(error.toString());
      }
    }
  }

  AsyncError<dynamic>? _findError(Object? value) {
    if (value is AsyncError) {
      return value;
    } else {
      return null;
    }
  }
}
