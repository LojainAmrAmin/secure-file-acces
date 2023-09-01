import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../backgrounds.dart';
import '../chat/message.dart';

class chatpageuser extends StatefulWidget {
  static String routename = 'chatpageuser';
  String email;
  chatpageuser({required this.email});
  @override
  _chatpageuserState createState() => _chatpageuserState(email: email);
}

class _chatpageuserState extends State<chatpageuser> {
  String email;
  _chatpageuserState({required this.email});

  final fs = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController message = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.79,
                  child: messages(
                    email: email,
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: message,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                          //Colors.white,
                          Color.fromRGBO(220,205, 168,1),
                          hintText: 'message',
                          // hintStyle: TextStyle(color: Colors.black,fontSize: 15),
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black87,style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.black87,style: BorderStyle.none),
                            borderRadius: new BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {},
                        onSaved: (value) {
                          message.text = value!;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (message.text.isNotEmpty) {
                          fs.collection('Messages').doc().set({
                            'message': message.text.trim(),
                            'time': DateTime.now(),
                            'email': email,
                          });

                          message.clear();
                        }
                      },
                      icon: Icon(Icons.send_sharp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ], );
  }
}