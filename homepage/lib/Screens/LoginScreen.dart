import 'package:flutter/material.dart';
import 'package:homepage/Screens/ForgotPasswordScreen.dart';
import 'package:homepage/HomePage.dart';
import 'package:homepage/Screens/SignUpScreen.dart';
import 'package:homepage/assets/Login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _userIDFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  TextEditingController usernametext = TextEditingController();
  TextEditingController passwordtext = TextEditingController();

  LoginDetails getID(String userName, String password) {
    LoginDetails myLogin = LoginDetails(username: userName, password: password);
    return myLogin;
  }

  Future<bool> verifyCredentials(LoginDetails myLogin) async {
    if (await myLogin.lookForUserID()) {
      if (await myLogin.lookForPassword()) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _userIDFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 250, 250),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Hide keyboard when tapping outside the text fields
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          child: SingleChildScrollView(
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
                    const SizedBox(height: 10),
                    const Text(
                      'TB CONNECT',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome to the platform',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildInputField(
                      textEditor: usernametext,
                      labelText: 'UserID',
                      prefixIcon: Icons.person,
                      focusNode: _userIDFocus,
                    ),
                    const SizedBox(height: 10),
                    _buildInputField(
                      textEditor: passwordtext,
                      labelText: 'Password',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      focusNode: _passwordFocus,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        onPressed: () async {
                          // Show the loading dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false, // User must not close the dialog by tapping outside of it
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(Colors.green),),
                                      const SizedBox(width: 20),
                                      Text("Logging in..."),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                          LoginDetails myDetails = getID(usernametext.text, passwordtext.text);
                          bool isUser = await verifyCredentials(myDetails);
                          
                          // Once the process is complete, close the loading dialog
                       //

                          if (isUser) {
                            String userNameID = await myDetails.getID();
                            String position = (await myDetails.lookForUserPrivilegeLevel()).toLowerCase();

                            // Clear text fields after successful login
                            usernametext.clear();
                            passwordtext.clear();
                               Navigator.of(context).pop();
                            // Navigate to HomePage after successful login
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(userID: userNameID, userPosition: position)));

                            // Show successful login message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Row(
                                  children: const [
                                    Icon(Icons.check_circle, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text('Login Successful'),
                                  ],
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          } else {
                               Navigator.of(context).pop();
                            // Show error if credentials are invalid
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Row(
                                  children: const [
                                    Icon(Icons.close, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text('Invalid Credentials'),
                                  ],
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left:10, right: 10, top: 5, bottom: 5),
                          child: Text('Login', style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                        );
                        usernametext.clear();
                        passwordtext.clear();
                      },
                      child: const Text('Forgot Password?'),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.green, // Changing color to green to match the button style
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          )
                      ),
                      onPressed: () {
                        // Handle sign in with Google button press
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Sign in with Google'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController textEditor,
    required String labelText,
    IconData? prefixIcon,
    bool obscureText = false,
    required FocusNode focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        controller: textEditor,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        obscureText: obscureText,
        textInputAction: TextInputAction.next,
        onSubmitted: (value) {
          // Move focus to next field
          focusNode.nextFocus();
        },
      ),
    );
  }
}
