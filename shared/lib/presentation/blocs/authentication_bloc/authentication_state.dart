part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthInitialState extends AuthenticationState {}

class LoggedOut extends AuthenticationState {}

class LoggedIn extends AuthenticationState {
  final UserProfile userProfile;
  const LoggedIn({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

class LoginFailed extends AuthenticationState {
  final String message;
  const LoginFailed({required this.message});

  @override
  List<Object> get props => [message];
}

// Some other states to consider
class EmailVerifyFailed extends AuthenticationState {}

class LoginTimedOut extends AuthenticationState {}
