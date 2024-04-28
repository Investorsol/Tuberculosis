import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepage/HighRiskTuberculosisPage.dart';

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
              Tab(text: ' Drugs Adherence '),
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
    case 'very high':
      textColor = Colors.red;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Risk Assessment Result'),
            content: Text(
              '$riskLevel.',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HighRiskTuberculosisPage(userID: widget.userID,)),
                    );
                  
                },
                child: const Text('Continue'),
              ),
            ],
          );
        },
      );
      break;
    case 'low':
    case 'very low':
    case 'moderate':
      textColor = Colors.green;
   showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Risk Assessment Result'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$riskLevel.',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10), // Add some space between the two Text widgets
          Text(
            'Join TB Communities now, and learn how to prevent TB',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Close'),
        ),
      ],
    );
  },
);
;
      break;
    default:
      textColor = Colors.black;
  }
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
  late final List<String?> _selectedOptions = List.filled(8, null);
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
        'tuberculosis_medication': _selectedOptions[0],
        'other_disease': _selectedOptions[1],
        'tablets_side_effects': _selectedOptions[2],
        'missed_dozes': _selectedOptions[3],
        'medication_improvement': _selectedOptions[4],
        'treatment_hinderance': _selectedOptions[5],
         'received_counselling': _selectedOptions[6],
         'guidance&counselling_help': _selectedOptions[7],
        'vht': widget.userID,
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
      }else{
         FirebaseFirestore.instance.collection('SupportAssessment').add({
        'user_id': username, // Include user ID in the data
        'tuberculosis_medication': _selectedOptions[0],
        'other_disease': _selectedOptions[1],
        'tablets_side_effects': _selectedOptions[2],
        'missed_dozes': _selectedOptions[3],
        'medication_improvement': _selectedOptions[4],
        'treatment_hinderance': _selectedOptions[5],
         'received_counselling': _selectedOptions[6],
         'guidance&counselling_help': _selectedOptions[7],
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
              question: 'Are you on any Tuberculosis medication',
              answers: const ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[0] = value;
                });
              },
            ),
            SocialSupportQuestionWidget(
              question: 'Do you have any other diseases aprt from tuberculosis',
              answers: const ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[1] = value;
                });
              },
            ),
            SocialSupportQuestionWidget(
              question: 'Do you get side effects from tablets being taken',
              answers: const ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[2] = value;
                });
              },
            ),
            SocialSupportQuestionWidget(
              question: 'Have you missed any dozes',
              answers: const ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[3] = value;
                });
              },
            ),
            SocialSupportQuestionWidget(
              question: 'Are you experiencing any improvement from the medication',
              answers: const ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[4] = value;
                });
              },
            ),
            SocialSupportQuestionWidget(
              question: 'Dou you have any other challenges that can hinder you from Tuberculosis treatment',
              answers: const ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[5] = value;
                });
              },
            ),
            SocialSupportQuestionWidget(
              question: 'Have you heard any guidance an counselling',
              answers: const ['Yes', 'No', ],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[6] = value;
                });
              },
            ),
            SocialSupportQuestionWidget(
              question: 'Did the guidance and counselling help you during your medication',
              answers: const ['Yes', 'No'],
              onChanged: (value) {
                setState(() {
                  _selectedOptions[7] = value;
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
