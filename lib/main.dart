import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:money_monitor/scoped_models/main.dart';
import 'package:money_monitor/pages/login.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

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
          //Fetch User Data
          return _buildMainScreen(user: snapshot.data, loginUser: loginUser);
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

Widget _buildMainScreen({user, loginUser}) {
  loginUser(user.displayName, user.uid, user.email, user.photoUrl);
  return Scaffold(
    appBar: AppBar(
      title: Text("Money Monitor"),
    ),
    body: Column(
      children: <Widget>[
        Center(
          child: Text(user.displayName +
              " " +
              user.uid +
              " " +
              user.photoUrl +
              " " +
              user.email),
        ),
        RaisedButton(
          child: Text("Sign Out"),
          onPressed: () {
            _auth.signOut();
          },
        ),
      ],
    ),
  );
}
