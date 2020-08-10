import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:skin_care_app/chate/models/message.dart';
import 'package:skin_care_app/models/brew.dart';
class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });
  Firestore _firestore = Firestore.instance;
  final CollectionReference usersCollection = Firestore.instance.collection('user profile');

  Future<void> updateUserData(String name,String email, int age, String gender,String position,List<dynamic> contact,int patients) async {
    print(position);
    return await usersCollection.document(uid).setData({
      'name': name,
      'email':email,
      'age': age,
      'gender': gender,
      'position':position ,
      'contacts' : contact,
      'id':uid,
      'patients':patients,
    });
  }


  Future<void> updateUserDat1(String name,String email, int age, String gender,String position,List<String> contact,int patients,String uid) async {
    return await usersCollection.document(uid).setData({
      'name': name,
      'email':email,
      'age': age,
      'gender': gender,
      'position':position ,
      'contacts' : contact,
      'id':uid,
      'patients':patients,
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
  Stream<QuerySnapshot> get brews {
    return usersCollection.snapshots();
        //.map(_brewListFromSnapshot);
  }
  Future<QuerySnapshot> getAllDocuments() {
    return _firestore.collection('user profile').getDocuments();
  }

  Future<QuerySnapshot> checkreciever(senderuid) {
    return _firestore.collection('messages').document(senderuid).collection(uid).getDocuments();//.document(_senderuid)
        //.collection(widget.receiverUid);
  }
  Future<String> pickImage1(imageFile,String recieverUid) async {
    //File imageFile;
    StorageReference _storageReference;
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();

    print("URL: $url");



    uploadImageToDb(url,recieverUid);
    return url;
  }

  void uploadImageToDb(String downloadUrl,String receiverUid) {
    CollectionReference _collectionReference;
   Message _message = Message.withoutMessage(
        receiverUid: receiverUid,
        senderUid: uid,
        photoUrl: downloadUrl,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = Map<String, dynamic>();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    map['timestamp'] = _message.timestamp;
    map['photoUrl'] = _message.photoUrl;

    print("Map : ${map}");
    _collectionReference = Firestore.instance
        .collection("messages")
        .document(_message.senderUid)
        .collection(_message.receiverUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });
    _collectionReference = Firestore.instance
        .collection("messages")
        .document(_message.receiverUid)
        .collection(_message.senderUid);

    _collectionReference.add(map).whenComplete(() {
      print("Messages added to db");
    });
  }
  Brew _userDatafromsnapshot(DocumentSnapshot document)
  {
    return Brew(name: document.data['name'],
      email:document.data['name'],
      age:document.data['age'],
      gender: document.data['gender'],
      position:document.data['position'] ,
      contacts :document.data['contacts'],
      id:uid,
      patients:document.data['patients']);
  }
  Stream<Brew> get userData1
  {
    return usersCollection.document(uid).snapshots().map(_userDatafromsnapshot);
  }
}