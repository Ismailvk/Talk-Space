part of 'chat_bloc.dart';

sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class FindUserLoadingState extends ChatState {}

final class FindUserSuccessState extends ChatState {
  Map<String, dynamic> userMap;

  FindUserSuccessState({required this.userMap});
}

final class SendMessageSuccessState extends ChatState {
  final Map<String, dynamic> message;

  SendMessageSuccessState({required this.message});
}
