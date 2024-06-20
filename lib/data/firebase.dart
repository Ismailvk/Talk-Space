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
}
