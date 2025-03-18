import 'package:equatable/equatable.dart';

/// User model
///
/// [User.empty] represents an unauthenticated user.
class User extends Equatable {
  final String name;
  final String email;
  final String password;

  const User({required this.name, required this.email, required this.password});

  /// Empty user which represents an unauthenticated user.
  static const empty = User(name: '', email: '', password: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [name, email, password];
}
