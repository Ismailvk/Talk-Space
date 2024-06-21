part of 'signup_bloc.dart';

sealed class SignupState {}

final class SignupInitial extends SignupState {}

final class SignupLoadingState extends SignupState {}

final class SignupSuccessState extends SignupState {}

final class SignupFailedState extends SignupState {
  final String message;

  SignupFailedState({required this.message});
}
