import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../backgrounds.dart';
import 'UserHelper.dart';

class ProfilePageUser extends StatelessWidget {
  static String routename = 'profile page';
  final currentUser = FirebaseAuth.instance;
  //const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
              elevation: 0, backgroundColor: Colors.transparent, actions: []),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(
                  child: Row(
                children: [],
              )),

              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("user")
                        .where("uid", isEqualTo: currentUser.currentUser!.uid)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          flex: 2,
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                var data = snapshot.data!.docs[i];

                                return Column(
                                  children: [
                                    Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 25,
                                                  ),
                                                  Icon(Icons.person_rounded),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text('Name:',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              206, 185, 151, 1),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    width: 18,
                                                  ),
                                                  Text(data['firstname'],
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(data['lastname'],
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                ],
                                              ),
                                              const Divider(
                                                color: Colors.black12,
                                                height: 20,
                                                thickness: 1.2,
                                                indent: 75,
                                                endIndent: 30,
                                              ),
                                              SizedBox(height: 30),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 25,
                                                  ),
                                                  Icon(Icons.email),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text('Email:',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              206, 185, 151, 1),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    width: 18,
                                                  ),
                                                  Text(data['email'],
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                ],
                                              ),
                                              const Divider(
                                                color: Colors.black12,
                                                height: 20,
                                                thickness: 1.2,
                                                indent: 75,
                                                endIndent: 30,
                                              ),
                                              SizedBox(height: 30),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 25,
                                                  ),
                                                  Icon(Icons.phone),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text('Phone:',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              206, 185, 151, 1),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    width: 18,
                                                  ),
                                                  Text(data['phone'],
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                ],
                                              ),
                                              const Divider(
                                                color: Colors.black12,
                                                height: 20,
                                                thickness: 1.2,
                                                indent: 75,
                                                endIndent: 30,
                                              ),
                                              SizedBox(height: 30),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 25,
                                                  ),
                                                  Icon(Icons.desktop_mac),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text('Department:',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              206, 185, 151, 1),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    width: 18,
                                                  ),
                                                  Text(data['department'],
                                                      style: TextStyle(
                                                          fontSize: 15)),
                                                ],
                                              ),
                                              const Divider(
                                                color: Colors.black12,
                                                height: 20,
                                                thickness: 1.2,
                                                indent: 75,
                                                endIndent: 30,
                                              ),
                                            ],
                                          )
                                        ]),
                                    //SizedBox(height: 20)
                                  ],
                                );
                              }),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          useehelper authservice = useehelper();
                          authservice.logoutUserss(context);
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              color: Color.fromRGBO(196, 25, 14, 1.0),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
              // const Spacer()
            ],
          ),
        ),
      ],
    );
  }
}
