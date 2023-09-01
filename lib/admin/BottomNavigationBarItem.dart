import 'package:flutter/material.dart';
import 'package:untitled2/admin/Departments.dart';
import 'package:untitled2/backgrounds.dart';
import '../chat/userlist.dart';
import '../encryption-decryption/decryptionPage.dart';
import 'ProfilePage.dart';
import 'UsersPage.dart';

class DirectoryPage extends StatefulWidget {
  static const String routename = 'mainpage';

  const DirectoryPage({Key? key}) : super(key: key);

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Background('assets/images/BG1.png'),
        Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: Colors.white, shadowColor: Colors.transparent),
              child: BottomNavigationBar(
                  currentIndex: currentindex,
                  onTap: (index) {
                    currentindex = index;
                    setState(() {});
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                    label: 'Home'),
                    BottomNavigationBarItem(
                        icon: ImageIcon(AssetImage('assets/images/user.png')),
                        label: 'Users'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.lock_open_outlined),
                        label: 'Decrypt'),
                  ]
              ),
            ),
            body: taps[currentindex],
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.red,
                      image: DecorationImage(image: AssetImage('assets/images/img.png'),
                          fit: BoxFit.cover)

                  ),

                  child:Text(''),
                  // Icon(Icons.security_outlined,size: 50) ,
                  // decoration: BoxDecoration(
                  //   color:  Color.fromRGBO(220,205, 168,1),
                  // ),
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      leading: ImageIcon(AssetImage('assets/images/pr.png')),
                      title: Text('Profile'),
                      onTap: () {
                        // Do something
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage()));

                      },
                    ),
                    ListTile(
                      leading: ImageIcon(AssetImage('assets/images/request.png')),
                      title: Text('Chat'),
                      onTap: () {
                        // Do something
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UsersListPage() ));

                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black,size: 30),leadingWidth: 100,
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
              ]),

        ),
      ],
    );
  }

  List<Widget> taps = [
    Departments(),
    UsersPage(),
    decryptionPage(),
  ];
}
