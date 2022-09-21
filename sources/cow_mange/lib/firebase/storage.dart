import 'dart:io';

import 'package:cow_mange/class/Cow.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  UploadTask? task;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future uploadFile(file, Cow? cow) async {
    if (file == null) return;

    final fileName = file!.path;
    final fileExtension = fileName.split(".").last;
    final name = fileExtension;
    final namecow = cow!.cow_id;
    final destination = 'Cow/$namecow';

    task = uploadFile2(destination, file!);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    String textUrldownload = urlDownload;

    return textUrldownload;
  }

  static firebase_storage.UploadTask? uploadFile2(
      String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on firebase_storage.FirebaseException {
      return null;
    }
  }

  Future<firebase_storage.ListResult> listFile() async {
    firebase_storage.ListResult result = await storage.ref('test').listAll();

    for (var ref in result.items) {
      print("found :$ref");
    }
    return result;
  }
}
