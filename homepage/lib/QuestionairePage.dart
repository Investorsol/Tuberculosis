import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TB Symptom and Risk Assessment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuestionairePage(),
    );
  }
}

class QuestionairePage extends StatefulWidget {
  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionairePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Remove the AppBar
      body: Column(
        children: [
          TabBar(
            labelStyle: TextStyle(fontSize: 16),
            controller: _tabController,
            tabs: [
              Tab(text: 'Risk Assessment'),
              Tab(text: 'Support Assessment'),
            ],
          ),
     Expanded(
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white, // Set the desired color
      border: Border.all(
        color: Colors.grey, // Set the color of the border
        width: 1.0, // Set the width of the border
      ),
      borderRadius: BorderRadius.circular(20.0), // Set border radius
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0), // Add your desired padding here
      child: TabBarView(
        controller: _tabController,
        children: [
          RiskAssessmentTab(),
          SocialSupportQuestionnaireTab(),
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

class RiskAssessmentTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                'Please fill the form below to the best of your knowledge',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              QuestionWidget(
                question: 'Do you have a cough lasting more than 2 weeks?',
              ),
              QuestionWidget(
                question: 'Do you have fever (high temperature)?',
              ),
              QuestionWidget(
                question: 'Do you have night sweats?',
              ),
              QuestionWidget(
                question: 'Do you have unexplained weight loss?',
              ),
              QuestionWidget(
                question: 'Do you have loss of appetite?',
              ),
              QuestionWidget(
                question: 'Do you have chest pain or discomfort?',
              ),
              QuestionWidget(
                question: 'Have you been in close contact with someone diagnosed with TB?',
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle form submission
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SocialSupportQuestionnaireTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            'Choose level of help from the following social support services during your Tuberculosis care and recovery:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                SocialSupportQuestionWidget(
                  question: 'Community Health Workers',
                  answers: ['Worse', 'Not Good', 'Good', 'Very Good'],
                ),
                SocialSupportQuestionWidget(
                  question: 'Support Groups',
                  answers: ['Worse', 'Not Good', 'Good', 'Very Good'],
                ),
                SocialSupportQuestionWidget(
                  question: 'Financial Assistance Programs',
                  answers: ['Worse', 'Not Good', 'Good', 'Very Good'],
                ),
                SocialSupportQuestionWidget(
                  question: 'Psycho-social Counseling Services',
                  answers: ['Worse', 'Not Good', 'Good', 'Very Good'],
                ),
                SocialSupportQuestionWidget(
                  question: 'Home-Based Care Services',
                  answers: ['Worse', 'Not Good', 'Good', 'Very Good'],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Handle form submission
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialSupportQuestionWidget extends StatefulWidget {
  final String question;
  final List<String> answers;

  const SocialSupportQuestionWidget({
    Key? key,
    required this.question,
    required this.answers,
  }) : super(key: key);

  @override
  _SocialSupportQuestionWidgetState createState() => _SocialSupportQuestionWidgetState();
}

class _SocialSupportQuestionWidgetState extends State<SocialSupportQuestionWidget> {
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
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.answers.map((answer) => buildAnswerRow(answer)).toList(),
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

  const QuestionWidget({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  bool _answer = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question,
          style: TextStyle(
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
                  _answer = value!;
                });
              },
            ),
            Text('Yes'),
            Radio<bool>(
              value: false,
              groupValue: _answer,
              onChanged: (value) {
                setState(() {
                  _answer = value!;
                });
              },
            ),
            Text('No'),
          ],
        ),
      ],
    );
  }
}
