// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:ern_u/home_page/update_admin.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ern_u/constants/app_colors.dart';
// import 'package:ern_u/constants/custom_search.dart';
// import 'package:ern_u/constants/image_path.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final searchController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   String _userName = '';
//   String _userRole = '';
//   String _userImageUrl = '';
//   String _searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     searchController.addListener(_onSearchChanged);
//   }
//
//   @override
//   void dispose() {
//     searchController.removeListener(_onSearchChanged);
//     searchController.dispose();
//     super.dispose();
//   }
//
//   void _onSearchChanged() {
//     setState(() {
//       _searchQuery = searchController.text;
//     });
//   }
//
//   Future<void> _loadUserData() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       DocumentSnapshot userDoc = await
//       _firestore.collection('users').doc(user.uid).get();
//       if (userDoc.exists) {
//         setState(() {
//           _userName = userDoc['firstName'] + ' ' + userDoc['lastName'];
//           _userRole = userDoc['role'] ?? 'User';
//           _userImageUrl = userDoc['profileImageUrl'] ?? '';
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEEEEEE),
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             automaticallyImplyLeading: false,
//             expandedHeight: 230,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//               decoration: BoxDecoration(
//                 color: AppColor.kPrimary,
//                 borderRadius: const BorderRadius.only(
//                   bottomRight: Radius.circular(20),
//                   bottomLeft: Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildProfileSection(),
//                   SearchInput(
//                     textController: searchController,
//                     hintText: 'search', onChange: (value ) {
//                       setState(() {
//                         _searchQuery = value;
//                       });
//                   },
//                   ),
//                 ],
//               ),
//               ),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.all(15),
//             sliver: SliverToBoxAdapter(
//               child: _buildStatisticsRow(),
//             ),
//           ),
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             sliver: StreamBuilder<QuerySnapshot>(
//               stream: _firestore.collection('users').snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
//                 }
//                 if (snapshot.hasError) {
//                   return SliverToBoxAdapter(child: Center(child: Text('Error: ${snapshot.error}')));
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const SliverToBoxAdapter(child: Center(child: Text('No administrators found')));
//                 }
//
//                 List<DocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
//                   final userData = doc.data() as Map<String, dynamic>;
//                   final fullName = '${userData['firstName']} ${userData['lastName']} '.toLowerCase();
//                   return _searchQuery.isEmpty || fullName.contains(_searchQuery.toLowerCase());
//                 }).toList();
//                 if (filteredDocs.isEmpty) {
//                   return const SliverToBoxAdapter(
//                     child: Center(
//                       child: Column(
//                         children: [
//                           Icon(Icons.visibility_off,color: Colors.grey,),
//                           Text(
//                             'No search found for this result',
//                             style: TextStyle(fontSize: 16, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//                 return SliverList( //-----------------------------------------------
//                   delegate: SliverChildBuilderDelegate(
//                         (context, index) => InkWell(
//                           onTap: () => Get.to(UserDetailPage(userId: filteredDocs[index].id)),
//                             child: _buildUserCard(filteredDocs[index])),
//                     childCount: filteredDocs.length,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//   Widget _buildProfileSection() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
//       child: Row(
//         children: [
//
//           ClipOval(
//             child: CachedNetworkImage(
//               imageUrl: _userImageUrl,
//               fit: BoxFit.cover,
//               width: 80,
//               height: 80,
//               placeholder: (context, url) => const CircularProgressIndicator(),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//             ),
//           ),
//
//
//           const SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Hi, $_userName",
//                 style: GoogleFonts.acme(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                   color: AppColor.kWhite,
//                 ),
//               ),
//               Text(
//                 _userRole,
//                 style: GoogleFonts.acme(
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                   color: AppColor.kWhite,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatisticsRow() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection('users').snapshots(),
//       builder: (context, snapshot) {
//         int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
//         return Row(
//           children: [
//             Text(
//               "$count Administrators",
//               style: GoogleFonts.actor(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 color: AppColor.kPrimary,
//               ),
//             ),
//             const Spacer(),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Text("see all"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//
//   Widget _buildUserCard(DocumentSnapshot document) {
//     Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white70,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       height: 120,
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child:
//             CachedNetworkImage(
//               imageUrl:data['profileImageUrl'] ?? ImagesPath.kProfileImage,
//               fit: BoxFit.cover,
//               width: 100,  // Set width/height as per your requirement
//               height: 100,
//               placeholder: (context, url) => const CircularProgressIndicator(),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFEEEEEE),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(data['role'] ?? 'N/A'),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     '${data['firstName']} ${data['lastName']}',
//                     style: GoogleFonts.actor(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         "Staff ID: ",
//                         style: GoogleFonts.actor(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       Text(
//                         data['staffID'] ?? 'N/A',
//                         style: GoogleFonts.actor(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'update_admin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _userName = '';
  String _userRole = '';
  String _userImageUrl = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    searchController.addListener(() {
      setState(() => _searchQuery = searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userName = '${userDoc['firstName']} ${userDoc['lastName']}';
          _userRole = userDoc['role'] ?? 'User';
          _userImageUrl = userDoc['profileImageUrl'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildStatistics(),
          _buildUsersList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 210,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: CirclePatternPainter(),
                ),
              ),
            ),
            // Profile and search content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfile(),
                  const SizedBox(height: 30),
                  _buildSearchBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: _userImageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.error, size: 40, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back,",
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                _userName,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _userRole,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search administrators...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverToBoxAdapter(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Administrators',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        count.toString(),
                        style: GoogleFonts.poppins(
                          color: Theme.of(context).primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.group,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return SliverFillRemaining(
              child: Center(child: Text('Error: ${snapshot.error}')),
            );
          }

          final filteredDocs = snapshot.data?.docs.where((doc) {
            final userData = doc.data() as Map<String, dynamic>;
            final fullName = '${userData['firstName']} ${userData['lastName']}'.toLowerCase();
            return _searchQuery.isEmpty || fullName.contains(_searchQuery.toLowerCase());
          }).toList() ?? [];

          if (filteredDocs.isEmpty) {
            return SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No administrators found',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildUserCard(filteredDocs[index]),
              childCount: filteredDocs.length,
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserCard(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Get.to(() => UserDetailPage(userId: document.id)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Hero(
                  tag: 'profile-${document.id}',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: data['profileImageUrl'] ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data['firstName']} ${data['lastName']}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          data['role'] ?? 'N/A',
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Staff ID: ${data['staffID'] ?? 'N/A'}',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for background pattern
class CirclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final radius = size.width * 0.1;
    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 5; j++) {
        final offset = Offset(
          i * size.width / 2,
          j * size.height / 2,
        );
        canvas.drawCircle(offset, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}