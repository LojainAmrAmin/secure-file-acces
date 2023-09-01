import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:untitled2/storage_service.dart';

import 'Departments.dart';

class viewfile extends StatefulWidget {
  viewfile({required this.viewfilename});

  static String routename = 'viewfile';
  late String viewfilename;
  late String f;
  //const viewfile({Key? key}) : super(key: key);

  @override
  State<viewfile> createState() => _viewfileState();
}

class _viewfileState extends State<viewfile>  {
  final Storage storage = Storage();

  Future<void> _deleteFile() async {
    // Delete the file
    await storage.deleteFile(widget.viewfilename);
    // Navigate back to the previous screen
    Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    return Stack(
      children: [


        Scaffold(

          //backgroundColor: Colors.transparent,
          body: FutureBuilder(
              future: storage.downloadURl(widget.viewfilename),
              builder:
                  (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    widget.viewfilename.endsWith('.pdf')) {
                  return
                    //   Image.network(snapshot.data!,
                    //     fit: BoxFit.cover,
                    //
                    // );


                    Stack(children: [ SfPdfViewer.network(snapshot.data!),
                      Column(mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[ ElevatedButton(onPressed: (){


                          }, child: Text('')
                          )
                          ]
                      )

                    ],);
                }
                else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/bac.png',
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),




                        Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(),
                            Center(
                              child: Stack(
                                children: [Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),


                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),),
                                    width: 341,
                                    height: 351,
                                    child: Center(
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
                                    ),
                                  ),
                                ),

                                ],   ),
                            ),





                            ElevatedButton(onPressed: (){
                              _deleteFile();
                            }, child: Text('Delete',style: TextStyle(fontSize: 20)),
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(150, 45),
                                    backgroundColor: Color.fromRGBO(
                                        196, 25, 14, 1.0),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))) ,
                          ],
                        ),)


                      ],
                    );


                  // SfPdfViewer.network(snapshot.data!);
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Container();
              }),

        )
        ,SizedBox(height: 110,
          child: Row(
            children: [Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              FloatingActionButton(onPressed: (){
                Navigator.pop(context, MaterialPageRoute(builder: (context)=> Departments()));

              },
                child: Icon(Icons.arrow_back, color: Colors.black,size: 28),
                backgroundColor: Colors.transparent,elevation: 0,)
            ],
          ),
        ),
      ],
    );
  }
}