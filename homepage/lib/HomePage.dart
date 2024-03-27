import 'package:flutter/material.dart';
import'package:homepage/Community.dart';
import'package:homepage/QuestionairePage.dart';
import'package:homepage/searchTab.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 4, 51, 90),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeTab(),
    SearchTab(),
    ProfileTab(),
    Community(),
    QuestionairePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('USER ID'),
        
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'survey',
          ),
        ],
        selectedIconTheme: IconThemeData(color: Color.fromARGB(255, 46, 9, 9)),
        unselectedItemColor: Color.fromARGB(255, 17, 2, 72),
      ),
    );
  }
}class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Communities',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4, // Set the number of images
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      'https://via.placeholder.com/150', // Placeholder image URL
                      width: 150,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Stories',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4, // Set the number of stories
              itemBuilder: (context, index) {
                // Replace the placeholder widget with your story widget
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    width: 250,
                    height: 50,
                    color: Colors.blueGrey,
                    child: Center(
                      child: Text(
                        'Story ${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Updates And Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4, // Set the number of communities
            itemBuilder: (context, index) {
              // Replace the placeholder widget with your community widget
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: CommunityListItem(
                  name: 'Community ${index + 1}',
                  slogan: 'Slogan for Community ${index + 1}',
                  icon: Icons.group,
                ),
              );
            },
          ),
          SizedBox(height: 20), // Add some space between the galleries and other content
        ],
      ),
    );
  }
}



class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 244, 242, 242),
      child: Center(
        child: Text(
          'Welcome to the Chat Tab',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}



