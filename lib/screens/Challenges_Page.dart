import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:video_player/video_player.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage>
    with TickerProviderStateMixin {
  bool isDarkMode = false;

  late VideoPlayerController _videoController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool videoReady = false;

  final List<Map<String, dynamic>> challenges = [
    {
      "title": "Plastic-Free Week",
      "desc": "Avoid all single-use plastic for 7 days.",
      "icon": Icons.recycling,
      "status": "pending",
    },
    {
      "title": "No Car Day",
      "desc": "Use bike, walk or public transport today.",
      "icon": Icons.directions_bike,
      "status": "pending",
    },
    {
      "title": "Save Electricity",
      "desc": "Reduce electricity usage for 3 days.",
      "icon": Icons.lightbulb_outline,
      "status": "pending",
    },
    {
      "title": "Plant a Tree",
      "desc": "Plant or sponsor at least one tree.",
      "icon": Icons.park,
      "status": "pending",
    },
  ];

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/nature_background.mp4')
      ..initialize().then((_) {
        setState(() => videoReady = true);
        _videoController
          ..setLooping(true)
          ..setVolume(0)
          ..play();
      });

    _fadeController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
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
    int completed = challenges.where((c) => c["status"] == "completed").length;
    int pending = challenges.length - completed;
    double progress = completed / challenges.length;

    return Scaffold(
      body: Stack(
        children: [
          /// 🎥 Background Video with Blur
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
            )
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode ? [Colors.black, Colors.grey.shade900] : [Colors.green.shade100, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

          /// Modern Overlay with Gradient
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

          /// Content with Fade Animation
          FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Modern AppBar Sliver
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
                      "Sustainability Challenges",
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

                  // Progress Overview Sliver with Pie Chart
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverToBoxAdapter(
                      child: _glassCard(
                        title: "Your Progress",
                        child: Column(
                          children: [
                            Text(
                              "Challenge Completion",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.green.shade800,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 12,
                                backgroundColor: Colors.grey.shade300,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "$completed / ${challenges.length} Challenges Completed",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white70 : Colors.green.shade700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: _pieSections(completed, pending),
                                  centerSpaceRadius: 60,
                                  sectionsSpace: 8,
                                  borderData: FlBorderData(show: false),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _suggestion(completed, challenges.length),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white70 : Colors.green.shade700,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Challenge List Sliver
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final challenge = challenges[index];
                          final isCompleted = challenge["status"] == "completed";
                          return ChallengeCard(
                            challenge: challenge,
                            isDarkMode: isDarkMode,
                            onAccept: () => setState(() => challenge["status"] = "completed"),
                            onDecline: () => setState(() => challenge["status"] = "pending"),
                          );
                        },
                        childCount: challenges.length,
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

  List<PieChartSectionData> _pieSections(int completed, int pending) {
    final values = [completed.toDouble(), pending.toDouble()];
    final colors = [Colors.green.shade400, Colors.orange.shade400];
    final labels = ["Completed", "Pending"];
    return List.generate(2, (i) {
      return PieChartSectionData(
        value: values[i],
        color: colors[i],
        radius: 60,
        title: "${values[i].toInt()}\n${labels[i]}",
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'Poppins',
        ),
        badgeWidget: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: colors[i],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
        badgePositionPercentageOffset: 1.1,
      );
    });
  }

  String _suggestion(int completed, int total) {
    if (completed == total) {
      return "🌟 Excellent! All challenges completed. Keep up the great work!";
    } else if (completed >= total / 2) {
      return "🚀 Good progress! Complete more to reach your goals.";
    } else {
      return "🌱 Start accepting challenges to improve your sustainability!";
    }
  }

  Widget _glassCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey.shade800.withOpacity(0.9), Colors.grey.shade700.withOpacity(0.9)]
              : [Colors.white.withOpacity(0.9), Colors.green.shade50.withOpacity(0.9)],
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
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// Modern Challenge Card with Animation
class ChallengeCard extends StatefulWidget {
  final Map<String, dynamic> challenge;
  final bool isDarkMode;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.isDarkMode,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.challenge["status"] == "completed";

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: widget.isDarkMode
                    ? [Colors.grey.shade800.withOpacity(0.9), Colors.grey.shade700.withOpacity(0.9)]
                    : [Colors.white.withOpacity(0.9), Colors.green.shade50.withOpacity(0.9)],
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.challenge["icon"],
                        color: Colors.green.shade700,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.challenge["title"],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.isDarkMode ? Colors.white : Colors.green.shade800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Icon(
                      isCompleted ? Icons.check_circle : Icons.hourglass_bottom,
                      color: isCompleted ? Colors.green.shade600 : Colors.orange.shade600,
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.challenge["desc"],
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: widget.onDecline,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Decline",
                        style: TextStyle(
                          color: widget.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: widget.onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCompleted ? Colors.grey.shade500 : Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        shadowColor: Colors.green.withOpacity(0.3),
                      ),
                      child: Text(
                        isCompleted ? "Completed" : "Accept",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}