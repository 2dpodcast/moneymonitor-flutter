import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  void _authenticateWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    // TODO Replace with AuthCredential Login once packages updated
    await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    
  }

  Widget _buildHeader() {
    return Align(
      alignment: FractionalOffset.center,
      child: Text(
        "Money Monitor",
        style: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).accentColor,
          wordSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildLoginWithGoogle() {
    return Container(
      width: 200.0,
      child: MaterialButton(
        padding: EdgeInsets.all(10.0),
        color: Theme.of(context).accentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login With ",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 3.0,
            ),
            Icon(
              MdiIcons.google,
              color: Colors.white,
            ),
          ],
        ),
        onPressed: _authenticateWithGoogle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.9],
            colors: [
              Colors.white,
              Colors.blue[200]
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildHeader(),
            SizedBox(
              height: 15.0,
            ),
            _buildLoginWithGoogle(),
          ],
        ),
      ),
    );
  }
}
