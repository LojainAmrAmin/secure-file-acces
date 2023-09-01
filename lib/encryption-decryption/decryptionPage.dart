import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../admin/ProfilePage.dart';
import '../chat/userlist.dart';

class decryptionPage extends StatefulWidget {
  const decryptionPage({Key? key}) : super(key: key);
  static const String routeName = 'd1';

  @override
  State<decryptionPage> createState() => _decryptionPageState();
}

class _decryptionPageState extends State<decryptionPage> {
  int count = 0;
  String? _path;
  String? _pathpic;
  String? pat;
  String? decFilepath;
  String? filename;
  String? _tempfilename;

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getExternalStorageDirectory();
    final newFile = File('${appStorage!.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  Future<File> saveFile(String file) async {
    Directory? appStorage = await getExternalStorageDirectory();
    var fileName = (file.split('/').last);
    final newfile = ('${appStorage!.path}/$fileName');

    return File(file).copySync(newfile);
  }

  Future<File> _downloadFile(String url, String fileName) async {
    Directory? appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir!.path}/$fileName';
    File file = File(filePath);
    try {
      await firebase_storage.FirebaseStorage.instance
          .refFromURL(url)
          .writeToFile(file);
      return file;
    } catch (e) {
      print(e.toString());
      if (file.existsSync()) {
        await file.delete();
      }
      throw Exception('Failed to download file: $fileName');
    }
  }

  final _textController = TextEditingController();
  final _textController1 = TextEditingController();
  bool _validate = false;

  Widget _buildPasswordRow() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextField(
        textAlign: TextAlign.center,
        controller: _textController,
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

  Widget _buildChooseFileButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Opacity(
          opacity: 0.5,
          child: Row(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color.fromRGBO(220, 205, 151, 1),
                child: InkWell(
                  onTap: () async {
                    Reference ref =
                        FirebaseStorage.instance.ref().child('Encrypted');
                    ListResult result = await ref.listAll();
                    List<String> fileNames =
                        result.items.map((item) => item.name).toList();
                    // Display a dialog with the list of file names and allow the user to choose one
                    String? chosenFileName = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          title: const Text('Choose a file to decrypt'),
                          children: fileNames.map((fileName) {
                            return SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, fileName);
                              },
                              child: Text(fileName),
                            );
                          }).toList(),
                        );
                      },
                    );
                    if (chosenFileName != null) {
                      String url =
                          await ref.child(chosenFileName).getDownloadURL();
                      File file = await _downloadFile(url, chosenFileName);
                      _pathpic = file.path;
                      print(_pathpic);
                      count = 1;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Color(0xff006aff),
                          content: Text(' File Selected')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Color(0xffee122a),
                          content: Text(' File not Selected.Abort')));
                      print("abort");
                    }
                  },
                  child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file,
                              size: 100, color: Colors.black),
                          Text(
                            'Chosse a File to Decrypt',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _builddecryptButton() {
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
            onPressed: () async {
              FocusScope.of(context).unfocus();
              setState(() {
                _textController.text.isEmpty
                    ? _validate = true
                    : _validate = false;
              });
              if (_textController.text != null &&
                  (_textController1.text != null || _pathpic != null)) {
                _tempfilename = _textController1.text;
                if (count == 0) {
                  var dir = getExternalStorageDirectory();
                  _path = ('$dir/$_tempfilename.aes');
                } else if (count == 1) {
                  _path = _pathpic;
                }

                // Creates an instance of AesCrypt class.
                AesCrypt crypt = AesCrypt();
                crypt.aesSetMode(AesMode.cbc);
                crypt.setOverwriteMode(AesCryptOwMode.rename);
                crypt.setPassword(_textController.text);

                try {
                  decFilepath = crypt.decryptFileSync(_path!);
                  print('The decryption has been completed successfully.');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Color(0xff006aff),
                      content: Text(
                        ' File Decryption Success',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )));
                  print('Decrypted file 1: $decFilepath');
                  if (count == 1) {
                    //Save Decrypted File on cloud firestore

                    /*final decryptedFile = await saveFile(decFilepath!);
                    final fileName = decryptedFile.path.split('/').last;
                    final fileBytes = await decryptedFile.readAsBytes();
                    final storageRef =
                        FirebaseStorage.instance.ref('Decrypted/$fileName');
                    final uploadTask = storageRef.putData(fileBytes);

                    await uploadTask
                        .whenComplete(() => {print('File upload success. ')});*/

                    // Save the Decrypted File on mobile
                    final newFile = await saveFile(decFilepath!);
                    print(newFile);

                    // Open the decrypted file
                    await OpenFile.open(decFilepath);

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Color(0xff006aff),
                        content: Text(
                          ' File Saved',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )));
                  } else {
                    print('File content: ' + File(decFilepath!).path);
                    final newfile = await saveFile(decFilepath!);
                    print(newfile);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Color(0xff006aff),
                        content: Text(
                          ' File Saved',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )));
                  }
                } catch (e) {
                  print('The decryption has been completed unsuccessfully.');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Color(0xffee122a),
                      content: Text(
                        ' Decryption unsuccessfull! please enter valid password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )));
                  print(e);
                }
              }
              if (_pathpic == null) {
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
                _textController1.clear();
              });
            },
            child: Text(
              "Decrypt",
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                letterSpacing: 1.5,
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildChooseFileButton(),
                _buildPasswordRow(),
                SizedBox(height: 40),
                _builddecryptButton(),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            Scaffold(
              // drawer: Drawer(
              //   child: ListView(
              //     padding: EdgeInsets.zero,
              //     children: <Widget>[
              //       DrawerHeader(
              //         child: Icon(Icons.security_outlined, size: 50),
              //         decoration: BoxDecoration(
              //           color: Color.fromRGBO(220, 205, 168, 1),
              //         ),
              //       ),
              //       Column(
              //         children: <Widget>[
              //           ListTile(
              //             leading: Icon(
              //               Icons.person,
              //               color: Colors.black,
              //               size: 25,
              //             ),
              //             title: Text('Profile'),
              //             onTap: () {
              //               // Do something
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => ProfilePage()));
              //             },
              //           ),
              //           ListTile(
              //             leading: Icon(
              //               Icons.chat,
              //               color: Colors.black,
              //               size: 25,
              //             ),
              //             title: Text('Chat'),
              //             onTap: () {
              //               // Do something
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => UsersListPage()));
              //             },
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // appBar: AppBar(
              //     iconTheme: IconThemeData(color: Colors.black, size: 30),
              //     leadingWidth: 100,
              //     elevation: 0,
              //     backgroundColor: Colors.transparent,
              //     actions: []),
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: Stack(
                children:
                <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // _buildLogo(),
                      _buildContainer()
                    ],
                  ),
                ],
              ),
              // ),
            ),
          ],
        ));
  }
}
