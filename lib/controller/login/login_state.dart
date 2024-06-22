part of 'login_bloc.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginErrorSate extends LoginState {
  final String message;

  LoginErrorSate({required this.message});
}
