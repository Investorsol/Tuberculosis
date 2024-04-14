import 'package:flutter/material.dart';
import 'package:homepage/Screens/LoginScreen.dart';

class RestorePasswordScreen extends StatelessWidget {
  const RestorePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 250, 250),
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: ImageIcon(
                    AssetImage("image/link.png"),
                    size: 32,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30,),
                const Text(
                  'Restore Password',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Change color to blue
                  ),
                ),
                Text(
                  'Enter your new password',
                  style: TextStyle(
                    fontSize: 18,
                    //fontStyle: FontStyle.italic, // Italicize the text
                    color: Colors.grey[600], // Darken the color
                  ),
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  labelText: 'New Password',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                _buildInputField(
                  labelText: 'Confirm New Password',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to confirm password
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.lightGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        )
        
                  ),
                  child: const Text(
                    'Confirm Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
    home: RestorePasswordScreen(),
  ));
}
