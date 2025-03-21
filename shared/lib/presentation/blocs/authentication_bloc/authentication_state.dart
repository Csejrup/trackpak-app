part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthenticationState {}

class LoggedOut extends AuthenticationState {}

class LoggedIn extends AuthenticationState {
  final UserProfile userProfile;
  final String? userId;
  final String? companyId;
  final String? employeeId;
  final String accessToken;
  const LoggedIn({
    required this.userProfile,
    this.userId,
    this.companyId,
    this.employeeId,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [userProfile, userId, companyId, employeeId];
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
