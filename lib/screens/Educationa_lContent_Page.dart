import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage>
    with TickerProviderStateMixin {
  bool isDarkMode = false;
  late VideoPlayerController _videoController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> educationTopics = [
    {
      "title": "Climate Change",
      "content":
      "Climate change refers to long-term shifts in temperatures and weather patterns, mainly caused by human activities.",
      "image": "assets/assets/images/educational_pic/climate.jpg",
    },
    {
      "title": "Renewable Energy",
      "content":
      "Renewable energy comes from natural sources like sunlight, wind, and water. Using it reduces carbon emissions.",
      "image": "assets/assets/images/educational_pic/energy.jpg",
    },
    {
      "title": "Sustainable Living",
      "content":
      "Sustainable living means reducing your ecological footprint by conserving resources and minimizing waste.",
      "image": "assets/assets/images/educational_pic/travel.jpg",
    },
    {
      "title": "Recycling & Waste Management",
      "content":
      "Proper recycling and composting help reduce landfill waste and lower carbon emissions.",
      "image": "assets/assets/images/educational_pic/recycling.jpg",
    },
    {
      "title": "Water Conservation",
      "content":
      "Using water efficiently helps preserve ecosystems and reduces the energy used in water treatment.",
      "image": "assets/assets/images/educational_pic/foot.jpg",
    },
  ];

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _fadeController.forward();

    // Video background
    _videoController =
    VideoPlayerController.asset("assets/videos/nature_background.mp4")
      ..initialize().then((_) {
        _videoController
          ..setLooping(true)
          ..setVolume(0)
          ..play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoController.value.isInitialized) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.black, Colors.grey.shade900]
                  : [Colors.green.shade100, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.green),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Video Background
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

          // Gradient Overlay
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

          // Fade-in content
          FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // AppBar
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    pinned: false,
                    floating: true,
                    snap: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: const Text(
                      "Educational Topics",
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
                        ),
                        onPressed: () =>
                            setState(() => isDarkMode = !isDarkMode),
                      ),
                    ],
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final topic = educationTopics[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _glassCard(
                              title: topic["title"]!,
                              image: topic["image"],
                              child: Text(
                                topic["content"]!,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.green.shade800,
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: educationTopics.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Glass card with optional image
  Widget _glassCard(
      {required String title, required Widget child, String? image}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            Colors.grey.shade800.withOpacity(0.9),
            Colors.grey.shade700.withOpacity(0.9)
          ]
              : [
            Colors.white.withOpacity(0.9),
            Colors.green.shade50.withOpacity(0.9)
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.green.shade800,
            ),
          ),
          if (image != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
