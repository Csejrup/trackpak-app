import 'dart:io';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
          emit(LoggedIn(userProfile: credentials.user));
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
      emit(LoggedIn(userProfile: credentials.user));
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
