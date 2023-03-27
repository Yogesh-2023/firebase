import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/auth_services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              loading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            if (emailController.text == "" ||
                                passwordController.text == "") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("All fields are required"),
                                backgroundColor: Colors.red,
                              ));
                            } else if (passwordController.text !=
                                confirmPasswordController.text) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Password don't match"),
                                backgroundColor: Colors.red,
                              ));
                            } else {
                              User? result = await AuthService().register(
                                  emailController.text,
                                  passwordController.text,
                                  context);
                              if (result != null) {
                                debugPrint("Success");
                                // ignore: use_build_context_synchronously
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomeScreen(result)),
                                    (route) => false);
                              }
                            }
                            setState(() {
                              loading = false;
                            });
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  "Already have an account? Login here",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              loading
                  ? CircularProgressIndicator()
                  : SignInButton(Buttons.Google, text: "Continue with Google",
                      onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await AuthService().signInWithGoogle();
                      setState(() {
                        loading = false;
                      });
                    }),
            ],
          )),
    );
  }
}
