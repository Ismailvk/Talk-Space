import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<FindUserEvent>(findUser);
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
}
