import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:money_monitor/scoped_models/main.dart';
import 'package:money_monitor/pages/login.dart';
import 'package:money_monitor/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:money_monitor/pages/welcome_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String deviceTheme = "light";

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue[700],
  primaryColorLight: Colors.blueAccent,
  accentColor: Colors.blueAccent,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[700],
  primaryColorLight: Colors.grey[850],
  accentColor: Colors.blue,
  textSelectionHandleColor: Colors.blue
);

 restartApp() {
  main();
}

logout() {
  if(deviceTheme == "light") {
    runApp(MyApp(lightTheme));
  } else {
    runApp(MyApp(darkTheme));
  }
}

void main() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String theme = (pref.getString("theme") ?? "light");
  print(theme);
  deviceTheme = theme;
  if(theme == "dark") {
      runApp(MyApp(darkTheme));
  } else {
      runApp(MyApp(lightTheme));
  }
}

class MyApp extends StatefulWidget {
  final ThemeData theme;
  MyApp(this.theme);
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
        theme: widget.theme,
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
          return WelcomeScreen();
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
