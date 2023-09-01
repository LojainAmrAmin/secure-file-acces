import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:untitled2/USER/homePage.dart';
import 'package:untitled2/storage_service.dart';



class viewfileUser extends StatefulWidget {
  viewfileUser({required this.viewfilenameuser});

  static String routename = 'viewfileuser';
  late String viewfilenameuser;


  @override
  State<viewfileUser> createState() => _viewfileUserState();
}

class _viewfileUserState extends State<viewfileUser> {
  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    return Stack(
      children: [
        Image.asset(
          'assets/images/bac.png',
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Scaffold(
          // appBar: AppBar(backgroundColor:Colors.transparent,elevation: 0,iconTheme: IconThemeData(color: Colors.black)),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 25)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
                    FloatingActionButton(onPressed: (){
                      //  Navigator to the previous page
                      Navigator.pop(context, MaterialPageRoute(builder: (context)=> UserHomePage()));
                    },
                      child:Icon(Icons.arrow_back, color: Colors.black,size: 30),
                      backgroundColor: Colors.white,
                    )
                  ],
                ),

                SizedBox(
                  height: 50,
                ),

                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child:
                  Container(
                    width: 341,
                    height: 341,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder(
                            future: storage.downloadURl(widget.viewfilenameuser),
                            builder:
                                (BuildContext context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done &&
                                  snapshot.hasData) {
                                return Center(
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),),
                                          width:200,
                                          height: 200,
                                          child: Column(
                                            children: [
                                              Image(image: AssetImage('assets/images/corrupt-file.png'),),


                                            ],
                                          )
                                      ),
                                      Text('Invalid Data',style: TextStyle(fontSize: 20))],
                                  ),
                                );
                              }
                              if (snapshot.connectionState == ConnectionState.waiting ||
                                  !snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              return Container();
                            }),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 250,),


              ],
            ),
          ),

        )
      ],
    );
  }
}