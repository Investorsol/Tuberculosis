import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(
    home: VhtChatPage(userID: 'test_user'),
  ));
}

class VhtChatPage extends StatefulWidget {
  final String userID;

  const VhtChatPage({Key? key, required this.userID}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<VhtChatPage> {
  int _selectedIndex = 0; // Default selected index
  String _searchUsername = '';

  @override
  void initState() {
    super.initState();
    print('Received ID: ${widget.userID}');
  }

  void _search(String username) {
    setState(() {
      _searchUsername = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 0; // Switch to VHT tab
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 70),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0 ? Colors.green : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                    border: _selectedIndex != 0 ? Border.all(color: Colors.green) : null, // Add border for unselected tab
                  ),
                  child: Text(
                    'USERS',
                    style: TextStyle(
                      color: _selectedIndex == 0 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 1; // Switch to Health Center tab
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1 ? Colors.green : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    border: _selectedIndex != 1 ? Border.all(color: Colors.green) : null, // Add border for unselected tab
                  ),
                  child: Text(
                    'HEALTH CENTERS',
                    style: TextStyle(
                      color: _selectedIndex == 1 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_selectedIndex == 0) // Render search engine only if VHT tab is selected
            SearchEngine(onSearch: _search),
          const SizedBox(height: 20),
          _selectedIndex == 1
              ? HealthCenterChat(userID: widget.userID)
              : CombinedChat(searchUsername: _searchUsername, userID: widget.userID),
        ],
      ),
    );
  }
}

class SearchEngine extends StatelessWidget {
  final Function(String) onSearch;

  const SearchEngine({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                if (value.isNotEmpty && value.startsWith('@')) {
                  // Search by username
                  // searchByUsername(value.substring(1)); // Remove '@' before passing to the callback
                } else {
                  // Search by location
                  searchByUsername(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search Users by username... ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  void searchByUsername(String username) {
    onSearch(username);
  }
}

class CombinedChat extends StatefulWidget {
  final String searchUsername;
  final String userID;

  const CombinedChat({Key? key, required this.searchUsername, required this.userID}) : super(key: key);

  @override
  _CombinedChatState createState() => _CombinedChatState();
}

class _CombinedChatState extends State<CombinedChat> {
  late Future<List<String>> _receiverIDsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch receiverIDs when the VHT tab is initially opened
    _receiverIDsFuture = _fetchReceiverIDs();
    // Print the receiverIDs when the future completes
    _receiverIDsFuture.then((receiverIDs) {
      print(receiverIDs);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Return an empty container if searchUsername is empty
    if (widget.searchUsername.isEmpty) {
      // Display receiver IDs even when the search username is empty
      return Expanded(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _receiverIDsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final receiverIDs = snapshot.data ?? []; // Default to an empty list if null
                    return ListView.builder(
                      itemCount: receiverIDs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green,
                            // You can customize the avatar as needed
                            child: Text(
                              '${receiverIDs[index][0]}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(receiverIDs[index]),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  username: receiverIDs[index],
                                  userID: widget.userID,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _receiverIDsFuture, // Use the future that was initialized in initState()
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final receiverIDs = snapshot.data!;
                  // Now that we have receiverIDs, we can use them to fetch VHT messages
                  return FutureBuilder<List<String>>(
                    future: _fetchCombinedChat(receiverIDs),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final messages = snapshot.data!;
                        return ListView.builder(
                          reverse: true, // Display messages in reverse order
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: Card(
                                elevation: 3, // Add shadow
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  title: Text(messages[index]),
                                  onTap: () {
                                    // Handle chat item tap
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(username: messages[index], userID: widget.userID),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
Future<List<String>> _fetchReceiverIDs() async {
  List<String> finalResultList = []; // This is the final list that will be returned

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ChatMessage')
        .get(); // Fetch all documents from 'ChatMessage' collection

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Only process documents where the ID starts with widget.userID
      if (doc.id.endsWith(widget.userID)) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        if (data.containsKey('messages') && data['messages'] is List) {
          List<dynamic> messages = data['messages'];
          bool foundV = false;

          // First pass: look for messages with 'identifier' 'v' and 'senderID' == widget.userID
          for (var message in messages) {
            if (message is Map<String, dynamic> && message['senderID'] == widget.userID && message.containsKey('identifier') && message['identifier'] == 'x') {
              String receiverID = message['receiverID'];
              if (receiverID.isNotEmpty) {
                finalResultList.add(receiverID);
                foundV = true;
                break; // Stop searching once we find a match
              }
            }
          }

          // Second pass (fallback): if no 'v' messages found, look for 'x' identifier where 'receiverID' == widget.userID
          if (!foundV) {
            for (var message in messages) {
              if (message is Map<String, dynamic> && message['receiverID'] == widget.userID && message.containsKey('identifier') && message['identifier'] == 'v') {
                finalResultList.add(message['senderID']); // Collect 'senderID'
              }
            }
          }
        }
      }
    }
  } catch (e) {
    print('Error fetching IDs: $e');
  }

  // Removing duplicates by converting the list to a set and back to a list
  return finalResultList.toSet().toList(); // Return the final list of unique IDs
}



  Future<List<String>> _fetchCombinedChat(List<String> receiverIDs) async {
    // Check if searchUsername is empty
    if (widget.searchUsername.isEmpty) {
      return []; // Return an empty list if searchUsername is empty
    }

    final vhtMessages = await FirebaseFirestore.instance
        .collection('Users')
        .where('position', isEqualTo: 'User')
        .where('username', isEqualTo: widget.searchUsername)
        .get()
        .then((querySnapshot) => querySnapshot.docs.map((doc) => doc['username'] as String).toList());
    print(widget.userID);
    return vhtMessages;
  }
}

class HealthCenterChat extends StatefulWidget {
  final String userID;

  const HealthCenterChat({Key? key, required this.userID}) : super(key: key);

  @override
  _HealthCenterChatState createState() => _HealthCenterChatState();
}

class _HealthCenterChatState extends State<HealthCenterChat> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<RiskLevel>>(
        future: _fetchRiskLevels(widget.userID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final riskLevels = snapshot.data!;
            return _buildChart(riskLevels);
          }
        },
      ),
    );
  }

  Widget _buildChart(List<RiskLevel> riskLevels) {
    return SizedBox(); // Return an empty SizedBox as the line graph is removed
  }

  Future<List<RiskLevel>> _fetchRiskLevels(String userID) async {
    final riskLevels = await FirebaseFirestore.instance
        .collection('Questionnaire')
        .where('username', isEqualTo: userID)
        .get()
        .then((querySnapshot) =>
        querySnapshot.docs.map((doc) => RiskLevel((doc['timestamp'] as Timestamp).toDate(), doc['risk_level'] as String)).toList());

    // Check if any results were obtained
    if (riskLevels.isNotEmpty) {
      print('Risk levels retrieved successfully for user: $userID');

      // Print the content of retrieved risk levels
      for (var riskLevel in riskLevels) {
        print('Date: ${riskLevel.date}, Level: ${riskLevel.level}');
      }
    } else {
      print('No risk levels found for user: $userID');
    }
    return riskLevels;
  }
}

class RiskLevel {
  final DateTime date;
  final String level;

  RiskLevel(this.date, this.level);
}

class ChatScreen extends StatefulWidget {
  final String username;
  final String userID;

  const ChatScreen({Key? key, required this.username, required this.userID}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // Add ScrollController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
        actions: [
          IconButton(
            onPressed: () {
              // Call button action
            },
            icon: const Icon(
              Icons.phone,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              // Video call button action
            },
            icon: const Icon(
              Icons.videocam,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
          border: Border.all(
            color: Colors.green,
            width: 3,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('ChatMessage')
                        .doc("${widget.username}_${widget.userID}")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(
                          child: Text('No messages yet.'),
                        );
                      }

                      var data = snapshot.data!.data() as Map<String, dynamic>;
                      List<dynamic> messages = data['messages'];
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        // Scroll to bottom after the list view is built
                        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                      });
                      return Expanded(
                        child: ListView.builder(
                          controller: _scrollController, // Assign ScrollController
                          reverse: false, // Display messages in normal order
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            // Format timestamp to 12-hour format with AM/PM indicators
                            String formattedTimestamp = _formatTimestamp(messages[index]['timestamp']);

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20), // Keep horizontal padding same
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8), // Add space between messages
                                  Align(
                                    alignment: messages[index]['senderID'] == widget.userID ? Alignment.centerRight : Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: messages[index]['senderID'] == widget.userID ? Colors.green : Colors.grey[300], // Change padding color
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            messages[index]['content'],
                                            style: const TextStyle(fontSize: 14, color: Colors.black), // Adjust the text style here
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            formattedTimestamp,
                                            style: const TextStyle(fontSize: 10, color: Colors.white), // Adjust the text style here
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Send message button action
                    sendMessage();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      var docID1 = "${widget.username}_${widget.userID}"; // Form document ID for sender perspective
      var docID2 = "${widget.username}_${widget.userID}"; // Form document ID for receiver perspective

      var chatRef = FirebaseFirestore.instance.collection('ChatMessage');

      var existingChatDoc = await chatRef.doc(docID1).get();
      var existingChatDoc2 = await chatRef.doc(docID2).get();
      if (existingChatDoc.exists) {
        // Update existing chat document
        await chatRef.doc(docID2).update({
          'messages': FieldValue.arrayUnion([
            {
              'senderID': widget.userID,
              'receiverID': widget.username,
              'content': message,
              'timestamp': DateTime.now(),
              'identifier': 'x',
            }
          ]),
        });
      } else if (existingChatDoc2.exists) {
        // Update existing chat document
        await chatRef.doc(docID2).update({
          'messages': FieldValue.arrayUnion([
            {
              'senderID': widget.username,
              'identifier': 'x',
              'receiverID': widget.userID,
              'content': message,
              'timestamp': DateTime.now(),
            }
          ]),
        });
      } else {
        // Create new chat document
        await chatRef.doc(docID1).set({
          'messages': [
            {
              'senderID': widget.userID,
              'identifier': 'x',
              'receiverID': widget.username,
              'content': message,
              'timestamp': DateTime.now(),
            }
          ],
        });
      }

      _messageController.clear();
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    // Convert Firestore Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to 12-hour format with AM/PM indicators
    return DateFormat.jm().format(dateTime); // Using jm format to get 12-hour format with AM/PM
  }
}
