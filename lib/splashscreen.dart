import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:untitled2/login/LoGinPage.dart';

class Splachscreeen extends StatefulWidget {
  static String routename ='splach';
  const Splachscreeen({Key? key}) : super(key: key);

  @override
  State<Splachscreeen> createState() => _SplachscreeenState();
}

class _SplachscreeenState extends State<Splachscreeen> {

  @override
  void initState() {

    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoGinPage()));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 205, 168, 1),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/logo.png',),width: 500,height: 500),
            SizedBox(height: 40,),
            SpinKitWave(size: 20,color: Colors.white,)

          ],
        ),
      ),
    ) ;
  }
}