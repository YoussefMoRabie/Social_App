import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../types/failure.dart';
import '../types/type_defs.dart';
import 'firestore_providers.dart';


final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask;

      uploadTask = ref.putFile(file!);

      final snapshot = await uploadTask;

      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  
  void deleteFile({required String path, required String id}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      await ref.delete();
    } catch (e) {
      throw e.toString();
    }
  }

  void deleteAllPostFiles({required String path}) async {
    try {
      final ref = _firebaseStorage.ref().child(path);
      final ListResult result = await ref.listAll();
      for (final Reference ref in result.items) {
        await ref.delete();
      }
    } catch (e) {
      throw e.toString();
    }
  }


  

}