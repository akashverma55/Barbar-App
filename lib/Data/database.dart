import 'package:cloud_firestore/cloud_firestore.dart';

class Database {

  Future addUserDetails(Map<String,dynamic> UserInfoMap, String id) async{
    return await FirebaseFirestore.instance
    .collection("users")
    .doc(id)
    .set(UserInfoMap);
  }

  Future addUserBooking(Map<String,dynamic> UserInfoMap) async{
    return await FirebaseFirestore.instance
    .collection("booking")
    .add(UserInfoMap);
  }

  Stream<QuerySnapshot> getBookings() {
    return FirebaseFirestore.instance.collection("booking").snapshots();
  } 

  Future deleteUserBooking(String ID) async{
    return await FirebaseFirestore.instance
    .collection("booking")
    .doc(ID)
    .delete();
  }
}