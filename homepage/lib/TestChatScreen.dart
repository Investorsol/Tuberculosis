import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(
    home: TestChatScreen(userID: 'test_user'),
  ));
}

class TestChatScreen extends StatefulWidget {
  final String userID;

  const TestChatScreen({super.key, required this.userID});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<TestChatScreen> {
  int _selectedIndex = 0; // Default selected index
  String _searchLocation = '';

  @override
  void initState() {
    super.initState();
    print('Received ID: ${widget.userID}');
  }

  void _search(String location) {
    setState(() {
      _searchLocation = location;
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
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 0; // Switch to VHT tab
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0 ? Colors.green : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                    border: _selectedIndex != 0 ? Border.all(color: Colors.green) : null, // Add border for unselected tab
                  ),
                  child: Text(
                    'VHT',
                    style: TextStyle(
                      color: _selectedIndex == 0 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 1; // Switch to Health Center tab
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1 ? Colors.green : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    border: _selectedIndex != 1 ? Border.all(color: Colors.green) : null, // Add border for unselected tab
                  ),
                  child: Text(
                    'Health Center',
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
          SearchEngine(onSearch: _search),
          const SizedBox(height: 20),
          _selectedIndex == 0 && _searchLocation.isNotEmpty
              ? CombinedChat(searchLocation: _searchLocation, userID: widget.userID)
              : const HealthCenterChat(),
        ],
      ),
    );
  }
}

class SearchEngine extends StatelessWidget {
  final Function(String) onSearch;

  const SearchEngine({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                hintText: 'Enter your location',
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class CombinedChat extends StatelessWidget {
  final String searchLocation;
  final String userID;

  const CombinedChat({super.key, required this.searchLocation, required this.userID});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<String>>(
        future: _fetchCombinedChat(),
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
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ListTile(
                      title: Text(messages[index]),
                      onTap: () {
                        // Handle chat item tap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(username: messages[index], userID: userID),
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
      ),
    );
  }

  Future<List<String>> _fetchCombinedChat() async {
    final vhtMessages = await FirebaseFirestore.instance
        .collection('Users')
        .where('position', isEqualTo: 'User')
        .where('location', isEqualTo: searchLocation)
        .get()
        .then((querySnapshot) => querySnapshot.docs.map((doc) => doc['username'] as String).toList());

    final healthCenterMessages = await FirebaseFirestore.instance
        .collection('HealthCenter')
        .where('location', isEqualTo: searchLocation)
        .get()
        .then((querySnapshot) => querySnapshot.docs.map((doc) => doc['message']['content'] as String).toList());

    final combinedMessages = [...vhtMessages, ...healthCenterMessages];
    return combinedMessages;
  }
}

class HealthCenterChat extends StatelessWidget {
  const HealthCenterChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView(), // Display chat messages
          ),
        ],
      ),
    );
  }
}
class ChatScreen extends StatefulWidget {
  final String username;
  final String userID;

  const ChatScreen({super.key, required this.username, required this.userID});

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
                      WidgetsBinding.instance.addPostFrameCallback((_) {
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
                                    alignment: messages[index]['senderID'] == widget.userID ? Alignment.centerLeft : Alignment.centerRight,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: messages[index]['senderID'] == widget.userID ? Colors.grey[300] : Colors.green, // Change padding color
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
              'senderID': widget.username,
              'receiverID': widget.userID,
              'content': message,
              'timestamp': DateTime.now(),
              'identifier': 'v',
            }
          ]),
        });
      } else if (existingChatDoc2.exists) {
        // Update existing chat document
        await chatRef.doc(docID2).update({
          'messages': FieldValue.arrayUnion([
            {
              'senderID': widget.username,
              'identifier': 'v',
              'receiverID': widget.userID,
              'content': message,
              'timestamp': DateTime.now(),
            }
          ]),
        });
      } else {
        // Create new chat document
        await chatRef.doc(docID2).set({
          'messages': [
            {
              'senderID': widget.userID,
              'identifier': 'v',
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
