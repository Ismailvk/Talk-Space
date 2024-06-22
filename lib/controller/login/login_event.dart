part of 'login_bloc.dart';

sealed class LoginEvent {}

final class LoginUser extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context;

  LoginUser(
      {required this.context, required this.email, required this.password});
}

final class LogoutUser extends LoginEvent {
  BuildContext context;

  LogoutUser({required this.context});
}
