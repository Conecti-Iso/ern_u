import 'package:ern_u/home_page/update_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ern_u/constants/app_colors.dart';
import 'package:ern_u/constants/custom_search.dart';
import 'package:ern_u/constants/image_path.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _userName = '';
  String _userRole = '';
  String? _userImageUrl;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = searchController.text;
      print("Search query updated: $_searchQuery"); // Debug print
    });
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['firstName'] + ' ' + userDoc['lastName'];
          _userRole = userDoc['role'] ?? 'User';
          _userImageUrl = userDoc['profileImageUrl'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 230,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
              decoration: BoxDecoration(
                color: AppColor.kPrimary,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProfileSection(),
                  SearchInput(
                    textController: searchController,
                    hintText: 'search', onChange: (value ) {
                      setState(() {
                        _searchQuery = value;
                        print("Search query updated from onChanged: $_searchQuery");
                      });
                  },
                  ),
                ],
              ),
                              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(15),
            sliver: SliverToBoxAdapter(
              child: _buildStatisticsRow(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(child: Center(child: Text('Error: ${snapshot.error}')));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SliverToBoxAdapter(child: Center(child: Text('No administrators found')));
                }

                List<DocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
                  final userData = doc.data() as Map<String, dynamic>;
                  final fullName = '${userData['firstName']} ${userData['lastName']} '.toLowerCase();
                  // return fullName.contains(_searchQuery.toLowerCase());
                  return _searchQuery.isEmpty || fullName.contains(_searchQuery.toLowerCase());
                }).toList();

                // Check if there are no matching search results
                if (filteredDocs.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.visibility_off,color: Colors.grey,),
                          Text(
                            'No search found for this result',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }



                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => InkWell(
                          onTap: () => Get.to(UserDetailPage(userId: filteredDocs[index].id)),
                            child: _buildUserCard(filteredDocs[index])),
                    childCount: filteredDocs.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: _userImageUrl != null
                ? NetworkImage(_userImageUrl!)
                : AssetImage(ImagesPath.kProfileImage) as ImageProvider,
            radius: 40,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, $_userName",
                style: GoogleFonts.acme(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColor.kWhite,
                ),
              ),
              Text(
                _userRole,
                style: GoogleFonts.acme(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColor.kWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsRow() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
        return Row(
          children: [
            Text(
              "$count Administrators",
              style: GoogleFonts.actor(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColor.kPrimary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text("see all"),
            ),
          ],
        );
      },
    );
  }


  Widget _buildUserCard(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 120,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              data['profileImageUrl'] ?? ImagesPath.kProfileImage,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(data['role'] ?? 'N/A'),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${data['firstName']} ${data['lastName']}',
                    style: GoogleFonts.actor(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Staff ID: ",
                        style: GoogleFonts.actor(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        data['staffID'] ?? 'N/A',
                        style: GoogleFonts.actor(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}