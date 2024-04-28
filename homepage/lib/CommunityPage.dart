import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  final String communityName;
  final String communityDescription;

  const CommunityPage({Key? key, required this.communityName, required this.communityDescription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(communityName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCommunityInfo(context),
            _buildPosts(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityInfo(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to $communityName',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Description:.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '$communityDescription.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
           onPressed: () {
  // Navigate to the SocialMediaActivityPage and replace the current page
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => SocialMediaActivityPage(communityName: communityName),
    ),
  );
},
            child: Text('Join Community'),
          ),
        ],
      ),
    );
  }

  Widget _buildPosts() {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Posts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildPost(
            authorName: 'John Doe',
            timeAgo: '2 hours ago',
            content: 'This is a sample post content. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          ),
          SizedBox(height: 12),
          _buildPost(
            authorName: 'Jane Smith',
            timeAgo: '5 hours ago',
            content: 'Another sample post. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          ),
          // Add more posts here
        ],
      ),
    );
  }

  Widget _buildPost({
    required String authorName,
    required String timeAgo,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            authorName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            timeAgo,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }
}

class SocialMediaActivityPage extends StatelessWidget {
  final String communityName;

  const SocialMediaActivityPage({Key? key, required this.communityName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(communityName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPost(
              authorName: 'John Doe',
              timeAgo: '2 hours ago',
              content: 'This is a sample post content. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            ),
            _buildPostActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPost({
    required String authorName,
    required String timeAgo,
    required String content,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            authorName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            timeAgo,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }

  Widget _buildPostActions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              // Implement like functionality
            },
            icon: Icon(Icons.thumb_up),
          ),
          IconButton(
            onPressed: () {
              // Implement comment functionality
            },
            icon: Icon(Icons.comment),
          ),
          IconButton(
            onPressed: () {
              // Implement share functionality
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CommunityPage(communityName: 'Sample Community', communityDescription: 'Sample Community'),
  ));
}
