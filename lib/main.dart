import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:money_monitor/scoped_models/main.dart';
import 'package:money_monitor/pages/login.dart';
import 'package:money_monitor/pages/home.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  MainModel model = MainModel();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        title: 'Money Monitor',
        home: _authenticateUser(model.loginUser),
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColorLight: Colors.white,
          accentColor: Colors.blueAccent,
        ),
      ),
    );
  }
}

Widget _authenticateUser(Function loginUser) {
  return StreamBuilder<FirebaseUser>(
    stream: _auth.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildSplashScreen();
      } else {
        if (snapshot.hasData) {
          dynamic user = snapshot.data;

          //Fetch User Data
          print(user.displayName);
          loginUser(user.displayName, user.uid, user.email, user.photoUrl);
          return HomePage();
        }
        return LoginScreen();
      }
    },
  );
}

Widget _buildSplashScreen() {
  return Scaffold(
    body: Center(
      child: Text("Loading..."),
    ),
  );
}
