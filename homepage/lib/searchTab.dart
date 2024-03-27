import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}
class _SearchTabState extends State<SearchTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 240, 240), // Change the color here
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                autofocus: true, // Added autofocus here
                decoration: InputDecoration(
                  hintText: '       Search...communities, stories, updates, and information',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            if (_searchQuery.isEmpty) // Show default content only if searchQuery is empty
              Column(
                children: [
                  _buildDefaultSection(
                    title: 'Communities',
                    items: [
                      'Default Community 1',
                      'Default Community 2',
                      // Add more default communities as needed
                    ],
                  ),
                  SizedBox(height: 16.0),
                  _buildDefaultSection(
                    title: 'Stories',
                    items: [
                      'Default Story 1',
                      'Default Story 2',
                      // Add more default stories as needed
                    ],
                  ),
                  SizedBox(height: 16.0),
                  _buildDefaultSection(
                    title: 'Updates and Information',
                    items: [
                      'Default Update 1',
                      'Default Update 2',
                      // Add more default updates and information as needed
                    ],
                  ),
                ],
              ),
            if (_searchQuery.isNotEmpty) // Show search results only if searchQuery is not empty
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_searchQuery.toLowerCase() == 'communities')
                    _buildSearchResultsSection(title: 'Communities'),
                  if (_searchQuery.toLowerCase() == 'stories')
                    _buildSearchResultsSection(title: 'Stories'),
                  if (_searchQuery.toLowerCase() == 'updates')
                    _buildSearchResultsSection(title: 'Updates and Information'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}


  Widget _buildDefaultSection({required String title, required List<String> items}) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          // Add default items here
          for (String item in items)
            ListTile(
              title: Text(item),
              onTap: () {
                // Handle default item selection
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsSection({required String title}) {
    // This widget will be populated based on user's search query
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Search Results for $title",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          // Add search results widget here
          // Display a list of items based on search
        ],
      ),
    );
  }

