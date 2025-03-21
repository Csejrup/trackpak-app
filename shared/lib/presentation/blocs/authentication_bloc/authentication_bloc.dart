import 'dart:io';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared/providers/providers.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  late final Auth0 auth0;
  final SecureStorageProvider secureStorage;
  final String auth0Domain;
  final String auth0ClientId;
  final String audience;

  AuthenticationBloc({
    required this.secureStorage,
    required this.auth0Domain,
    required this.auth0ClientId,
    this.audience = 'https://trackpak-prod.azurewebsites.net',
  }) : super(AuthInitialState()) {
    auth0 = Auth0(auth0Domain, auth0ClientId);

    on<AuthInit>((event, emit) async {
      await _handleAuthInit(emit);
    });

    on<LogIn>((event, emit) async {
      await _handleLogin(emit);
    });

    on<LogOut>((event, emit) async {
      await _handleLogout(emit);
    });

    on<DeleteAccount>((event, emit) async {
      try {
        await secureStorage.deleteKey('access_token');
        await secureStorage.deleteKey('id_token');
        emit(LoggedOut());
      } catch (e) {
        emit(LoginFailed(message: 'Account deletion failed: ${e.toString()}'));
      }
    });
  }

  /// Handles authentication initialization (checking for stored tokens)
  Future<void> _handleAuthInit(Emitter<AuthenticationState> emit) async {
    final storedAccessToken = await secureStorage.readString('access_token');

    if (storedAccessToken != null) {
      try {
        final hasValidCreds =
            await auth0.credentialsManager.hasValidCredentials();

        if (hasValidCreds) {
          final credentials = await auth0.credentialsManager.credentials();
          Map<String, dynamic> decodedToken = JwtDecoder.decode(
            credentials.accessToken,
          );

          final userId = decodedToken['https://trackpak.com/user_id'];
          final companyId = decodedToken['https://trackpak.com/company_id'];
          final employeeId = decodedToken['https://trackpak.com/employee_id'];
          final token = credentials.accessToken;
          const chunkSize = 512;
          for (var i = 0; i < token.length; i += chunkSize) {
            debugPrint(
              token.substring(
                i,
                i + chunkSize > token.length ? token.length : i + chunkSize,
              ),
            );
          }
          emit(
            LoggedIn(
              userProfile: credentials.user,
              userId: userId,
              companyId: companyId,
              employeeId: employeeId,
              accessToken: credentials.accessToken,
            ),
          );
        } else {
          await secureStorage.deleteKey('access_token');
          emit(LoggedOut());
        }
      } catch (e) {
        await secureStorage.deleteKey('access_token');
        emit(LoggedOut());
      }
    } else {
      emit(LoggedOut());
    }
  }

  /// Handles user login flow

  Future<void> _handleLogin(Emitter<AuthenticationState> emit) async {
    try {
      final credentials = await auth0.webAuthentication().login(
        useEphemeralSession: true,
        audience: audience,
        scopes: {'offline_access', 'email', 'profile'},
        parameters: {'screen_hint': 'login'},
      );

      await secureStorage.writeString('access_token', credentials.accessToken);
      await secureStorage.writeString('id_token', credentials.idToken);

      // Decode access token to fetch custom claims
      Map<String, dynamic> decodedToken = JwtDecoder.decode(
        credentials.accessToken,
      );

      final userId = decodedToken['https://trackpak.com/user_id'];
      final companyId = decodedToken['https://trackpak.com/company_id'];
      final employeeId = decodedToken['https://trackpak.com/employee_id'];

      emit(
        LoggedIn(
          userProfile: credentials.user,
          userId: userId,
          companyId: companyId,
          employeeId: employeeId,
          accessToken: credentials.accessToken,
        ),
      );
    } catch (e) {
      emit(LoginFailed(message: 'Login failed: ${e.toString()}'));
    }
  }

  /// Handles user logout flow
  Future<void> _handleLogout(Emitter<AuthenticationState> emit) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await auth0
            .webAuthentication(scheme: 'com.example.driver_app')
            .logout();
      }

      await secureStorage.deleteKey('access_token');
      await secureStorage.deleteKey('id_token');

      emit(LoggedOut());
    } catch (e) {
      emit(LoginFailed(message: 'Logout failed: ${e.toString()}'));
    }
  }
}
