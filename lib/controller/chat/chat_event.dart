part of 'chat_bloc.dart';

sealed class ChatEvent {}

final class FindUserEvent extends ChatEvent {
  String searchWord;
  FindUserEvent({required this.searchWord});
}

final class ChatButtonClickedEvent extends ChatEvent {
  final String user2;
  final String user1;
  BuildContext context;
  final Map<String, dynamic> userMap;

  ChatButtonClickedEvent(
      {required this.user2,
      required this.user1,
      required this.context,
      required this.userMap});
}
