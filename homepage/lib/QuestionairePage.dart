import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TB Symptom and Risk Assessment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    //  home: const QuestionnairePage(),
    );
  }
}

class QuestionnairePage extends StatefulWidget {
  final String userID;
  final String userPosition;  // Add this line

  // Modify the constructor to include userID
  const QuestionnairePage({Key? key, required this.userID, required this.userPosition}) : super(key: key);

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          TabBar(
            labelStyle: const TextStyle(fontSize: 16, color: Colors.green),
            controller: _tabController,
            indicatorColor: Colors.green,
            tabs: const [
              Tab(text: 'Risk Assessment'),
              Tab(text: 'Support Assessment'),
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    RiskAssessmentTab(userID: widget.userID,userPosition: widget.userPosition,),  // Updated this line
                    SocialSupportQuestionnaireTab(userID: widget.userID,userPosition: widget.userPosition,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class RiskAssessmentTab extends StatefulWidget {
  final String userID;
  final String userPosition; // Variable to hold the userID passed from another page.

  // Constructor to initialize the userID.
  const RiskAssessmentTab({Key? key, required this.userID,required this.userPosition}) : super(key: key);

  @override
  _RiskAssessmentTabState createState() => _RiskAssessmentTabState();
}

class _RiskAssessmentTabState extends State<RiskAssessmentTab> {
  late final List<bool?> _answers = List.filled(7, null);
  late TextEditingController _userIdController;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController();
    print("UserID in RiskAssessmentTab: ${widget.userID}");
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // Get username from text field
    String username = _userIdController.text.trim();

    // Check if username exists
    String? usernameID = await getID(username);

    if (usernameID != null) {
      // Username exists, proceed to submit the form
      // Analyze user inputs and determine risk level
      String riskLevel = _analyzeRiskLevel();

      // Save risk assessment result, username, and vhtID to Firestore
      if(widget.userPosition == 'vht'){
      FirebaseFirestore.instance.collection('Questionnaire').add({
        'username': username,
        'risk_level': riskLevel,
        'vhtID': widget.userID, // Use the userID passed from the other page
        'timestamp': Timestamp.now(),
      }).then((value) {
        // Display user inputs professionally
        _showResultDialog(riskLevel);
      }).catchError((error) {
        print("Failed to add risk assessment: $error");
      });} else{

                     FirebaseFirestore.instance.collection('Questionnaire').add({
        'username': username,
        'risk_level': riskLevel,
        //'vhtID': widget.userID, // Use the userID passed from the other page
        'timestamp': Timestamp.now(),
      }).then((value) {
        // Display user inputs professionally
        _showResultDialog(riskLevel);
      }).catchError((error) {
        print("Failed to add risk assessment: $error");
      });
      }

        
    } else {
      // Username does not exist, show an error message
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('Username not found. Please enter a valid username.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }

  // Additional methods (like getID and _showResultDialog) would be here.


  Future<String?> getID(String username) async {
    String? userID;
    var db = FirebaseFirestore.instance;

    await db
        .collection("Users")
        .where("username", isEqualTo: username)
        .get()
        .then((QuerySnapshot querySnapshot) {
      print("Successfully completed");

      for (var docSnapshot in querySnapshot.docs) {
        print("Found User");
        if (docSnapshot.get("username") == username) {
          userID = docSnapshot.id;
          print(userID);
          break; // Exit loop once username is found
        }
      }
    }).onError((error, stackTrace) {
      print("There was an error communicating with the database");
    });

    return userID;
  }

  String _analyzeRiskLevel() {
    int yesCount = _answers.where((answer) => answer == true).length;

    if (yesCount >= 7) {
      return 'Very High';
    }
      else if (yesCount > 4 && yesCount <7){
        return 'High';
    }// else if (yesCount >=2 && yesCount <= 3) {
      //return 'Low'; 
    //} 
     else if (yesCount <= 3){
        return 'Very Low';
    }else if (yesCount == 4) {
      return 'Moderate';
    } else {
      return 'Invalid Selection';
    }
  }

void _showResultDialog(String riskLevel) {
  Color textColor;
  switch (riskLevel.toLowerCase()) {
    case 'high':
      textColor = Colors.red;
      break;
      case 'very high':
      textColor = Colors.red;
      break;
    case 'low':
      textColor = Colors.green;
      break;
       case 'very low':
      textColor = Colors.green;
      break;
    case 'moderate':
      textColor = Colors.orange;
      break;
    default:
      textColor = Colors.black;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Risk Assessment Result'),
        content: Text(
          '$riskLevel.',
          style: TextStyle(
            color: textColor,
            fontSize: 20
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Please fill the form below to the best of your knowledge',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // User ID input field
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              QuestionWidget(
                question: 'Do you have a cough lasting more than 2 weeks?',
                onChanged: (value) {
                  setState(() {
                    _answers[0] = value;
                  });
                },
              ),
              QuestionWidget(
                question: 'Do you have fever (high temperature)?',
                onChanged: (value) {
                  setState(() {
                    _answers[1] = value;
                  });
                },
              ),
              QuestionWidget(
                question: 'Do you have night sweats?',
                onChanged: (value) {
                  setState(() {
                    _answers[2] = value;
                  });
                },
              ),
              QuestionWidget(
                question: 'Do you have unexplained weight loss?',
                onChanged: (value) {
                  setState(() {
                    _answers[3] = value;
                  });
                },
              ),
              QuestionWidget(
                question: 'Do you have loss of appetite?',
                onChanged: (value) {
                  setState(() {
                    _answers[4] = value;
                  });
                },
              ),
              QuestionWidget(
                question: 'Do you have chest pain or discomfort?',
                onChanged: (value) {
                  setState(() {
                    _answers[5] = value;
                  });
                },
              ),
              QuestionWidget(
                question:
                    'Have you been in close contact with someone diagnosed with TB?',
                onChanged: (value) {
                  setState(() {
                    _answers[6] = value;
                  });
                },
              ),
              const SizedBox(height: 20),
             Center(
  child: ElevatedButton(
    onPressed: _submitForm,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green, // Set button color to green
     // color: Colors.white, // Set text color to white
    ),
    child: const Text('Submit',style: TextStyle(color: Colors.white),), // Button text
  ),
),

            ],
          ),
        ],
      ),
    );
  }
}

class SocialSupportQuestionnaireTab extends StatefulWidget {
    final String userID;
    final String userPosition; // Variable to hold the userID passed from another page.

  // Constructor to initialize the userID.
  const SocialSupportQuestionnaireTab({Key? key, required this.userID, required this.userPosition}) : super(key: key);

  @override
  _SocialSupportQuestionnaireTabState createState() =>
      _SocialSupportQuestionnaireTabState();
}

class _SocialSupportQuestionnaireTabState
    extends State<SocialSupportQuestionnaireTab> {
  late final List<String?> _selectedOptions = List.filled(5, null);
  late TextEditingController _userIdController;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // Get user ID (username) from text field
    String username = _userIdController.text.trim();

    // Check if username exists
    String? usernameID2 = await getID(username);

    if (usernameID2 != null) {
      // Username exists, proceed to submit the form
      // Save support assessment results to Firestore
      if(widget.userPosition == 'vht'){
      FirebaseFirestore.instance.collection('SupportAssessment').add({
        'user_id': username, // Include user ID in the data
        'community_health_workers': _selectedOptions[0],
        'support_groups': _selectedOptions[1],
        'financial_assistance_programs': _selectedOptions[2],
        'psycho_social_counseling_services': _selectedOptions[3],
        'home_based_care_services': _selectedOptions[4],
        'timestamp': Timestamp.now(),
        'vht': widget.userID,
      }).then((value) {
        // Display success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content:
                  const Text('Support assessment submitted successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        // Display error message if submission fails
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Failed to submit support assessment. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
      }else{
         FirebaseFirestore.instance.collection('SupportAssessment').add({
        'user_id': username, // Include user ID in the data
        'community_health_workers': _selectedOptions[0],
        'support_groups': _selectedOptions[1],
        'financial_assistance_programs': _selectedOptions[2],
        'psycho_social_counseling_services': _selectedOptions[3],
        'home_based_care_services': _selectedOptions[4],
        'timestamp': Timestamp.now(),
      }).then((value) {
        // Display success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content:
                  const Text('Support assessment submitted successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        // Display error message if submission fails
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Failed to submit support assessment. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
      }

    } else {
      // Username does not exist, show an error message
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
                  const Text('Username not found. Please enter a valid username.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }

  Future<String?> getID(String username) async {
    String? userID;
    var db = FirebaseFirestore.instance;

    await db
        .collection("Users")
        .where("username", isEqualTo: username)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        if (docSnapshot.get("username") == username) {
          userID = docSnapshot.id;
          break; // Exit loop once username is found
        }
      }
    });

    return userID;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView( // Wrap everything with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Choose Help Level:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // User ID input field
            TextFormField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SocialSupportQuestionWidget(
              question: 'Community Health Workers',
              answers: const ['Worse', 'Not Good', 'Good', 'Very Good'],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[0] = value;
                });
              },
            ),
            SocialSupportQuestionWidget(
              question: 'Support Groups',
              answers: const ['Worse', 'Not Good', 'Good', 'Very Good'],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[1] = value;
                });
              },
            ),
            SocialSupportQuestionWidget(
              question: 'Financial Assistance Programs',
              answers: const ['Worse', 'Not Good', 'Good', 'Very Good'],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[2] = value;
                });
              },
            ),
            SocialSupportQuestionWidget(
              question: 'Psycho-social Counseling Services',
              answers: const ['Worse', 'Not Good', 'Good', 'Very Good'],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[3] = value;
                });
              },
            ),
            SocialSupportQuestionWidget(
              question: 'Home-Based Care Services',
              answers: const ['Worse', 'Not Good', 'Good', 'Very Good'],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[4] = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.green, // Set button color to green
                      ),
                child: const Text('Submit',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class SocialSupportQuestionWidget extends StatefulWidget {
  final String question;
  final List<String> answers;
  final ValueChanged<String?> onChanged;

  const SocialSupportQuestionWidget({
    super.key,
    required this.question,
    required this.answers,
    required this.onChanged,
  });

  @override
  _SocialSupportQuestionWidgetState createState() =>
      _SocialSupportQuestionWidgetState();
}

class _SocialSupportQuestionWidgetState
    extends State<SocialSupportQuestionWidget> {
  String? _answer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.answers
                .map((answer) => buildAnswerRow(answer))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget buildAnswerRow(String answer) {
    return Row(
      children: [
        Radio<String>(
          value: answer,
          groupValue: _answer,
          onChanged: (value) {
            setState(() {
              _answer = value;
              widget.onChanged(value);
            });
          },
        ),
        Text(answer),
      ],
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final String question;
  final ValueChanged<bool?> onChanged;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onChanged,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  bool? _answer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: _answer,
              onChanged: (value) {
                setState(() {
                  _answer = value;
                  widget.onChanged(value);
                });
              },
            ),
            const Text('Yes'),
            Radio<bool>(
              value: false,
              groupValue: _answer,
              onChanged: (value) {
                setState(() {
                  _answer = value;
                  widget.onChanged(value);
                });
              },
            ),
            const Text('No'),
          ],
        ),
      ],
    );
  }
}
