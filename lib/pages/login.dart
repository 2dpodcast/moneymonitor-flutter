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
  bool _showSignUp = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
    "email": null,
    "password": null,
    "confirmPassword": null
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
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      String errorMessage = e.message;
      print(errorMessage);
      String invalidPassword =
          "The password is invalid or the user does not have a password.";
      String userDoesntExist =
          "There is no user record corresponding to this identifier. The user may have been deleted.";

      if (errorMessage == invalidPassword) {
        _buildSignInErrorDialog("Password is invalid", true);
      }
    }
  }

  void _signUpWithEmailandPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      setState(() {
        _showSignUp = false;
      });
    } catch (e) {
      String errorCode = e.code;
      String errorMessage = e.message;
      print(errorMessage);
      if (errorMessage ==
          "The email address is already in use by another account.") {
        _buildSignInErrorDialog(
            "The email address is already in use by another account.");
      }
    }
  }

  _buildSignInErrorDialog(String message, [bool showReset]) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          title: Text("Account Error"),
          actions: <Widget>[
            showReset != null && showReset == true
                ? MaterialButton(
                    child: Text("Reset Password"),
                    onPressed: () {},
                  )
                : Container(),
            MaterialButton(
              child: Text("Okay"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
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
        helperText: _showSignUp ? "Minimum 8 characters" : "",
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

  Widget _buildConfirmPassword() {
    return Column(
      children: <Widget>[
        TextFormField(
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
            hintText: "Confirm Password",
            hintStyle: TextStyle(
              fontWeight: FontWeight.w600,
            ),
            hasFloatingPlaceholder: true,
            filled: true,
            fillColor: Colors.white,
          ),
          onSaved: (String value) {
            _formData["confirmPassword"] = value;
          },
          obscureText: true,
        ),
        SizedBox(
          height: 10,
        ),
      ],
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
                  icon: Icon(_showSignUp ? MdiIcons.login : Icons.person_add),
                  onPressed: () {
                    setState(() {
                      _showSignUp = !_showSignUp;
                      _formData["email"] = null;
                      _formData["password"] = null;
                      _formData["confirmPassword"] = null;
                      _formKey.currentState.reset();
                    });
                  },
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
                    _showSignUp ? _buildConfirmPassword() : Container(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).accentColor,
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return "";
                          }

                          _formKey.currentState.save();

                          if (_showSignUp) {
                            if (_formData['password'] !=
                                _formData['confirmPassword']) {
                              return _buildSignInErrorDialog(
                                  "Please enter matching passwords");
                            }
                            _signUpWithEmailandPassword(
                                _formData["email"], _formData["password"]);
                          } else {
                            _authenticateWithEmailandPassword(
                                _formData["email"], _formData["password"]);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              _showSignUp ? "Sign Up" : "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20.0),
                            )
                          ],
                        ),
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
