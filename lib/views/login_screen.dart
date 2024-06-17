import 'package:flutter/material.dart';
import 'package:talk_space/resources/constants/image_urls.dart';
import 'package:talk_space/resources/widgets/button_widget.dart';
import 'package:talk_space/resources/widgets/textfield.dart';
import 'package:talk_space/utils/validation.dart';
import 'package:talk_space/views/signup_screen.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome !! \nSign in to continue',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                  ),
                  SizedBox(height: size.height / 14),
                  Center(child: Image.asset(ImageUrls.loginImage)),
                  SizedBox(height: size.height * 0.02),
                  Form(
                    key: loginKey,
                    child: Column(
                      children: [
                        MyTextField(
                          icon: Icons.email_outlined,
                          feald: 'Email',
                          validator: (value) =>
                              Validations.isEmpty(value, 'Email'),
                          controller: emailController,
                          hintText: 'Enter Your Email',
                        ),
                        SizedBox(height: size.height * 0.02),
                        MyTextField(
                          icon: Icons.lock_open,
                          feald: 'Password',
                          validator: (value) =>
                              Validations.isEmpty(value, 'Password'),
                          controller: passwordController,
                          hintText: 'Enter Your Password',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  ButtonWidget(
                    title: 'Login',
                    onPress: () {
                      if (loginKey.currentState!.validate()) {
                        //
                      }
                    },
                  ),
                  SizedBox(height: size.height * 0.01),
                  GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignupScreen())),
                      child: const Center(child: Text('Create an account')))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
