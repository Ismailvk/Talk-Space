import 'package:firebase_auth/firebase_auth.dart';

class FirebaseMethods {
  Future<User?> createAccount(
      String name, String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      User? user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        print('Account Created Successfull $user');
        return user;
      } else {
        print('Account Creation Failed');
        return user;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      User? user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        print('Login Successfull $user');
        return user;
      } else {
        print('Login Failed');
        return user;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signOut();
    } catch (e) {
      print('Error Occured');
    }
  }
}
