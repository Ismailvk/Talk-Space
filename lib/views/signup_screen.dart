import 'package:flutter/material.dart';
import 'package:talk_space/resources/constants/image_urls.dart';
import 'package:talk_space/resources/widgets/button_widget.dart';
import 'package:talk_space/resources/widgets/textfield.dart';
import 'package:talk_space/utils/validation.dart';

// ignore: must_be_immutable
class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> signupKey = GlobalKey<FormState>();

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
                    'Welcome !! \nCreate Your Account',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                  ),
                  SizedBox(height: size.height / 14),
                  Center(child: Image.asset(ImageUrls.loginImage)),
                  SizedBox(height: size.height * 0.02),
                  Form(
                    key: signupKey,
                    child: Column(
                      children: [
                        MyTextField(
                          icon: Icons.lock_open,
                          feald: 'Name',
                          validator: (value) =>
                              Validations.isEmpty(value, 'Name'),
                          controller: nameController,
                          hintText: 'Enter Your Name',
                        ),
                        SizedBox(height: size.height * 0.02),
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
                              Validations.isEmpty(value, 'Passoword'),
                          controller: passwordController,
                          hintText: 'Enter Your Password',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  ButtonWidget(
                    title: 'Create Account',
                    onPress: () {
                      if (signupKey.currentState!.validate()) {}
                    },
                  ),
                  SizedBox(height: size.height * 0.01),
                  const Center(child: Text('Login'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
