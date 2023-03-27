import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/auth_services.dart';

import 'Screens/home_screen.dart';
import 'Screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Firebase',
    theme: ThemeData(brightness: Brightness.dark),
    home: StreamBuilder(
        stream: AuthService().firebaseAuth.authStateChanges(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return HomeScreen(snapshot.data);
          }
          return RegisterScreen();
        }),
  ));
}
