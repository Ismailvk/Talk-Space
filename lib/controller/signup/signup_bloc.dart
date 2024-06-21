import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talk_space/views/login_screen.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupUserEvent>(signupUser);
  }

  FutureOr<void> signupUser(
      SignupUserEvent event, Emitter<SignupState> emit) async {
    emit(SignupLoadingState());
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      print('here');
      User? user = (await auth.createUserWithEmailAndPassword(
              email: event.email, password: event.password))
          .user;
      if (user != null) {
        print('Account Created Successfull $user');
        Navigator.of(event.context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        print('Account Creation Failed');
        emit(SignupFailedState(message: 'Account Creation Failed'));
      }
    } catch (e) {
      print(e);
      emit(SignupFailedState(message: e.toString()));
    }
  }
}
