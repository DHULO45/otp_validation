import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:otp_validation/dashboard.dart';

import 'logindata.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Login(),
  ));
}

class otp_validation extends StatefulWidget {
  @override
  State<otp_validation> createState() => _otp_validationState();
}

class _otp_validationState extends State<otp_validation> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? vid;
  String smscode = "";
  TextEditingController phone = TextEditingController();

  // TextEditingController verifyotp = TextEditingController();

  OtpFieldController verifyotp = OtpFieldController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "OTP",
          style: TextStyle(fontFamily: "tw"),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff7E57C2),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10,left: 10),
            child: TextField(
              controller: phone,
              cursorColor: Color(0xff7E57C2),
              keyboardType: TextInputType.number,
              style: TextStyle(fontFamily: "tw"),
              decoration: InputDecoration(
                hintText: "Mobile No.:",
                prefixIcon: Icon(
                  Icons.call,
                  color: Colors.deepPurple,
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff7E57C2)),
                    borderRadius: BorderRadius.circular(10)
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff7E57C2)),
                  borderRadius: BorderRadius.circular(10)
                ),
                hintStyle: TextStyle(
                    fontFamily: "tw", fontSize: 20, color: Colors.deepPurple),
                suffixIcon: TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '+91${phone.text}',
                        timeout: const Duration(seconds: 60),
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {
                          if (e.code == 'invalid-phone-number') {
                            print('The provided phone number is not valid.');
                          }
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          setState(() {
                            vid = verificationId;
                          });
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    child: Text("SEND OTP",
                        style: TextStyle(
                            color: Color(0xff7E57C2),
                            fontFamily: "tw",
                            fontSize: 20))),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: double.infinity,
              child: OTPTextField(

                onChanged: (value) {
                  smscode = value;
                  setState(() {});
                },
                length: 6,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 45,
                style: TextStyle(fontSize: 20,fontFamily: "tw"),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.underline,
                onCompleted: (pin) {
                  // print("Completed: " + pin);
                },
              ),
            ),
          ),

          // TextField(
          //
          //   controller: verifyotp,
          //   cursorColor: Color(0xff7E57C2),
          //   decoration: InputDecoration(
          //     hintText: "OTP:",
          //     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff7E57C2))),
          //     hintStyle: TextStyle(fontFamily: "tw",fontSize: 20),
          //
          //   ),
          //
          // ),
          SizedBox(height: 25,),
          GFButton(
            onPressed: smscode.length == 6
                ? () async {
                    // String smsCode = '${verifyotp.text}';

                    // Create a PhoneAuthCredential with the code
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: vid!, smsCode: smscode);

                    // Sign the user in (or link) with the credential
                    await auth.signInWithCredential(credential);

                    phone.clear();
                    // verifyotp.clear();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return Dashboard();
              },));
                  }
                : null,
            text: "Verify OTP",
            color: Color(0xff7E57C2),
            textStyle: TextStyle(fontFamily: "tw",fontSize: 20,),
          ),


          // MaterialButton(color: Color(0xff7E57C2),onPressed: () {
          //
          //   signInWithGoogle().then((value) {
          //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          //       return Dashboard(Usercredential: value,);
          //     },));
          //   });
          //
          // }, child: Text("GOOGLE",style: TextStyle(fontFamily: "tw",color: Colors.white),),),



          // Spacer(),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Container(
          //         height: 1,
          //         margin: EdgeInsets.all(10),
          //         // width: double.infinity,
          //         color: Colors.black,
          //       ),
          //     ),
          //     Text("Or Via Social Media"),
          //     Expanded(
          //       child: Container(
          //         height: 1,
          //         margin: EdgeInsets.all(10),
          //         // width: double.infinity,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ],
          // ),
          // GFButton(
          //   onPressed: (){},
          //   text: "FACEBOOK",
          //   icon: Icon(Icons.facebook),
          //   type: GFButtonType.solid,
          //   blockButton: true,
          // ),


        ],
      ),
    );
  }
}
