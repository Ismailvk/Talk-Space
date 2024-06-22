part of 'chat_bloc.dart';

sealed class ChatEvent {}

final class FindUserEvent extends ChatEvent {
  String searchWord;
  FindUserEvent({required this.searchWord});
}
