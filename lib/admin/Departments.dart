import 'package:flutter/material.dart';
import 'package:untitled2/admin/view_file.dart';
import 'package:untitled2/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../encryption-decryption/UploadFile.dart';




class Departments extends StatefulWidget {
  static const String routename ='departments';

  const Departments({Key? key}) : super(key: key);

  @override
  State<Departments> createState() => _DepartmentsState();
}

class _DepartmentsState extends State<Departments> {
  @override
  Widget build(BuildContext context) {

    final Storage storage = Storage();
    var url ;

    final firebase_storage.FirebaseStorage storage1 =
        firebase_storage.FirebaseStorage.instance;


    return
      Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Scaffold(
              backgroundColor: Colors.transparent,
              body:
              Column(
                children: [
                  Expanded( flex:2,

                      child: Row(children: const [],)),
                  Center(
                    child:
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(' Files',style:
                          TextStyle(fontWeight: FontWeight.w400,fontSize: 25,color: Colors.black87),),
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
                                        onPressed: ()  async {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                              viewfile(viewfilename:snapshot.data!.items[index].name)));

                                        },
                                        child:
                                        Stack(alignment: Alignment.center,
                                          children: [

                                            Opacity(opacity: 0.03,child: Image.asset('assets/images/openfile.jpeg'),),
                                            Text(snapshot.data!.items[index].name,  //metadata////////////////////////////////////////////////////////////////////////
                                                style: TextStyle(color: Colors.black,fontSize: 10)),

                                          ], ),
                                        style: ElevatedButton.styleFrom(primary: Colors.white,


                                          elevation: 6,shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(20),topRight: Radius.circular(20))),
                                        ),
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
          Row( mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.symmetric(horizontal: 140,vertical: 55)),
              FloatingActionButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> EncryptionPage()));
              },
                child: const Icon(Icons.add,color: Colors.white, size: 45,),
                backgroundColor: const Color.fromRGBO(220, 205, 168, 1),
              ),

            ],
          ),
        ],

      );
  }
}