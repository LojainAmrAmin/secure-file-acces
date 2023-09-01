import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login/LoGinPage.dart';
import 'homePage.dart';

class useehelper {
  final auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void usernav(context) async {
    try {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });


      await auth.signInWithEmailAndPassword(
          email: email.text, password: password.text).then((value) =>
      {
        print('user is'),
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => UserHomePage()), (
            route) => false,
        ),

      });
    } catch (e) {
      Navigator.pop(context);
      AlertDialog(
        title: Center(
          child: Text('erorr message'),
        ),
      );
      ;
    }
  }
  void logoutUserss( context)async{

    await auth.signOut();
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => LoGinPage(), ), (route) => false);
  }
}