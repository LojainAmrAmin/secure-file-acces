import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/admin/AddNewUser.dart';
import '../USER/UserBottomNav.dart';
import '../admin/BottomNavigationBarItem.dart';
import 'LoGinPage.dart';

class AuthService{
  final auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController selectedRole = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void LoginHelper(context)async{
    try{
      showDialog(context: context, builder: (context){

        return AlertDialog(
          title: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });

      UserCredential userCredential =
      await auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);

      QuerySnapshot userSnapshot = await firestore
          .collection('user')
          .where('uid', isEqualTo: userCredential.user!.uid)
          .get();


      if (userSnapshot.docs.length == 1) {
        String role = userSnapshot.docs[0]['role'];
        if (role.toLowerCase() == 'user') {

          // Navigate to the admin dashboard
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => UserNavBar()),
                (route) => false,
          );

        }

      }
       if (userSnapshot.docs.length == 1) {
        String role = userSnapshot.docs[0]['role'];
        if (role.toLowerCase() == 'admin') {
          // Navigate to the admin dashboard
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DirectoryPage()),
                (route) => false,
          );
        }
      }
    }catch(e){
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("SomeThing went wrong"),
            content: Text(" Unvalid email or password  "),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////

  void hendiregester(context)async{
    try{
      showDialog(context: context, builder: (context){

        return AlertDialog(
          title: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
      await auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text).then((value) {
        print('user is registered');
        firestore.collection('user').add({
          "email":email.text,
          "firstname":firstname.text,
          "lastname":lastname.text,
          "phone":phone.text,
          "department":department.text,
          "role": selectedRole.text,
          "uid":value.user!.uid,

        });
        // Navigator.push(context, MaterialPageRoute(builder:(c)=> DirectoryPage()));
        Navigator.pop(context);
        showDialog(context: context,
            builder: (BuildContext context){
          return AlertDialog(
            title: Text(""),
            content: Text("  Deleted successfully "),
            actions: [
              TextButton(
                child: Text("close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

            ],
          );
            });

      });
    }catch(e){
      Navigator.pop(context);
      AlertDialog(
        title: Center(
          child:  Text('erorr message'),

        ),
      );
    }
  }


  void logoutUser( context)async{

    await auth.signOut();
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => LoGinPage(), ), (route) => false);
  }
}

