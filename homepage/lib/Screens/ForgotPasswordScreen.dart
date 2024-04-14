import 'package:flutter/material.dart';
import 'package:homepage/Screens/RestorePasswordScreen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 250, 250),
      appBar: AppBar(
        title: const Text('Forgot Password'),
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
                const SizedBox(height: 60,),
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,// Change color to blue
                  ),
                ),
                const Text(
                  'Enter email to restore password',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
        
                  onPressed: () {
                    // Add logic to send confirmation
                    // Handle forgot password button press
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RestorePasswordScreen()),
                    );
                  },
                  child: const Text('Send Confirmation',
                  style: TextStyle(
                    color: Colors.white
                  ),),
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
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ForgotPasswordScreen(),
  ));
}
