import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/auth_services.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.teal,
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
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("All field are required"),
                              backgroundColor: Colors.red,
                            ));
                          } else {
                            User? result = await AuthService().login(
                                emailController.text,
                                passwordController.text,
                                context);
                            if (result != null) {
                              debugPrint("Successfully login");
                              // ignore: use_build_context_synchronously
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(result)),
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
          ],
        ),
      ),
    );
  }
}
