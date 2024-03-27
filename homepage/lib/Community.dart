import 'package:flutter/material.dart';

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
      home: Community(),
    );
  }
}

class Community extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Communities'), // First tab
                Tab(text: 'People'), // Second tab
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Content for the "Communities" tab
                  CommunityTab(),
                  // Content for the "People" tab
                  PeopleTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CommunityListItem(
          name: 'Community 1',
          slogan: 'Slogan for Community 1',
          icon: Icons.group,
        ),
        CommunityListItem(
          name: 'Community 2',
          slogan: 'Slogan for Community 2',
          icon: Icons.group,
        ),
        CommunityListItem(
          name: 'Community 3',
          slogan: 'Slogan for Community 3',
          icon: Icons.group,
        ),
        CommunityListItem(
          name: 'Community 4',
          slogan: 'Slogan for Community 4',
          icon: Icons.group,
        ),
        // Add more CommunityListItem widgets for additional communities
      ],
    );
  }
}

class PeopleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PersonListItem(
          name: 'Person 1',
          slogan: 'Slogan for Person 1',
          icon: Icons.person,
        ),
        PersonListItem(
          name: 'Person 2',
          slogan: 'Slogan for Person 2',
          icon: Icons.person,
        ),
        PersonListItem(  name: 'Person 3',
          slogan: 'Slogan for Person 3',
          icon: Icons.person,
        ),
        PersonListItem(  name: 'Person 4',
          slogan: 'Slogan for Person 4',
          icon: Icons.person,
        ),
        // Add more PersonListItem widgets for additional people
      ],
    );
  }
}

class CommunityListItem extends StatelessWidget {
  final String name;
  final String slogan;
  final IconData icon;

  const CommunityListItem({
    required this.name,
    required this.slogan,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust padding here
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon),
                  SizedBox(width: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                slogan,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonListItem extends StatelessWidget {
  final String name;
  final String slogan;
  final IconData icon;

  const PersonListItem({
    required this.name,
    required this.slogan,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust padding here
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon),
                  SizedBox(width: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                slogan,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
