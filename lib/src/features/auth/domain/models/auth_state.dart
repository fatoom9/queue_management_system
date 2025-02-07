import 'package:flutter/material.dart';

@immutable
class AuthState {
  final bool isAuthenticated;
  final String? adminEmail;

  const AuthState({
    this.isAuthenticated = false,
    this.adminEmail,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? adminEmail,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      adminEmail: adminEmail ?? this.adminEmail,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState && runtimeType == other.runtimeType && isAuthenticated == other.isAuthenticated && adminEmail == other.adminEmail;

  @override
  int get hashCode => isAuthenticated.hashCode ^ adminEmail.hashCode;
}
