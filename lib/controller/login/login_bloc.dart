// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talk_space/views/home_screen.dart';
import 'package:talk_space/views/login_screen.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginUser>(loginUser);
    on<LogoutUser>(logoutUser);
  }

  FutureOr<void> loginUser(LoginUser event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      User? user = (await auth.signInWithEmailAndPassword(
              email: event.email, password: event.password))
          .user;

      if (user != null) {
        print('Login Successfull the user :$user');
        print(user.displayName);
        Navigator.of(event.context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => HomeScreen(user1: user.displayName!)),
            (route) => false);
      } else {
        print('Login Failed');
        emit(LoginErrorSate(message: "Login Failed"));
      }
    } catch (e) {
      print('Error got $e');
      emit(LoginErrorSate(message: e.toString()));
    }
  }

  FutureOr<void> logoutUser(LogoutUser event, Emitter<LoginState> emit) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await auth.signOut();
      await firestore
          .collection('user')
          .doc(auth.currentUser?.uid)
          .update({"status": "Offline"});
      Navigator.of(event.context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    } catch (e) {
      print('Error Occured');
    }
  }
}
