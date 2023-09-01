import 'package:flutter/material.dart';
import '../backgrounds.dart';
import 'LoginHelper.dart';

class LoGinPage extends StatefulWidget {
  //const LoGinPage({Key? key}) : super(key: key);
  static String routename ='LoGinPage';


  @override
  _LoGinPageState createState() => _LoGinPageState();
}

AuthService authService= AuthService();

class _LoGinPageState extends State<LoGinPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Background('assets/images/login2.jpeg'),
          
          Column(
            children: [
              Expanded( flex: 3,
                  child: 
                  Row(children: const [])),
              Expanded(flex: 4,
                child: Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Welcome',
                      style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),)],),
              ),


              Expanded(flex: 9,
                child: Form(
                    child:
                    Column(
                      children: [
                        SizedBox(width: 350,height: 55,
                          child: TextFormField(
                            controller: authService.email,
                            decoration: InputDecoration( filled: true, fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                                ),
                                hintText: 'Email',
                                hintStyle: const TextStyle(color: Colors.black)
                            ),
                          ),

                        ),SizedBox(height: 15,),
                        SizedBox(height: 55,width: 350,
                          child: TextFormField(
                            obscureText: true,
                            controller: authService.password,
                            decoration: InputDecoration( filled: true, fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                                ),
                                hintText: 'Password',

                                hintStyle: const TextStyle(color: Colors.black
                                )
                            ),
                          ),
                        ),SizedBox(height: 30,),
                        ElevatedButton(onPressed: (){
                          if (authService.email !=""&&authService.password !="")
                          {
                            authService.LoginHelper(context);
                          }
                        },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(220, 205, 168, 1),
                                fixedSize: const Size(350, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                            child: const Text('Login')
                        ),
                      ],
                    )
                ),
              ),
              // Expanded( flex: 2,
              //     child: Row(children: const [],))

            ],
          ),
        ],
      ),
    );
  }
}