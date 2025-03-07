/*
LOGIN PAGE

on this page an existing user can login to the app

-email
-password

-------------------------------------------------------------
once the user logs in, the app navigates to the home page

if the user is not registered, they can navigate to the register page
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/presentation/components/my_button.dart';
import 'package:socialapp/features/auth/presentation/components/my_text_field.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controller for the text field
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  void Login() {
    // login function
    final String email = emailcontroller.text;
    final String password = passwordcontroller.text;

    //auth cubit

    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      // show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.lock_open_rounded,
              size: 100,
              color: Colors.black54,
            ),
            const SizedBox(height: 50),
            Text(
              "Login Page",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 25),
            MyTextField(
                controller: emailcontroller,
                hintText: "Email",
                obscureText: false),
            const SizedBox(height: 20),
            MyTextField(
                controller: passwordcontroller,
                hintText: "Password",
                obscureText: true),
            const SizedBox(height: 20),
            MyButton(
              text: "Login",
              onTap: () {
                Login();
              },
            ),

            const SizedBox(height: 50),

            // navigate to the register page

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: widget.togglePages,
                  child: Text(
                    " Register",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    )));
  }
}
