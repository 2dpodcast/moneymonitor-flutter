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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
    "email": null,
    "password": null,
  };

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

  void _authenticateWithEmailandPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Widget _buildHeader() {
    return Text(
      "Money Monitor",
      style: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).accentColor,
        wordSpacing: 2.0,
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

  Widget _buildEmailField() {
    return TextFormField(
      initialValue: "anushanlingam50@outlook.com",
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return "Please enter a valid email address.";
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30.0),
        ),
        hintText: "Email",
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onSaved: (String value) {
        _formData["email"] = value;
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      initialValue: "anushan24",
      validator: (String value) {
        if (value.isEmpty || value.length < 8) {
          return "Please enter a valid password.";
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30.0),
        ),
        hintText: "Password",
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        hasFloatingPlaceholder: true,
        filled: true,
        fillColor: Colors.white,
      ),
      onSaved: (String value) {
        _formData["password"] = value;
      },
      obscureText: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final targetWidth = MediaQuery.of(context).size.width > 550.0
        ? 500.0
        : MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(MdiIcons.google),
        label: const Text('Login With Google'),
        onPressed: _authenticateWithGoogle,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 80.0),
                ),
                IconButton(
                  icon: Icon(Icons.person_add),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.9],
            colors: [Colors.white, Colors.blue[200]],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildHeader(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildEmailField(),
                    SizedBox(
                      height: 10,
                    ),
                    _buildPasswordField(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).accentColor,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        color: Colors.white,
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          _formKey.currentState.save();
                          _authenticateWithEmailandPassword(_formData["email"], _formData["password"]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
