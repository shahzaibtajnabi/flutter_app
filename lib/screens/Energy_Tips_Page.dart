import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';

class EnergyConservationPage extends StatefulWidget {
  const EnergyConservationPage({super.key});

  @override
  State<EnergyConservationPage> createState() => _EnergyConservationPageState();
}

class _EnergyConservationPageState extends State<EnergyConservationPage>
    with TickerProviderStateMixin {
  bool isDarkMode = false;
  double usageLevel = 50; // user energy usage %
  double energySaved = 20; // demo progress

  late VideoPlayerController _videoController;
  bool videoReady = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> generalTips = [
    {
      "icon": Icons.lightbulb_outline,
      "title": "Switch to LED Bulbs",
      "desc": "LED bulbs consume up to 80% less energy.",
    },
    {
      "icon": Icons.power_off,
      "title": "Unplug Idle Devices",
      "desc": "Avoid phantom energy loss from plugged devices.",
    },
    {
      "icon": Icons.ac_unit,
      "title": "Efficient Cooling",
      "desc": "Set AC temperature to 24–26°C for savings.",
    },
    {
      "icon": Icons.wb_sunny,
      "title": "Use Natural Light",
      "desc": "Reduce daytime electricity usage.",
    },
  ];

  String getPersonalTip() {
    if (usageLevel < 30) {
      return "🌱 Excellent! Your energy usage is already efficient.";
    } else if (usageLevel < 70) {
      return "⚡ Moderate usage. Consider reducing AC & heater use.";
    } else {
      return "🚨 High usage detected! Switch off unused appliances immediately.";
    }
  }

  @override
  void initState() {
    super.initState();
    _initVideo();

    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  Future<void> _initVideo() async {
    _videoController = VideoPlayerController.asset(
      'assets/videos/nature_background.mp4',
    );
    await _videoController.initialize();
    _videoController
      ..setLooping(true)
      ..setVolume(0)
      ..play();
    setState(() => videoReady = true);
  }

  @override
  void dispose() {
    _videoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!videoReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          /// 🎥 Background Video
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

          /// 🌈 Gradient Overlay
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

          /// 🌟 Content
          FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  /// ✅ Modern Sliver AppBar
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    pinned: false,
                    floating: true,
                    snap: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: const Text(
                      "Energy Conservation",
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
                          isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () =>
                            setState(() => isDarkMode = !isDarkMode),
                      ),
                    ],
                  ),

                  /// ⚡ Personalized Energy Usage Card
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _glassCard(
                          child: Column(
                            children: [
                              Text("Your Energy Usage", style: _titleStyle()),
                              const SizedBox(height: 10),
                              Slider(
                                value: usageLevel,
                                min: 0,
                                max: 100,
                                divisions: 10,
                                label: "${usageLevel.toInt()}%",
                                activeColor: Colors.green.shade700,
                                onChanged: (v) =>
                                    setState(() => usageLevel = v),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                getPersonalTip(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 📊 Energy Saved Progress
                        _glassCard(
                          child: Column(
                            children: [
                              Text("Energy Saved", style: _titleStyle()),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: min(energySaved / 100, 1),
                                  valueColor:
                                  const AlwaysStoppedAnimation(Colors.green),
                                  backgroundColor: Colors.grey.shade300,
                                  minHeight: 10,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${energySaved.toInt()}% energy saved this month",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        /// 💡 General Tips Header
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "General Energy Saving Tips",
                            style: _titleStyle(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 💡 Tips List
                        ...generalTips.map((tip) => _tipCard(tip)),
                        const SizedBox(height: 30),
                      ]),
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

  /// 🔹 Glass Card
  Widget _glassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
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
        ],
      ),
      child: child,
    );
  }

  /// 💡 Tip Card
  Widget _tipCard(Map<String, dynamic> tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey.shade800, Colors.grey.shade700]
              : [Colors.white, Colors.green.shade50],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.green.withOpacity(0.2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade600,
            child: Icon(tip["icon"], color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tip["title"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(tip["desc"], style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _titleStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.white : Colors.green.shade800,
      fontFamily: 'Poppins',
    );
  }
}
