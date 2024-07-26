import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class BiometricAuthenticated extends AuthState {}

class AuthenticationFailed extends AuthState {
  final String error;

  AuthenticationFailed(this.error);

  @override
  List<Object> get props => [error];
}

class GoogleSignInInProgress extends AuthState {}

class GoogleSignInSuccess extends AuthState {
  final String displayName;
  final String photoUrl;

  GoogleSignInSuccess({required this.displayName, required this.photoUrl});

  @override
  List<Object> get props => [displayName, photoUrl];
}
class GoogleSignInFailed extends AuthState {
  final String error;

  GoogleSignInFailed(this.error);

  @override
  List<Object> get props => [error];
}