import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/presentation/components/my_button.dart';
import 'package:socialapp/features/auth/presentation/components/my_text_field.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmPwcontroller = TextEditingController();
  late final AuthCubit authCubit;

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
  }

  void register() {
    final String email = emailcontroller.text;
    final String name = namecontroller.text;
    final String password = passwordcontroller.text;
    final String confirmPw = confirmPwcontroller.text;

    if (email.isNotEmpty &&
        name.isNotEmpty &&
        password.isNotEmpty &&
        confirmPw.isNotEmpty) {
      if (password == confirmPw) {
        authCubit.register(email, password, name);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Passwords do not match"),
            backgroundColor: Colors.black,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    namecontroller.dispose();
    passwordcontroller.dispose();
    confirmPwcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.lock_open_rounded,
              size: 100,
              color: Colors.black54,
            ),
            const SizedBox(height: 50),
            Text(
              "Create Account",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 25),
            MyTextField(
                controller: namecontroller,
                hintText: "Name",
                obscureText: false),
            const SizedBox(height: 20),
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
            MyTextField(
                controller: confirmPwcontroller,
                hintText: "Confirm Password",
                obscureText: true),
            const SizedBox(height: 50),
            MyButton(
              text: "Register",
              onTap: () {
                print("PASSWORD_CHECKPassword: " + passwordcontroller.text);
                register();
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a member ? ",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: widget.togglePages,
                  child: Text(
                    " Login here",
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
