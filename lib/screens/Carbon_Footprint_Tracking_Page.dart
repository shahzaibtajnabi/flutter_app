import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:video_player/video_player.dart';

class CarbonTrackerPage extends StatefulWidget {
  const CarbonTrackerPage({super.key});

  @override
  State<CarbonTrackerPage> createState() => _CarbonTrackerPageState();
}

class _CarbonTrackerPageState extends State<CarbonTrackerPage>
    with TickerProviderStateMixin {
  // Values
  double transportation = 10;
  double energy = 15;
  double food = 20;
  double waste = 5;

  double totalCarbon = 0;
  double carbonGoal = 50;
  bool isDarkMode = false;

  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late VideoPlayerController _videoController;

  final List<String> ecoTips = [
    "Use public transport or bike",
    "Switch to LED bulbs",
    "Eat more plant-based meals",
    "Recycle & compost waste",
    "Avoid single-use plastics",
  ];

  @override
  void initState() {
    super.initState();
    totalCarbon = transportation + energy + food + waste;

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: totalCarbon).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    _fadeController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _fadeController.forward();

    _videoController = VideoPlayerController.asset("assets/videos/nature_background.mp4")
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
    _controller.dispose();
    _fadeController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void calculateCarbon() {
    setState(() {
      totalCarbon = transportation + energy + food + waste;
      _animation = Tween<double>(
        begin: _animation.value,
        end: totalCarbon,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
      _controller.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoController.value.isInitialized) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode ? [Colors.black, Colors.grey.shade900] : [Colors.green.shade100, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Center(child: CircularProgressIndicator(color: Colors.green)),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          /// 🌿 Background Video with Blur
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
                      "Carbon Footprint Tracker",
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

                  // Content Slivers
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Set Carbon Goal Card
                        _glassCard(
                          title: "Set Carbon Goal",
                          child: Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.green.shade600,
                                  inactiveTrackColor: Colors.grey.shade300,
                                  thumbColor: Colors.green.shade700,
                                  overlayColor: Colors.green.withOpacity(0.2),
                                  valueIndicatorColor: Colors.green.shade700,
                                ),
                                child: Slider(
                                  value: carbonGoal,
                                  min: 0,
                                  max: 200,
                                  divisions: 20,
                                  label: carbonGoal.toStringAsFixed(0),
                                  onChanged: (v) => setState(() => carbonGoal = v),
                                ),
                              ),
                              Text(
                                "Goal: ${carbonGoal.toInt()} kg CO₂",
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.green.shade800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Adjust Inputs Card
                        _glassCard(
                          title: "Adjust Inputs",
                          child: Column(
                            children: [
                              _slider("Transportation", transportation, Icons.directions_car, (v) => transportation = v),
                              _slider("Energy Usage", energy, Icons.electric_bolt, (v) => energy = v),
                              _slider("Food Habits", food, Icons.restaurant, (v) => food = v),
                              _slider("Waste", waste, Icons.delete, (v) => waste = v),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: calculateCarbon,
                                icon: const Icon(Icons.calculate, color: Colors.white),
                                label: const Text("Calculate", style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 5,
                                  shadowColor: Colors.green.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Total Carbon Footprint Card with Animation
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (_, __) {
                            return _glassCard(
                              title: "Total Carbon Footprint",
                              child: Column(
                                children: [
                                  Text(
                                    "${_animation.value.toStringAsFixed(1)} kg CO₂",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.green.shade800,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: min(totalCarbon / carbonGoal, 1),
                                      backgroundColor: Colors.grey.shade300,
                                      color: totalCarbon <= carbonGoal ? Colors.green.shade600 : Colors.red.shade600,
                                      minHeight: 8,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 250,
                                    child: PieChart(
                                      PieChartData(
                                        sections: _pieSections(),
                                        centerSpaceRadius: 70,
                                        sectionsSpace: 8,
                                        borderData: FlBorderData(show: false),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      _suggestion(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // Eco Tips Card
                        _glassCard(
                          title: "Eco Tips",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: ecoTips
                                .map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.eco, color: Colors.green, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.green.shade800,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                                .toList(),
                          ),
                        ),
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

  Widget _slider(String label, double value, IconData icon, Function(double) onChanged) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.green.shade600, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.green.shade800,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.green.shade800,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.green.shade600,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Colors.green.shade700,
            overlayColor: Colors.green.withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 50,
            divisions: 10,
            onChanged: (v) => setState(() => onChanged(v)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  List<PieChartSectionData> _pieSections() {
    final values = [transportation, energy, food, waste];
    final colors = [Colors.green.shade400, Colors.orange.shade400, Colors.blue.shade400, Colors.red.shade400];
    final labels = ["Transport", "Energy", "Food", "Waste"];
    return List.generate(4, (i) {
      return PieChartSectionData(
        value: values[i],
        color: colors[i],
        radius: 60,
        title: "${values[i].toStringAsFixed(1)}\n${labels[i]}",
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

  String _suggestion() {
    if (totalCarbon < 50) {
      return "🌱 Excellent! Your footprint is low. Keep it up!";
    } else if (totalCarbon < 100) {
      return "🚲 Moderate footprint. Try reducing transport & meat consumption.";
    } else {
      return "⚡ High footprint! Adopt more eco-friendly habits to lower it.";
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