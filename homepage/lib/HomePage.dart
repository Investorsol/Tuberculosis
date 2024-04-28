import 'package:flutter/material.dart';
import 'package:homepage/ProfilePage.dart';
import 'package:homepage/Screens/LoginScreen.dart';
import 'package:homepage/assets/CommunityInfo.dart';
import 'package:homepage/QuestionairePage.dart';
import 'package:homepage/assets/Story.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homepage/ChatPage.dart';
import 'package:homepage/VhtChat.Page.dart';
import 'package:homepage/Screens/SignUpScreen.dart';
import 'package:homepage/RegisterPatient.dart';
import 'package:homepage/CommunityPage.dart';
import 'package:collection/collection.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.userID, required this.userPosition}) : super(key: key);

  final String userID;
  final String userPosition;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userid;
  late String position;
  int _currentIndex = 0;
  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _navBarItems;

  @override
  void initState() {
    super.initState();
    userid = widget.userID;
    position = widget.userPosition;
    _initPagesAndNavBarItems();
  }

  void _initPagesAndNavBarItems() {
    if (position == 'vht') {
      _pages = [
        const HomeTab(),
        VhtChatPage(userID: userid),
        QuestionnairePage(userID: userid, userPosition: position),
        RegisterPatient(userID: userid),
        ProfilePage(userID: userid),
      ];
      _navBarItems = [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        const BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Survey'),
        const BottomNavigationBarItem(icon: Icon(Icons.app_registration), label: 'SignUp'),
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    } else {
      _pages = [
        const HomeTab(),
        ChatPage(userID: userid),
        QuestionnairePage(userID: userid, userPosition: position),
        ProfilePage(userID: userid),
      ];
      _navBarItems = [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        const BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Survey'),
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
  body: SafeArea(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                 Text(
                '   USERID : $userid',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add logout functionality here
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
           
            ],
          ),
        ),
        Expanded(
          child: _pages[_currentIndex],
        ),
        BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.blue,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          iconSize: 30,
          items: _navBarItems,
          selectedIconTheme: const IconThemeData(color: Colors.green),
          unselectedItemColor: Colors.blueGrey,
        ),
      ],
    ),
  ),
);

  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future<List<CommunityInfo>> _communityInfoFuture;
  late Future<List<Story>> _storiesFuture;
  final TextEditingController _searchController = TextEditingController();
  final List<CommunityInfo> _searchResult = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    _communityInfoFuture = getCommunities();
    _storiesFuture = getStories();
  }

  Widget _buildSearchWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for a community...',
          contentPadding: const EdgeInsets.all(16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          suffixIcon: const Icon(Icons.search),
        ),
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
          });
          _searchCommunity(value);
        },
      ),
    );
  }

  void _searchCommunity(String query) {
    if (query.isNotEmpty) {
      List<CommunityInfo> tempList = [];

      // Filter communities whose name contains the query string
      _communityInfoFuture.then((communities) {
        tempList.addAll(communities.where((community) => community.name.toLowerCase().contains(query.toLowerCase())));
        setState(() {
          _searchResult.clear();
          _searchResult.addAll(tempList);
        });
      });
    } else {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              ' TB CONNECT',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSearchWidget(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Communities',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: FutureBuilder<List<CommunityInfo>>(
                    future: _isSearching ? Future.value(_searchResult) : _communityInfoFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<CommunityInfo> listOfCommunities = snapshot.data ?? [];
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: listOfCommunities.length,
                          itemBuilder: (context, index) {
                            return _buildCommunityCard(listOfCommunities[index]);
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Stories',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: FutureBuilder<List<Story>>(
                    future: _storiesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<Story> listOfStories = snapshot.data ?? [];
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: listOfStories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Material(
                                elevation: 20,
                                borderRadius: BorderRadius.circular(2),
                                child: Container(
                                  width: 300,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 275,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: listOfStories[index].imageUrlPath,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 0.2,),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Expanded(
                                        child: Center(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Updates And Information',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<CommunityInfo>>(
                  future: _communityInfoFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<CommunityInfo> myupdates = snapshot.data ?? [];
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: myupdates.length,
                        itemBuilder: (context, index) {
                          CommunityInfo community = myupdates[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  community.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      community.description,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Date: ${DateTime.now().toString().split(' ')[0]}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _showFullStory(community.name); // Call function to show full story
                                          },
                                          child: const Text(
                                            'View Details',
                                            style: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard(CommunityInfo community) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityPage(communityDescription: community.description, communityName: community.name),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: community.imageUrlPath,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        community.name,
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Story>> getStories() async {
    List<Story> mystories = [];

    var db = FirebaseFirestore.instance;
    await db.collection("Stories").get().then((QuerySnapshot querySnapshot) {
      print("Successfully retrieved");

      for (var documents in querySnapshot.docs) {
        Story story = Story();
        story.ID = documents.id;
        story.description = documents.get("Description");
        story.datePosted = documents.get("Date_Posted");
        story.fullStory = documents.get("Full_Story");
        story.imageUrlPath = documents.get("Image_Path");

        mystories.add(story);
      }
    });

    return mystories;
  }

  Future<List<CommunityInfo>> getCommunities() async {
    List<CommunityInfo> mycommunities = [];

    var db = FirebaseFirestore.instance;
    await db.collection("Communities").get().then((QuerySnapshot querySnapshot) {
      print("Successfully retrieved");

      for (var documents in querySnapshot.docs) {
        CommunityInfo comm = CommunityInfo();
        comm.ID = documents.id;
        comm.name = documents.get("Name");
        comm.description = documents.get("Description");
        comm.slogan = documents.get("Slogan");
        comm.imageUrlPath = documents.get("Image_Path");

        mycommunities.add(comm);
      }
    });

    return mycommunities;
  }
  Future<List<CommunityInfo>> getUpdates() async {
    List<CommunityInfo> myupdates = [];

    var db = FirebaseFirestore.instance;
    await db.collection("Updates_Information").get().then((QuerySnapshot querySnapshot) {
      print("Successfully retrieved");

      for (var documents in querySnapshot.docs) {
        CommunityInfo comm = CommunityInfo();
        comm.ID = documents.id;
        comm.name = documents.get("Name");
        comm.description = documents.get("Description");
        myupdates.add(comm);
      }
    });

    return myupdates;
  }
void _showFullStory(String communityName) {
  print('Community Name: $communityName'); // Debugging: Print community name
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Full Story'),
        content: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('Communities').where('Name', isEqualTo: communityName).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var communityData = snapshot.data!.docs.first.data() as Map<String, dynamic>?; // Explicit cast
              print('Community Data: $communityData'); // Debugging: Print community data
              if (communityData != null && communityData['Full_Story'] != null) {
                print('Full Story Found: ${communityData['Full_Story']}'); // Debugging: Print full story
                return SingleChildScrollView(
                  child: Text(
                    communityData['Full_Story'] as String, // Cast to String
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              } else {
                return const Text('Full story not found.');
              }
            }
          },
        ),
        actions: <Widget>[
          TextButton(
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

}

class UpdateListItem extends StatelessWidget {
  final String title;
  final String description;

  const UpdateListItem({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      // Add other UI elements for the update as needed
    );
  }
}
