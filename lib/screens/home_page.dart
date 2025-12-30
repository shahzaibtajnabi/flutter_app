import 'package:flutter/material.dart';
import 'package:sustainable_living_app/screens/Carbon_Footprint_Tracking_Page.dart' show CarbonTrackerPage;
import 'package:sustainable_living_app/screens/Challenges_Page.dart';
import 'package:sustainable_living_app/screens/Eco_Travel_Page.dart';
import 'package:sustainable_living_app/screens/Educationa_lContent_Page.dart';
import 'package:sustainable_living_app/screens/Energy_Tips_Page.dart';
import 'package:sustainable_living_app/screens/Sustainable_Recipes_Page.dart';
import 'package:sustainable_living_app/screens/Waste_Reduction_Tracker_Page.dart';
import 'package:sustainable_living_app/screens/eco_products_page.dart' show EcoProductsPage;
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/nature_background.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Video
          SizedBox.expand(
            child: _controller.value.isInitialized
                ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
                : Container(color: Colors.black),
          ),

          // Overlay
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar style greeting
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Hi, User 👋",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Quick Stats
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        StatCard(title: "Carbon Today", value: "12kg"),
                        StatCard(title: "Waste Saved", value: "5kg"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Modules Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        DashboardCard(
                          title: "Carbon Tracker",
                          icon: Icons.cloud,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CarbonTrackerPage(),
                              ),
                            );
                          },
                        ),
                        DashboardCard(
                          title: "Eco Products",
                          icon: Icons.shopping_bag,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EcoProductsPage(),
                              ),
                            );
                          },

                        ),
                        DashboardCard(
                          title: "Challenges",
                          icon: Icons.flag,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChallengesPage(),
                              ),
                            );
                          },
                        ),
                        DashboardCard(
                          title: "Waste Tracker",
                          icon: Icons.delete,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WasteTrackerPage(),
                              ),
                            );
                          },

                        ),
                        DashboardCard(
                          title: "Recipes",
                          icon: Icons.restaurant,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SustainableRecipesPage(),
                              ),
                            );
                          },

                        ),
                        DashboardCard(
                          title: "Energy Tips",
                          icon: Icons.lightbulb,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EnergyConservationPage(),
                              ),
                            );
                          },

                        ),
                        DashboardCard(
                          title: "Eco Travel",
                          icon: Icons.directions_bus,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EcoTravelPage(),
                              ),
                            );
                          },

                        ),
                        DashboardCard(
                          title: "Education",
                          icon: Icons.menu_book,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EducationalContentPage(),
                              ),
                            );
                          },

                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Stat Card Widget
class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}

// Dashboard Card Widget with onTap callback
class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
              () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("$title clicked"),
                  backgroundColor: Colors.green.shade700),
            );
          },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 50, color: Colors.green.shade700),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
