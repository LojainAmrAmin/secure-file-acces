import 'package:flutter/material.dart';
import '../backgrounds.dart';
import '../login/LoginHelper.dart';
import 'UsersPage.dart';

class ADDUser extends StatefulWidget {
  static String routename = 'ADDUser';

  @override
  State<ADDUser> createState() => _ADDUserState();
}

class _ADDUserState extends State<ADDUser> {
  AuthService authService = AuthService();

  String selectedRole ='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Background('assets/images/BG1.png'),
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UsersPage()));
                      },
                      child:
                          Icon(Icons.arrow_back, color: Colors.black, size: 35),
                      backgroundColor: Colors.white,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 55,
                          width: 160,
                          child: TextFormField(
                            controller: authService.firstname,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                                hintText: 'First Name',
                                hintStyle:
                                    const TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        SizedBox(
                          width: 160,
                          height: 55,
                          child: TextFormField(
                            controller: authService.lastname,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                                hintText: 'Last Name',
                                hintStyle:
                                    const TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 55,
                      width: 350,
                      child: TextFormField(
                        controller: authService.email,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none),
                            ),
                            hintText: 'Email',
                            hintStyle: const TextStyle(color: Colors.black)),
                      ),
                    ),
                    SizedBox(
                      width: 350,
                      height: 55,
                      child: TextFormField(
                        controller: authService.password,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none),
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.black)),
                      ),
                    ),
                    SizedBox(
                      height: 55,
                      width: 350,
                      child: TextFormField(
                        controller: authService.phone,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none),
                            ),
                            hintText: 'Phone',
                            hintStyle: const TextStyle(color: Colors.black)),
                      ),
                    ),
                    SizedBox(
                      height: 55,
                      width: 350,
                      child: TextFormField(
                        controller: authService.department,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none),
                            ),
                            hintText: 'Department',
                            hintStyle: const TextStyle(color: Colors.black)),
                      ),
                    ),
                    // SizedBox(
                    //   height: 55,
                    //   width: 350,
                    //   child: TextFormField(
                    //     controller: authService.role,
                    //     decoration: InputDecoration(
                    //         filled: true,
                    //         fillColor: Colors.white,
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(18),
                    //           borderSide: const BorderSide(
                    //               width: 0, style: BorderStyle.none),
                    //         ),
                    //         hintText: 'Role',
                    //         hintStyle: const TextStyle(color: Colors.black)),
                    //   ),
                    // ),
                    SizedBox(
                      height: 70,
                      width: 350,
                      child: DropdownButtonFormField<String>(
                        //value: selectedRole,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none
                            )
                          ),
                          hintText: 'Role',
                          hintStyle: TextStyle(
                            color: Colors.black
                          )
                        ),
                        items: [
                          DropdownMenuItem(
                            child: Text('Admin'),
                            value: 'Admin',
                          ),
                          DropdownMenuItem(
                            child: Text('User'),
                            value: 'User',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            //selectedRole = value!;
                            authService.selectedRole.text = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (authService.email != "" &&
                              authService.password != "") {
                            authService.hendiregester(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(220, 205, 168, 1),
                            fixedSize: const Size(350, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18))),
                        child: const Text('Add User')),
                  ],
                ),
              ),
              Expanded(
                  child: Row(
                children: const [],
              ))
            ],
          ),
        ],
      ),
    );
  }
}







