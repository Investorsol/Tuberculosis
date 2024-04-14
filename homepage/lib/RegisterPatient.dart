import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepage/assets/SignUp.dart';

class RegisterPatient extends StatelessWidget {
  final String userID;

  const RegisterPatient({Key? key, required this.userID}) : super(key: key);

  Future<bool> checkUsername(String username) async {
    var db = FirebaseFirestore.instance;
    bool usernameExists = false;

    await db
        .collection("Users")
        .where("username", isEqualTo: username)
        .get()
        .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            usernameExists = true;
          }
        });

    return usernameExists;
  }

  Future<bool> createSignUpRecord(String username, String password, String email) async {
    bool usernameExists = await checkUsername(username);
    if (usernameExists) {
      return false;
    }
    SignUp myRecord = SignUp(name: username, email: email, password: password, vht: userID);
    await myRecord.sendDataToServer();

    return myRecord.userID != "";
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController usernametext = TextEditingController();
    TextEditingController emailtext = TextEditingController();
    TextEditingController passwordtext = TextEditingController();
    TextEditingController confirmpasswordtext = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 250, 250),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  const SizedBox(height: 70),
                const Text(
                  'Patient SignUp',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Please Register Patient Below',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  textEditor: usernametext,
                  labelText: 'UserID',
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 10),
                _buildInputField(
                  textEditor: emailtext,
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 10),
                _buildInputField(
                  textEditor: passwordtext,
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                _buildInputField(
                  textEditor: confirmpasswordtext,
                  labelText: 'Confirm Password',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    String username = usernametext.text.trim();
                    String email = emailtext.text.trim();
                    String password = passwordtext.text.trim();
                    String confirmPassword = confirmpasswordtext.text.trim();

                    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                      _showDialog(context, "Error", "All fields are required.");
                      return;
                    }

                    bool isValidEmail = RegExp(
                      r'^[a-zA-Z0-9._-]+@(gmail\.com|yahoo\.com)$'
                    ).hasMatch(email);

                    if (!isValidEmail) {
                      _showDialog(context, "Invalid Email", "Please use a valid email address.");
                      return;
                    }

                    if (password != confirmPassword) {
                      _showDialog(context, "Password Mismatch", "Passwords do not match.");
                      return;
                    }

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Dialog(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                                SizedBox(width: 20),
                                Text("Signing Up..."),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    bool success = await createSignUpRecord(username, password, email);
                    Navigator.of(context).pop(); // Close the progress dialog

                    if (!success) {
                      _showDialog(context, "Sign Up Failed", "Username already exists, please choose another username.");
                    } else {
                       usernametext.clear();
                      emailtext.clear();
                      passwordtext.clear();
                      confirmpasswordtext.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Row(
                            children: const [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 10),
                              Text('Sign Up Successful', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputField({
    required String labelText,
    IconData? prefixIcon,
    bool obscureText = false,
    required TextEditingController textEditor,
  }) {
    return TextField(
      controller: textEditor,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
    );
  }
}
