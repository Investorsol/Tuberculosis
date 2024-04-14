import 'package:cloud_firestore/cloud_firestore.dart';
class LoginDetails {
  final String username;
  final String password;

  LoginDetails({
    required this.username,
    required this.password,
  });

  Future<bool> _checkIfExists() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("username", isEqualTo: username)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<String> getID() async {
    if (await _checkIfExists()) {
      return username;
    } else {
      throw Exception('Username not found in database');
    }
  }

  Future<bool> lookForUserID() async {
    return await _checkIfExists();
  }

  Future<bool> lookForPassword() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("password", isEqualTo: password)
        .where("username", isEqualTo: username)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<String> lookForUserPrivilegeLevel() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("username", isEqualTo: username)
        .get();
    return querySnapshot.docs.isNotEmpty
        ? querySnapshot.docs.first.get("position")
        : "";
  }
}