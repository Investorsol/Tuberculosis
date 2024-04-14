import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String userID;

  const ProfilePage({super.key, required this.userID});

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfilePage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    print('UserID: ${widget.userID}');
    _userDataFuture = _loadUserData();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _loadUserData() async {
    // Load user data from Firestore using the provided username
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: widget.userID)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      throw Exception('User data not found for username: ${widget.userID}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                final userData = snapshot.data!.data();
                if (userData != null) {
                  final age = userData['age'] ?? '';
                  final email = userData['email'] ?? '';
                  final gender = userData['gender'] ?? '';
                  final location = userData['location'] ?? '';
                  final password = userData['password'] ?? '';
                  final position = userData['position'] ?? '';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage('assets/images/person_icon.png'), // Add your image asset here
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Profile Information',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildInfoRow('Position', position),
                            const SizedBox(height: 20),
                            _buildInfoRow('Age', age),
                            const SizedBox(height: 20),
                            _buildInfoRow('Email', email),
                            const SizedBox(height: 20),
                            _buildInfoRow('Gender', gender),
                            const SizedBox(height: 20),
                            _buildInfoRow('Location', location),
                              const SizedBox(height: 20),
                               const SizedBox(height: 20),
                                const SizedBox(height: 20),
                              
                              
                              
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                                     style: ElevatedButton.styleFrom(
                                     backgroundColor: Colors.green, // Set button color to green
                                     ),
                          onPressed: () async {
                            // Navigate to edit profile screen
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfilePage(userData: userData)),
                            );
                            // Check if the result is true, indicating that the profile was updated
                            if (result == true) {
                              // Reload user data
                              setState(() {
                                _userDataFuture = _loadUserData();
                              });
                            }
                          },
                          child: const Text('Edit Profile',style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: Text('No user data available'));
                }
              } else {
                return const Center(child: Text('No data available'));
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.end, // Align the text to the right
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const EditProfilePage({super.key, this.userData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _ageController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;
  late TextEditingController _locationController;
  late TextEditingController _positionController;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(text: widget.userData?['age'] ?? '');
    _emailController = TextEditingController(text: widget.userData?['email'] ?? '');
    _genderController = TextEditingController(text: widget.userData?['gender'] ?? '');
    _locationController = TextEditingController(text: widget.userData?['location'] ?? '');
    _positionController = TextEditingController(text: widget.userData?['position'] ?? '');
  }

  @override
  void dispose() {
    _ageController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _locationController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              ElevatedButton(
                 style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.green, // Set button color to green
                           ),
                onPressed: () async {
                  // Update the profile and return true to indicate success
                  await _updateProfile();
                  Navigator.pop(context, true);
                },
                child: const Text('Update Profile',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    // Get the username from the userData map
    String username = widget.userData?['username'] ?? '';

    try {
      // Retrieve the document ID based on the username
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Extract the document ID
        String documentID = querySnapshot.docs.first.id;

        // Update the profile data in Firestore
        await FirebaseFirestore.instance.collection('Users').doc(documentID).update({
          'age': _ageController.text,
          'email': _emailController.text,
          'gender': _genderController.text,
          'location': _locationController.text,
          'position': _positionController.text,
        });

        // Successfully updated profile
      } else {
        // User document not found
        throw Exception('User document not found for username: $username');
      }
    } catch (error) {
      // Error occurred while updating profile
      print('Error updating profile: $error');
    }
  }
}
