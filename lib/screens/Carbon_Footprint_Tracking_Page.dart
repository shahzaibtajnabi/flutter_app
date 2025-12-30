import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:video_player/video_player.dart'; // Add this dependency in pubspec.yaml: video_player: ^2.6.1
import 'dart:math';

class CarbonTrackerPage extends StatefulWidget {
  const CarbonTrackerPage({super.key});

  @override
  State<CarbonTrackerPage> createState() => _CarbonTrackerPageState();
}

class _CarbonTrackerPageState extends State<CarbonTrackerPage>
    with SingleTickerProviderStateMixin {
  // Form values
  double transportation = 10;
  double energy = 15;
  double food = 20;
  double waste = 5;

  double totalCarbon = 0;

  final _formKey = GlobalKey<FormState>();

  // Animation Controller for total carbon number
  late AnimationController _controller;
  late Animation<double> _animation;

  // New additions: Progress towards goal, tips list, and toggle for dark mode
  double carbonGoal = 50; // User-set goal
  bool isDarkMode = false;
  List<String> ecoTips = [
    "Use public transport or bike instead of driving.",
    "Switch to LED bulbs and unplug devices when not in use.",
    "Reduce meat consumption and eat more plant-based foods.",
    "Recycle and compost to minimize waste.",
    "Plant trees or support reforestation projects.",
  ];

  // Background Video Controller
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    totalCarbon = transportation + energy + food + waste;

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: totalCarbon).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();

    // Initialize background video
    _videoController = VideoPlayerController.asset(
      'assets/videos/nature_background.mp4',
    )..initialize().then((_) {
      setState(() {});
      _videoController.setLooping(true);
      _videoController.setVolume(0); // Mute for background
      _videoController.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void calculateCarbon() {
    setState(() {
      totalCarbon = transportation + energy + food + waste;
      _animation = Tween<double>(begin: _animation.value, end: totalCarbon).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Video
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
          // Overlay for better text readability (semi-transparent)
          Container(
            color: (isDarkMode ? Colors.black : Colors.white).withOpacity(0.1),
          ),
          // Main UI Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // AppBar-like Header (since Scaffold appBar is removed for full background)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [Colors.grey.shade800.withOpacity(0.8), Colors.grey.shade900.withOpacity(0.8)]
                          : [Colors.green.shade600.withOpacity(0.8), Colors.green.shade800.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Carbon Footprint Tracker",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            isDarkMode = !isDarkMode;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Goal Setting Card (New Addition)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [Colors.grey.shade800.withOpacity(0.9), Colors.grey.shade700.withOpacity(0.9)]
                          : [Colors.white.withOpacity(0.9), Colors.green.shade50.withOpacity(0.9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDarkMode ? Colors.grey.shade600 : Colors.green.shade200).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        "Set Your Carbon Goal",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.green.shade800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.green.shade700,
                          inactiveTrackColor: Colors.green.shade200,
                          thumbColor: Colors.green.shade800,
                          overlayColor: Colors.green.shade700.withOpacity(0.2),
                          valueIndicatorColor: Colors.green.shade700,
                          valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                        ),
                        child: Slider(
                          value: carbonGoal,
                          min: 0,
                          max: 200,
                          divisions: 20,
                          label: carbonGoal.toStringAsFixed(0),
                          onChanged: (val) {
                            setState(() {
                              carbonGoal = val;
                            });
                          },
                        ),
                      ),
                      Text(
                        "Goal: ${carbonGoal.toStringAsFixed(0)} kg CO₂",
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white70 : Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Sliders Card with Modern Design
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [Colors.grey.shade800.withOpacity(0.9), Colors.grey.shade700.withOpacity(0.9)]
                          : [Colors.white.withOpacity(0.9), Colors.green.shade50.withOpacity(0.9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDarkMode ? Colors.grey.shade600 : Colors.green.shade200).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        "Adjust Your Inputs",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildSlider(
                        "Transportation (kg CO₂)",
                        transportation,
                        0,
                        50,
                        Icons.directions_car,
                            (val) => transportation = val,
                      ),
                      buildSlider(
                        "Energy Usage (kg CO₂)",
                        energy,
                        0,
                        50,
                        Icons.electric_bolt,
                            (val) => energy = val,
                      ),
                      buildSlider(
                        "Food Habits (kg CO₂)",
                        food,
                        0,
                        50,
                        Icons.restaurant,
                            (val) => food = val,
                      ),
                      buildSlider(
                        "Waste Generated (kg)",
                        waste,
                        0,
                        50,
                        Icons.delete,
                            (val) => waste = val,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: calculateCarbon,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: Colors.green.shade300,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calculate, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Calculate Footprint",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Animated Total Carbon Card with Modern Design
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: isDarkMode
                              ? [Colors.grey.shade800.withOpacity(0.9), Colors.grey.shade700.withOpacity(0.9)]
                              : [Colors.green.shade100.withOpacity(0.9), Colors.green.shade200.withOpacity(0.9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isDarkMode ? Colors.grey.shade600 : Colors.green.shade300).withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.eco,
                            size: 40,
                            color: isDarkMode ? Colors.green.shade300 : Colors.green,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Total Carbon Footprint",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.green.shade800,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "${_animation.value.toStringAsFixed(1)} kg CO₂",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.green.shade900,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Progress Bar towards Goal (New Addition)
                          LinearProgressIndicator(
                            value: min(totalCarbon / carbonGoal, 1.0),
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              totalCarbon <= carbonGoal ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            totalCarbon <= carbonGoal
                                ? "On track! ${((1 - totalCarbon / carbonGoal) * 100).toStringAsFixed(0)}% below goal."
                                : "Over goal by ${(totalCarbon - carbonGoal).toStringAsFixed(1)} kg CO₂.",
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white70 : Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            height: 220,
                            child: PieChart(
                              PieChartData(
                                sections: getPieSections(),
                                sectionsSpace: 6,
                                centerSpaceRadius: 60,
                                borderData: FlBorderData(show: false),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.grey.shade800.withOpacity(0.8) : Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              getSuggestion(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: isDarkMode ? Colors.white : Colors.green.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Eco Tips Card (New Addition)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [Colors.grey.shade800.withOpacity(0.9), Colors.grey.shade700.withOpacity(0.9)]
                          : [Colors.white.withOpacity(0.9), Colors.green.shade50.withOpacity(0.9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDarkMode ? Colors.grey.shade600 : Colors.green.shade200).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        "Eco-Friendly Tips",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.green.shade800,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ...ecoTips.map((tip) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: Colors.yellow.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                tip,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode ? Colors.white70 : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Modern Slider Widget with Icon
  Widget buildSlider(
      String label,
      double value,
      double min,
      double max,
      IconData icon,
      Function(double) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: isDarkMode ? Colors.green.shade300 : Colors.green.shade700, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.green.shade700,
            inactiveTrackColor: Colors.green.shade200,
            thumbColor: Colors.green.shade800,
            overlayColor: Colors.green.shade700.withOpacity(0.2),
            valueIndicatorColor: Colors.green.shade700,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: 10,
            label: value.toStringAsFixed(1),
            onChanged: (val) {
              setState(() {
                onChanged(val);
              });
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Pie chart sections with improved styling
  List<PieChartSectionData> getPieSections() {
    final colors = [
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.blue.shade400,
      Colors.red.shade400,
    ];

    final values = [transportation, energy, food, waste];
    final labels = ["Transport", "Energy", "Food", "Waste"];

    return List.generate(4, (i) {
      final isTouched = false; // You can add touch interaction if needed
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        value: values[i],
        color: colors[i],
        title: "${labels[i]}\n${values[i].toStringAsFixed(1)}",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  // Enhanced Suggestions
  String getSuggestion() {
    if (totalCarbon < 50) {
      return "🌱 Excellent! Your carbon footprint is low. Keep up the great work by sharing tips with friends!";
    } else if (totalCarbon < 100) {
      return "🚲 Moderate footprint. Consider using public transport, biking, or reducing meat consumption to lower it further.";
    } else {
      return "⚡ High footprint! Time to adopt eco-friendly habits like saving energy, recycling, and choosing sustainable options.";
    }
  }
}