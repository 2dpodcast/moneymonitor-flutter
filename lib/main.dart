import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      home: _authenticateUser(),
    );
  }
}

Widget _authenticateUser() {
  return StreamBuilder<FirebaseUser>(
    stream: _auth.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildSplashScreen();
      } else {
        if (snapshot.hasData) {
          return _buildMainScreen(uuid: snapshot.data.uid);
        }
        return _buildLoginScreen();
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

Widget _buildMainScreen({uuid}) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Money Monitor"),
    ),
    body: Column(
      children: <Widget>[
        Center(
          child: Text(uuid),
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

Widget _buildLoginScreen() {
  void _authenticateWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print(user);
    // do something with signed-in user
  }

  return Scaffold(
    body: Center(
      child: RaisedButton(
        child: Text("Sign In"),
        onPressed: _authenticateWithGoogle,
      ),
    ),
  );
}
