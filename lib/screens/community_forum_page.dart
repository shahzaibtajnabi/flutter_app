import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CommunityForumPage extends StatefulWidget {
  const CommunityForumPage({super.key});

  @override
  State<CommunityForumPage> createState() => _CommunityForumPageState();
}

class _CommunityForumPageState extends State<CommunityForumPage>
    with TickerProviderStateMixin {
  String selectedCategory = "All";
  bool isDarkMode = false;

  late VideoPlayerController _videoController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool videoReady = false;

  final List<Map<String, dynamic>> posts = [
    {
      "username": "Ali Khan",
      "profilePic": "assets/images/profiles/user1.png",
      "category": "Tips",
      "content": "Use reusable bags instead of plastic ones!",
      "likes": 5,
      "comments": 2,
    },
    {
      "username": "Sara Ahmed",
      "profilePic": "assets/images/profiles/user2.png",
      "category": "Questions",
      "content": "How can I start composting at home?",
      "likes": 3,
      "comments": 4,
    },
    {
      "username": "John Doe",
      "profilePic": "assets/images/profiles/user3.png",
      "category": "Success Stories",
      "content": "I reduced my household waste by 30% this month!",
      "likes": 10,
      "comments": 5,
    },
  ];

  List<Map<String, dynamic>> get filteredPosts {
    return posts.where((post) {
      return selectedCategory == "All" || post["category"] == selectedCategory;
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    _videoController =
    VideoPlayerController.asset('assets/videos/nature_background.mp4')
      ..initialize().then((_) {
        setState(() => videoReady = true);
        _videoController
          ..setLooping(true)
          ..setVolume(0)
          ..play();
      });

    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add_comment, color: Colors.white),
      ),
      body: Stack(
        children: [
          /// 🌿 Background Video
          if (videoReady)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),

          /// Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.black.withOpacity(0.6), Colors.transparent]
                    : [Colors.white.withOpacity(0.2), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// Fade-in content
          FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Modern AppBar
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    pinned: false,
                    floating: true,
                    snap: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: const Text(
                      "Community Forum",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(
                          isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => setState(() => isDarkMode = !isDarkMode),
                      ),
                    ],
                  ),

                  /// Category Chips
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Wrap(
                        spacing: 8,
                        children: ["All", "Tips", "Questions", "Success Stories"]
                            .map((cat) => ChoiceChip(
                          label: Text(cat),
                          selected: selectedCategory == cat,
                          selectedColor: Colors.green.shade700,
                          backgroundColor:
                          isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                          labelStyle: TextStyle(
                            color: selectedCategory == cat
                                ? Colors.white
                                : (isDarkMode ? Colors.white : Colors.black),
                          ),
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = cat;
                            });
                          },
                        ))
                            .toList(),
                      ),
                    ),
                  ),

                  /// Posts List
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final post = filteredPosts[index];
                          return _glassPostCard(post);
                        },
                        childCount: filteredPosts.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Glass-style Post Card (same as CarbonPage style)
  Widget _glassPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey.shade800.withOpacity(0.9), Colors.grey.shade700.withOpacity(0.9)]
              : [Colors.white.withOpacity(0.95), Colors.green.shade50.withOpacity(0.9)],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            blurRadius: 10,
            color: Colors.white.withOpacity(0.1),
            offset: const Offset(-5, -5),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade600 : Colors.green.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(post["profilePic"]),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Text(
                post["username"],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.green.shade800,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  post["category"],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post["content"],
            style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    post["likes"]++;
                  });
                },
                child: Row(
                  children: [
                    const Icon(Icons.thumb_up, color: Colors.green),
                    const SizedBox(width: 4),
                    Text("${post["likes"]}"),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const Icon(Icons.comment, color: Colors.blueGrey),
                  const SizedBox(width: 4),
                  Text("${post["comments"]}"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
