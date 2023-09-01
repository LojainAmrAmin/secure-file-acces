import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/admin/Departments.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled2/splashscreen.dart';
import 'admin/AddNewUser.dart';
import 'admin/BottomNavigationBarItem.dart';
import 'admin/ProfilePage.dart';
import 'USER/homePage.dart';
import 'USER/profileuser.dart';
import 'encryption-decryption/UploadFile.dart';
import 'login/LoGinPage.dart';
import 'myTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Graduation Project',
      debugShowCheckedModeBanner: false,
      routes: {
        DirectoryPage.routename:(context) => const DirectoryPage(),
        ProfilePage.routename :(context) => ProfilePage(),
        Departments.routename:(context) => const Departments(),
        EncryptionPage.routeName:(context) => EncryptionPage(),
        LoGinPage.routename:(context) => LoGinPage(),
        UserHomePage.routename: (context) => UserHomePage(),
        ProfilePageUser.routename:(context) => ProfilePageUser(),
        ADDUser.routename:(context) => ADDUser(),
        Splachscreeen.routename:(context) => Splachscreeen(),

      },

      initialRoute: Splachscreeen.routename,
      // _auth.currentUser != null
      // ? DirectoryPage.routename
      // : LoGinPage.routename,
      theme: MyThemeData.Lighttheme,

    );
  }

  // bool _isAdmin(User user) {
  //   // TODO: Implement logic to check if the user is an admin
  //   // For example, you could check the user's role in your database
  //
  //   return false;
  // }

}


