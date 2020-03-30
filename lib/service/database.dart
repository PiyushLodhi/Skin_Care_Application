import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skin_care_app/models/brew.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection('user profile');
  //final CollectionReference messageCollection = Firestore.instance.collection('Messages');

  Future<void> updateUserData(String name,String email, int age, String gender,String position,List<String> contact) async {
    return await usersCollection.document(uid).setData({
      'name': name,
      'email':email,
      'age': age,
      'gender': gender,
      'position':position ,
      'contacts' : contact,
      'id':uid,
    });
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      //print(doc.data);
      return Brew(
          name: doc.data['name'] ?? '',
          email:doc.data['email'],
          age: doc.data['age'] ?? 0,
          gender: doc.data['gender'] ?? '',
        position: doc.data['position'] ?? '',
        contacts: doc.data['contacts'] ?? '',
        id: doc.data['id'] ?? '',
      );
    }).toList();
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return usersCollection.snapshots()
        .map(_brewListFromSnapshot);
  }


}