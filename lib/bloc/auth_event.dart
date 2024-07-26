import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticateWithBiometrics extends AuthEvent {}

class SignInWithGoogle extends AuthEvent {}