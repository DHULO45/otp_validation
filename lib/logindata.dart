import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otp_validation/main.dart';

import 'dashboard.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
        print('User is signed in!');
      }
    });
  }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken! .token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(backgroundColor: Colors.deepPurple,),
      // backgroundColor: Colors.black26,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          Text("REGISTRATION",style: TextStyle(fontSize: 50,fontFamily: "tw",color: Colors.deepPurple),),
          
          // Column(
          //   children: [
          //     Text("REGISTRATION",style: TextStyle(fontSize: 50,fontFamily: "tw"),),
          //     Container(
          //       padding: EdgeInsets.all(1),
          //         child: Text("________________________________",style: TextStyle(fontSize: 20,fontFamily: "tw"),)),
          //   ],
          // ),
         
          MaterialButton(color: Color(0xff7E57C2),onPressed: () {

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return otp_validation();
            },));

          }, child: Text("PHONE NUMBER",style: TextStyle(fontFamily: "tw",color: Colors.white,fontSize: 18),),),
          
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  margin: EdgeInsets.all(10),
                  // width: double.infinity,
                  color: Colors.deepPurple,
                ),
              ),
              Text("Or Via Social Media",style: TextStyle(fontFamily: "tw",fontSize: 20,color: Colors.deepPurple),),
              Expanded(
                child: Container(
                  height: 1,
                  margin: EdgeInsets.all(10),
                  // width: double.infinity,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: () {

                    signInWithGoogle().then((value) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return Dashboard(Usercredential: value,);
                      },));
                    });

                  },
                  child: SvgPicture.asset("Image/google-fill.svg",color: Colors.deepPurple,height: 45,)),
              InkWell(
                  onTap: () {

                    signInWithFacebook().then((value) {

                      print(value);

                    });

                  },
                  child: SvgPicture.asset("Image/Tilda_Icons_26snw_facebook.svg",color: Colors.blueAccent,height: 45,)),
              InkWell(
                  onTap: () {



                  },
                  child: SvgPicture.asset("Image/twitter.svg",color: Colors.blue,height: 45,)),
            ],
          ),
        ],
      ),
    );
  }
}
