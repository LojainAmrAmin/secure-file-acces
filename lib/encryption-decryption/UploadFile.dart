import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled2/backgrounds.dart';

import '../admin/Departments.dart';

class EncryptionPage extends StatefulWidget {
  const EncryptionPage({Key? key}) : super(key: key);
  static const String routeName ='e2';


  @override
  State<EncryptionPage> createState() => _EncryptionPageState();
}

class _EncryptionPageState extends State<EncryptionPage> {
  String? _path;
  String? pat;
  String? encFilepath;
  String? filename;


  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getExternalStorageDirectory();
    final newFile = File('${appStorage!.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  bool _validate = false;
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<File> saveFile(String file) async {
    Directory? appStorage = await getExternalStorageDirectory();
    var fileName = (file.split('/').last);
    final newfile = ('${appStorage!.path}/$fileName');

    return File(file).copy(newfile);
  }

  final _textController = TextEditingController();
  final _fileNameController = TextEditingController();

  Widget _buildFileNameRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: TextField(
        controller: _fileNameController,
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffDCCDA8), width: 2.0),
          ),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffDCCDA8), width: 1.5)),
          hintText: "Enter new file name",
        ),
      ),
    );
  }

  Widget _buildAddFileButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Opacity(
          opacity: 0.5,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Color.fromRGBO(220,205, 151, 1),
                  child:
                  InkWell(
                    onTap: () async {
                      PlatformFile? _platformFile;
                      final file = await FilePicker.platform.pickFiles();

                      if (file != null) {
                        _platformFile = file.files.first;

                        pat = _platformFile.name;
                        _path = _platformFile.path;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: const Color(0xff006aff),
                            content: Text(
                              ' File Selected\n File path:$_path',
                              textAlign: TextAlign.center,
                            )));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Color(0xffee122a),
                            content: Text(
                              ' File not Selected.Abort',
                              textAlign: TextAlign.center,
                            )));
                        print("abort");
                      }
                    },


                    child: Container(
                      child:
                      Column( mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: 100, color: Colors.black),
                          Text('Upload', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                        ],
                      ),
                      width: 300,
                      height: 300,

                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                      ),

                    ),

                  ),

                ),
              ],
            ),
          ),
        ),


      ],
    );
  }

  Widget _buildEncryptButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 1.4 * (MediaQuery.of(context).size.height / 20),
          width: 5 * (MediaQuery.of(context).size.width / 10),
          margin: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xffDCCDA8),
              shape: const StadiumBorder(),
            ),
            onPressed: () async
            {
              FocusScope.of(context).unfocus();
              setState(() {
                _textController.text.isEmpty
                    ? _validate = true
                    : _validate = false;
              });
              if (_path != null && _textController.text != null) {
                print(_path);

                // Creates an instance of AesCrypt class.
                AesCrypt crypt = AesCrypt();

                // Sets encryption password.
                // Optionally you can specify the password when creating an instance
                // of AesCrypt class like:
                crypt.aesSetMode(AesMode.cbc);
                crypt.setPassword(_textController.text);

                // Sets overwrite mode.
                // It's optional. By default the mode is 'AesCryptOwMode.warn'.
                crypt.setOverwriteMode(AesCryptOwMode.rename);

                try {
                  // Encrypts  file and save encrypted file to a file with
                  // '.aes' extension added. In this case it will be '$_path.aes'.
                  // It returns a path to encrypted file.

                  encFilepath = crypt.encryptFileSync(_path!);

                  print('The encryption has been completed successfully.');
                  print('Encrypted file: $encFilepath');

                  final encryptedFile = await saveFile(encFilepath!);
                  final fileName = encryptedFile.path.split('/').last;
                  final fileBytes = await encryptedFile.readAsBytes();
                  //Add metadata to the upload task
                  final metadata = SettableMetadata(
                    contentType: 'application/octet-stream',
                    customMetadata: {'filename':_fileNameController.text});
                  //Upload the encrypted file to firebase
                  final storageRef = FirebaseStorage.instance.ref('Encrypted/$fileName');
                  final uploadTask = storageRef.putData(fileBytes, metadata);

                  await uploadTask.whenComplete(()  =>{
                    print('File upload success.  '),
                    print(encFilepath)}

                  );

                  //final newfile1 = await saveFile1(encFilepath!);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Color(0xff006aff),
                      content: Text(
                        ' File Encryption Success',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Color(0xff006aff),
                      content: Text(
                        ' File Saved',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )));
                  // print(newFile);
                  // print(newfile1);
                } on AesCryptException catch (e) {
                  // It goes here if overwrite mode set as 'AesCryptFnMode.warn'
                  // and encrypted file already exists.
                  if (e.type == AesCryptExceptionType.destFileExists) {
                    print('The encryption has been completed unsuccessfully.');
                    print(e.message);
                  }
                }
              }
              if (_path == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Color(0xffee122a),
                    content: Text(
                      'Please select file',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )));
              }
              setState(() {
                _textController.clear();
                _fileNameController.clear();
              });
            },
            child: Text(
              "Encrypt",
              style: TextStyle(color: Colors.white,fontSize: 17),

            ),
          ),
        )
      ],
    );
  }

  Widget _buildPasswordRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: TextField(
        controller: _textController,
        //textAlign: TextAlign.center,
        decoration: InputDecoration(
          errorText: _validate ? 'please enter password' : null,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xffDCCDA8), width: 2.0),
          ),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffDCCDA8), width: 1.5)),
          hintText: "Enter password",
        ),
        obscureText: true,
      ),
    );
  }

  Widget _buildContainer() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildAddFileButton(),
                _buildFileNameRow(),
                _buildPasswordRow(),
                _buildEncryptButton()
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //return SafeArea(
    //child:
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            Background('assets/images/bac.png'),
            Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body:
              Stack(

                children: <Widget>[

                  Column(children: [SizedBox(height:40 ,),

                    Row(children: [SizedBox(width: 20,),
                      FloatingActionButton(onPressed: (){
                        Navigator.pop(context,
                            MaterialPageRoute(builder: (context)=> Departments()));

                      }, child: Icon(Icons.arrow_back,color: Colors.black),
                          backgroundColor: Colors.white),
                    ],),
                  ],),


                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      _buildContainer(),

                    ],
                  )
                ],
              ),
            ),

          ],
        )

    );
  }
}

