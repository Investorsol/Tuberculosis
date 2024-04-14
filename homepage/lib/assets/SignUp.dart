import "package:cloud_firestore/cloud_firestore.dart";

class SignUp{

  String name;
  String email;
  String password;
  String userID = "";
  String _location = "";
  String _position = "";
  String _age = "";
  String _TB_status = "";
  String _gender = "";
  String vht;

  SignUp({
    required this.name,
    required this.email,
    required this.password,
    required this.vht,
});

  bool uniqueEmail(String name){
    //To be implemented
    return true;
  }

  void setLocation(String location){
    _location = location;
  }

  void setPosition(String position){
    _position = position;
  }

  void setAge(String age){
    _age = age;
  }

  void setTB_Status(String tbStatus){
    _TB_status = tbStatus;
  }

  void setGender(String gender){
    _gender = gender;
  }

  String getGender(){
    return _gender;
  }

  String getLocation(){
    return _location;
  }

  String getPosition(){
    return _position;
  }

  String getAge(){
    return _age;
  }

  String getTB_Status(){
    return _TB_status;
  }

  bool confirmEmailExists(String email){
    //To be implemented
    return false;
  }

  Map<String, String> prepareData(){
    return {
      'username' : name,
      'password' : password,
      'email' : email,
      'location' : _location,
      'position' : "User",
      'age' : _age,
      'TB_status' : _TB_status,
      'gender' : _gender,
      'vht' : vht,
    };
  }

  Future<bool> sendDataToServer() async{
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection("Users").add(prepareData()).then((DocumentReference doc) =>
      userID = doc.id
    );
    if(userID == ""){
      return false;
    }
    else{
      return true;
    }
  }
}