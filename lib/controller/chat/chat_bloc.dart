import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talk_space/views/personal_chat_room_scree.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<FindUserEvent>(findUser);
    on<ChatButtonClickedEvent>(chatButtonClick);
    on<SendMessageEvent>(sendMessage);
  }

  FutureOr<void> findUser(FindUserEvent event, Emitter<ChatState> emit) async {
    emit(FindUserLoadingState());
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      await firestore
          .collection('user')
          .where('email', isEqualTo: event.searchWord)
          .get()
          .then((value) {
        Map<String, dynamic> userMap = value.docs[0].data();
        print('userMap is $userMap');
        emit(FindUserSuccessState(userMap: userMap));
      });
    } catch (e) {
      //
    }
  }

  FutureOr<void> chatButtonClick(
      ChatButtonClickedEvent event, Emitter<ChatState> emit) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String chatId = '';
    try {
      print('-----------');
      print('user 1${event.user1}');
      print('user 2${event.user2}');
      print('-----------');
      if (auth.currentUser?.displayName != null) {
        String user1 = event.user1;

        if (user1[0].toLowerCase().codeUnits[0] >
            event.user2.toLowerCase().codeUnits[0]) {
          chatId = '$user1${event.user2}';
          print('----------00000-');

          print(chatId);
          Navigator.of(event.context).push(MaterialPageRoute(
              builder: (context) => PersonalChatRoom(
                    roomId: chatId,
                    userMap: event.userMap,
                  )));
        } else {
          chatId = '${event.user2}$user1';
          print('--------9999999999---');

          print(chatId);
          Navigator.of(event.context).push(
            MaterialPageRoute(
              builder: (context) => PersonalChatRoom(
                roomId: chatId,
                userMap: event.userMap,
              ),
            ),
          );
        }
      }
    } catch (e) {
      //
    }
  }

  FutureOr<void> sendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    emit(FindUserLoadingState());
    try {
      Map<String, dynamic> message = {
        'sendby': event.authName,
        'message': event.message,
        'time': FieldValue.serverTimestamp(),
      };
      await firestore
          .collection('chatroom')
          .doc(event.roomId)
          .collection('chats')
          .add(message);

      emit(SendMessageSuccessState(message: message));
    } catch (e) {
      //
    }
  }
}
