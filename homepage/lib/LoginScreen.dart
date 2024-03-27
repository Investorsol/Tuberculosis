import 'package:flutter/material.dart';
import 'package:homepage/ForgotPasswordScreen.dart';
import 'package:homepage/HomePage.dart';
import 'package:homepage/SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isTyping = false;
  FocusNode _userIDFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _userIDFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 250, 250),
      body: GestureDetector(
        onTap: () {
          // Hide keyboard and unfocus text fields when tapping outside
          FocusScope.of(context).unfocus();
          setState(() {
            _isTyping = false;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          alignment: _isTyping ? Alignment.topCenter : Alignment.center,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TB CONNECT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welcome to the platform',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    _buildInputField(
                      labelText: 'UserID',
                      prefixIcon: Icons.person,
                      focusNode: _userIDFocus,
                    ),
                    SizedBox(height: 5),
                    _buildInputField(
                      labelText: 'Password',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      focusNode: _passwordFocus,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: Text('Forgot Password?'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'or',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {
                        // Handle sign in with Google button press
                      },
                      icon: Icon(Icons.login),
                      label: Text('Sign in with Google'),
                    ),
                    SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text('Sign up manually'),
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
    required String labelText,
    IconData? prefixIcon,
    bool obscureText = false,
    required FocusNode focusNode,
  }) {
    return TextField(
      onTap: () {
        setState(() {
          _isTyping = true;
        });
      },
      onEditingComplete: () {
        setState(() {
          _isTyping = false;
        });
        // Unfocus the text field
        focusNode.unfocus();
      },
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(),
      ),
      obscureText: obscureText,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
