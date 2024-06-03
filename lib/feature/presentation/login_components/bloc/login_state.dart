import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final User userCredential;
  LoginSuccessState({required this.userCredential});
}

class LoginFailState extends LoginState {}

class LoginCredentialNullState extends LoginState {}

class LoginAlreadyExistsState extends LoginState {}
