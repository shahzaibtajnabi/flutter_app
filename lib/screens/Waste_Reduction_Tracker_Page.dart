import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:video_player/video_player.dart';

class WasteTrackerPage extends StatefulWidget {
  const WasteTrackerPage({super.key});

  @override
  State<WasteTrackerPage> createState() => _WasteTrackerPageState();
}

class _WasteTrackerPageState extends State<WasteTrackerPage> {
  late VideoPlayerController _videoController;

  final recyclingCtrl = TextEditingController();
  final compostCtrl = TextEditingController();
  final plasticCtrl = TextEditingController();

  double recycling = 0;
  double compost = 0;
  double plastic = 0;

  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      "assets/videos/nature_background.mp4",
    )..initialize().then((_) {
      _videoController
        ..setLooping(true)
        ..setVolume(0)
        ..play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 🌿 Background Video
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

          /// Dark / Light overlay
          Container(
            color: isDarkMode
                ? Colors.black.withOpacity(0.45)
                : Colors.white.withOpacity(0.15),
          ),

          /// Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// 🔙 Custom AppBar (Carbon style)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [Colors.grey.shade900, Colors.black]
                            : [Colors.green.shade600, Colors.green.shade800],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            "Waste Reduction Tracker",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isDarkMode
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() => isDarkMode = !isDarkMode);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// 📝 Input Card
                  _glassCard(
                    title: "Weekly Waste Input",
                    child: Column(
                      children: [
                        _input("Recycling (kg/week)", recyclingCtrl),
                        _input("Composting (kg/week)", compostCtrl),
                        _input("Plastic Reduction (count/week)", plasticCtrl),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              recycling =
                                  double.tryParse(recyclingCtrl.text) ?? 0;
                              compost =
                                  double.tryParse(compostCtrl.text) ?? 0;
                              plastic =
                                  double.tryParse(plasticCtrl.text) ?? 0;
                            });
                          },
                          icon: const Icon(Icons.analytics),
                          label: const Text("Update Data"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// 📊 Chart
                  _glassCard(
                    title: "Waste Reduction Overview",
                    child: SizedBox(
                      height: 220,
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles:
                              SideTitles(showTitles: true),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, _) {
                                  switch (v.toInt()) {
                                    case 0:
                                      return const Text("Recycle");
                                    case 1:
                                      return const Text("Compost");
                                    case 2:
                                      return const Text("Plastic");
                                  }
                                  return const Text("");
                                },
                              ),
                            ),
                          ),
                          barGroups: [
                            _bar(0, recycling),
                            _bar(1, compost),
                            _bar(2, plastic),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// 💡 Tips
                  _glassCard(
                    title: "Tips to Improve",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _Tip("♻️ Segregate waste daily"),
                        _Tip("🌱 Compost kitchen waste"),
                        _Tip("🛍️ Use reusable items"),
                        _Tip("🚯 Avoid single-use plastic"),
                      ],
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
  Widget _glassCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
            Colors.grey.shade800.withOpacity(0.9),
            Colors.grey.shade700.withOpacity(0.9)
          ]
              : [
            Colors.white.withOpacity(0.85),
            Colors.green.shade50.withOpacity(0.85)
          ],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                  isDarkMode ? Colors.white : Colors.green.shade800)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor:
          isDarkMode ? Colors.black54 : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: max(y, 0),
          width: 26,
          borderRadius: BorderRadius.circular(8),
          color: Colors.green,
        )
      ],
    );
  }
}

class _Tip extends StatelessWidget {
  final String text;
  const _Tip(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(fontSize: 15)),
    );
  }
}
