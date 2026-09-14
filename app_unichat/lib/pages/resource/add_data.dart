import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String userId, Uint8List file) async {
    Reference ref = _storage.ref().child('profileImages').child(userId);
    UploadTask uploadTask = ref.putData(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    TaskSnapshot snapshot = await uploadTask;
    return snapshot.ref.getDownloadURL();
  }

  Future<String> saveData({
    required Uint8List file,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return 'Faça login para enviar a foto.';
    }
    try {
      String imageUrl = await uploadImageToStorage(user.uid, file);
      await _firestore.collection('usuarios').doc(user.uid).update({
        'imageLink': imageUrl,
      });
      return 'success';
    } catch (err) {
      return err.toString();
    }
  }
}
