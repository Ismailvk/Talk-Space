part of 'signup_bloc.dart';

sealed class SignupEvent {}

final class SignupUserEvent extends SignupEvent {
  final String name;
  final String email;
  final String password;
  BuildContext context;

  SignupUserEvent(
      {required this.context,
      required this.name,
      required this.email,
      required this.password});
}
