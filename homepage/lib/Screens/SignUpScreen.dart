import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepage/Screens/LoginScreen.dart';
import 'package:homepage/assets/SignUp.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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

  Future<bool> createSignUpRecord(
      String username, String password, String email) async {
    bool usernameExists = await checkUsername(username);
    if (usernameExists) {
      return false;
    }
    SignUp myRecord = SignUp(name: username, email: email, password: password,vht: '');
    await myRecord.sendDataToServer();

    if (myRecord.userID == "") {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController usernametext = TextEditingController();
    TextEditingController emailtext = TextEditingController();
    TextEditingController passwordtext = TextEditingController();
    TextEditingController confirmpasswordtext = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 250, 250),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 70,
                  height: 70,
                  child: ImageIcon(
                    AssetImage("image/link.png"),
                    size: 36,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'TB CONNECT',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome to the platform',
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
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                                const SizedBox(width: 20),
                                Text("Signing Up..."),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    String username = usernametext.text.trim();
                    String email = emailtext.text.trim();
                    String password = passwordtext.text.trim();
                    String confirmPassword = confirmpasswordtext.text.trim();

                    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                      Navigator.of(context).pop(); // Close the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content: const Text("All fields are required."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    bool isValidEmail = RegExp(
                      r'^[a-zA-Z0-9._-]+@(gmail\.com|yahoo\.com)$'
                    ).hasMatch(email);

                    if (!isValidEmail) {
                      Navigator.of(context).pop(); // Close the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Invalid Email"),
                            content: const Text("Please use a valid email address."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                                               if (password.length < 6) {
                                                 Navigator.of(context).pop(); 
      // Show password length error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          elevation: 6,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: const Text(
            'Password must be at least 6 characters long',
            style: TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return; // Exit onPressed callback
    }
                    if (password != confirmPassword) {
                      Navigator.of(context).pop(); // Close the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Password Mismatch"),
                            content: const Text("Passwords do not match."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    bool success = await createSignUpRecord(username, password, email);
                    Navigator.of(context).pop(); // Close the dialog

                    if (!success) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Sign Up Failed"),
                            content: const Text("Username already exists, please choose another username."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                         // Show sign-up successful message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          elevation: 6,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Sign Up Successful',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Handle terms and conditions
                  },
                  child: const Text(
                      'By signing up, you agree to our Terms & Conditions'),
                ),
              ],
            ),
          ),
        ),
      ),
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
