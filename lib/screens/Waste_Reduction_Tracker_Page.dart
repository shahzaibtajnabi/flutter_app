import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:video_player/video_player.dart';

class WasteTrackerPage extends StatefulWidget {
  const WasteTrackerPage({super.key});

  @override
  State<WasteTrackerPage> createState() => _WasteTrackerPageState();
}

class _WasteTrackerPageState extends State<WasteTrackerPage>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoController;

  final recyclingCtrl = TextEditingController();
  final compostCtrl = TextEditingController();
  final plasticCtrl = TextEditingController();

  double recycling = 0;
  double compost = 0;
  double plastic = 0;

  bool isDarkMode = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    /// Video Background
    _videoController = VideoPlayerController.asset(
      "assets/videos/nature_background.mp4",
    )..initialize().then((_) {
      _videoController
        ..setLooping(true)
        ..setVolume(0)
        ..play();
      setState(() {});
    });

    /// Fade Animation
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _fadeController.dispose();
    recyclingCtrl.dispose();
    compostCtrl.dispose();
    plasticCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoController.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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

          /// 🌈 Gradient Overlay (Same as Carbon Page)
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
                      "Waste Reduction Tracker",
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

                  /// 📦 Page Content
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          /// 📝 Input Card
                          _glassCard(
                            title: "Weekly Waste Input",
                            child: Column(
                              children: [
                                _inputField(
                                    "Recycling (kg/week)", recyclingCtrl),
                                _inputField(
                                    "Composting (kg/week)", compostCtrl),
                                _inputField(
                                    "Plastic Reduction (count/week)",
                                    plasticCtrl),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        recycling = double.tryParse(
                                            recyclingCtrl.text) ??
                                            0;
                                        compost = double.tryParse(
                                            compostCtrl.text) ??
                                            0;
                                        plastic = double.tryParse(
                                            plasticCtrl.text) ??
                                            0;
                                      });
                                    },
                                    icon: const Icon(Icons.analytics,
                                        color: Colors.white),
                                    label: const Text(
                                      "Update Data",
                                      style:
                                      TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Colors.green.shade700,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25),
                                      ),
                                      elevation: 5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// 📊 Bar Chart Card
                          _glassCard(
                            title: "Waste Reduction Overview",
                            child: SizedBox(
                              height: 230,
                              child: BarChart(
                                BarChartData(
                                  borderData:
                                  FlBorderData(show: false),
                                  gridData:
                                  FlGridData(show: false),
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
                                              return const Text(
                                                  "Recycle");
                                            case 1:
                                              return const Text(
                                                  "Compost");
                                            case 2:
                                              return const Text(
                                                  "Plastic");
                                          }
                                          return const Text("");
                                        },
                                      ),
                                    ),
                                  ),
                                  barGroups: [
                                    _barGroup(0, recycling),
                                    _barGroup(1, compost),
                                    _barGroup(2, plastic),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// 💡 Tips Card
                          _glassCard(
                            title: "Tips to Improve",
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: const [
                                _Tip("♻️ Segregate waste daily"),
                                _Tip("🌱 Compost kitchen waste"),
                                _Tip("🛍️ Use reusable items"),
                                _Tip("🚯 Avoid single-use plastic"),
                              ],
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
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

  /// 💎 Glass Card
  Widget _glassCard({required String title, required Widget child}) {
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
        border:
        Border.all(color: Colors.white.withOpacity(0.2), width: 1),
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
              color:
              isDarkMode ? Colors.white : Colors.green.shade800,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  /// ✏️ Input Field
  Widget _inputField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isDarkMode ? Colors.black54 : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// 📊 Bar Chart Helper
  BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: max(y, 0),
          width: 28,
          borderRadius: BorderRadius.circular(8),
          color: Colors.green.shade600,
        ),
      ],
    );
  }
}

/// 💡 Tip Widget
class _Tip extends StatelessWidget {
  final String text;
  const _Tip(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
