import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:money_monitor/scoped_models/main.dart';
import 'package:money_monitor/pages/login.dart';
import 'package:money_monitor/pages/home.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
        title: 'Money Monitor',
        home: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget widget, MainModel model) {
            return _authenticateUser(model.loginUser);
          },
        ),
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
