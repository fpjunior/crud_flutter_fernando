import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Database {
  FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> create(String name, String description, String urlImage,
      String urlImage2, String urlImage3, String preco) async {
    try {
      await firestore.collection("produtos").add({
        'name': name,
        'description': description,
        'urlImage 1': urlImage,
        'urlImage 2': urlImage2,
        'urlImage 3': urlImage3,
        'preco': preco,
        // 'timestamp': FieldValue.serverTimestamp()
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore.collection("produtos").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot =
          await firestore.collection('produtos').orderBy('name').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "name": doc['name'],
            "description": doc["description"],
            "urlImage": doc["urlImage"],
            "urlImage2": doc["urlImage2"],
            "urlImage3": doc["urlImage3"],
            "preco": doc["preco"],
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> update(String id, String name, String description,
      String urlImage, String urlImage2, String urlImage3, String preco) async {
    try {
      await firestore.collection("produtos").doc(id).update({
        'name': name,
        'description': description,
        'urlImage': urlImage,
        'urlImage2': urlImage2,
        'urlImage3': urlImage3,
        'preco': preco
      });
    } catch (e) {
      print(e);
    }
  }
}
