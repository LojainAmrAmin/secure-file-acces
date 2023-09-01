import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:untitled2/USER/profileuser.dart';
import 'package:untitled2/USER/viewFileUser.dart';
import 'package:untitled2/backgrounds.dart';
import '../storage_service.dart';


class UserHomePage extends StatelessWidget {
  static const String routename ='UserHomePage';

  //const UserHomePage({Key? key}) : super(key: key);
  final Storage storage = Storage();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0),

            backgroundColor: Colors.transparent,

            body:
            Column(
              children: [

                Expanded(
                  child: Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                    ],
                  ),
                ),
                Expanded(child: Row(children: const [],))



                // Expanded(
                //   child: Row(
                //     children: [const Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                //       FloatingActionButton(onPressed: (){
                //         Navigator.pop(context, MaterialPageRoute(builder: (context)=> const HomePage()));
                //       },
                //         child: const Icon(Icons.arrow_back,color: Colors.black,size: 35),
                //         backgroundColor: Colors.white,
                //       )
                //     ],
                //   ),
                // ),
                ,Center(
                  child:
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(' Files',style:
                        TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),


                Expanded(flex: 12,
                  child: FutureBuilder(
                      future: storage.listFiles(),
                      builder: (BuildContext context,
                          AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                        if(snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData){
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            height: 50,
                            child: GridView.builder(
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.items.length,
                                itemBuilder: (BuildContext context, int index){
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>viewfileUser(viewfilenameuser:snapshot.data!.items[index].name)));



                                      },
                                      child: Stack(alignment: Alignment.center,
                                        children: [

                                          Opacity(opacity: 0.03,child: Image.asset('assets/images/openfile.jpeg'),),
                                          Text(snapshot.data!.items[index].name,
                                              style: TextStyle(color: Colors.black,fontSize: 10)),




                                        ], ),
                                      style: ElevatedButton.styleFrom(primary: Colors.white,
                                          elevation: 6,shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(20),topRight: Radius.circular(20)))),
                                    ),
                                  );
                                }),
                          );
                        }
                        if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
                          return CircularProgressIndicator();
                        }
                        return Container();
                      }),
                ),
              ],
            )




        ),
        // Row( mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     const Padding(padding: EdgeInsets.symmetric(horizontal: 140,vertical: 55)),
        //     FloatingActionButton(onPressed: (){
        //       Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadFile()));
        //     },
        //       child: const Icon(Icons.add,color: Colors.white, size: 45,),
        //       backgroundColor: const Color.fromRGBO(220, 205, 168, 1),
        //     ),
        //   ],
        // ),
      ],

    );
  }
}