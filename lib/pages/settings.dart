import 'package:money_monitor/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:money_monitor/scoped_models/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        return GestureDetector(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: deviceTheme == "light"
                    ? Theme.of(context).accentColor
                    : Colors.grey[900],
                pinned: false,
                floating: false,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                    child: SafeArea(
                      bottom: false,
                      top: true,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Settings",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  MdiIcons.logout,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  await GoogleSignIn().signOut();
                                  model.logoutUser();
                                  restartApp();
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  child: model.authenticatedUser.photoUrl !=
                                          null
                                      ? CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.blueAccent,
                                          foregroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                              model.authenticatedUser.photoUrl),
                                        )
                                      : CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.blue[700],
                                          foregroundColor: Colors.white,
                                          child: Text(model.authenticatedUser
                                              .displayName[0]),
                                        ),
                                  width: 50.0,
                                  height: 50.0,
                                  padding: const EdgeInsets.all(2.0),
                                  decoration: new BoxDecoration(
                                    color:
                                        const Color(0xFFFFFFFF), // border color
                                    shape: BoxShape.circle,
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      print("PRESS");
                                    },
                                    child: Text(
                                      model.authenticatedUser != null &&
                                              model.authenticatedUser
                                                      .displayName !=
                                                  null
                                          ? model.authenticatedUser.displayName
                                          : "Add Name",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    model.authenticatedUser.email,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  RaisedButton(
                    child: Text("Light Theme"),
                    onPressed: () async {
                      model.updateTheme("light");
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      await pref.setString("theme", "light");
                      restartApp();
                    },
                  ),
                  RaisedButton(
                    child: Text("Dark Theme"),
                    onPressed: () async {
                      model.updateTheme("dark");
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      await pref.setString("theme", "dark");
                      restartApp();
                    },
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
    ;
  }
}

/*
Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Sign Out"),
              onPressed: ()  async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                model.logoutUser();
                restartApp();
              },
            ),
            RaisedButton(
              child: Text("Light Theme"),
              onPressed: () async {
                model.updateTheme("light");
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.setString("theme", "light");
                restartApp();
              },
            ),
            RaisedButton(
              child: Text("Dark Theme"),
              onPressed: () async {
                model.updateTheme("dark");
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.setString("theme", "dark");
                restartApp();
              },
            ),
          ],
        );


*/
