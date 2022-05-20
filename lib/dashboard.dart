import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otp_validation/main.dart';

import 'logindata.dart';

class Dashboard extends StatefulWidget {

  UserCredential? Usercredential;

  Dashboard({this.Usercredential});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  User? _User;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        setState(() {
          _User=user;
        });
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () async {

            if(widget.Usercredential?.credential?.providerId == "google.com")
              {
                await  FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return Login();
                },));
              }
            else
              {
                await  FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return Login();
                },));
              }



          }, icon: Icon(Icons.logout))
        ],
      ),

    );
  }
}
