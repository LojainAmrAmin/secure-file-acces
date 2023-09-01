import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage{
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;


  // Future<void> uploadFile(
  //     String filePath,
  //     String fileName,
  //
  //
  //     ) async{
  //   File file = File(filePath);
  //
  //   try{
  //     await storage.ref('Encrypted/$fileName').putFile(file);
  //   } on firebase_core.FirebaseException catch(e){
  //     print(e);
  //   }
  // }


  Future<firebase_storage.ListResult> listFiles() async{
    firebase_storage.ListResult results = await storage.ref('Encrypted').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });

    return results;
  }

  Future<String> downloadURl(String fileName) async {
    String downloadURL = await storage.ref('Encrypted/$fileName').getDownloadURL();

    return downloadURL;
  }

  Future<void> deleteFile(String fileName) async {
    // Get a reference to the file
    final ref = storage.ref('Encrypted/$fileName');
    // Delete the file
    await ref.delete();
  }

  // Future<String> _getDownloadUrl(String fileName) async {
  //   final ref = FirebaseStorage.instance.ref().child('uploads/$fileName');
  //   return await ref.getDownloadURL();
  // }
////////////////////////////////////////////////
//   final ref = FirebaseStorage.instance.ref().child('testimage');
// // no need of the file extension, the name will do fine.
//   var url = await ref.getDownloadURL();
//   print(url);

}