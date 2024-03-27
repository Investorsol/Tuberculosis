import 'package:flutter/material.dart';
import 'package:homepage/LoginScreen.dart';

class RestorePasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 250, 250),
      appBar: AppBar(
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Restore Password',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Change color to blue
                  letterSpacing: 2.0, // Add letter spacing
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Enter your new password',
                style: TextStyle(
                  fontSize: 18,
                  //fontStyle: FontStyle.italic, // Italicize the text
                  color: Colors.grey[600], // Darken the color
                ),
              ),
              SizedBox(height: 20),
              _buildInputField(
                labelText: 'New Password',
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 10),
              _buildInputField(
                labelText: 'Confirm New Password',
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add logic to confirm password
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  // Change button color to green
                ),
                child: Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5, // Add letter spacing
                  ),
                ),
              ),
            ],
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
        border: OutlineInputBorder(),
      ),
      obscureText: obscureText,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RestorePasswordScreen(),
  ));
}
