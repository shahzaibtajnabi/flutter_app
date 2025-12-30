import 'package:flutter/material.dart';
import 'dart:math';

class EnergyConservationPage extends StatefulWidget {
  const EnergyConservationPage({super.key});

  @override
  State<EnergyConservationPage> createState() => _EnergyConservationPageState();
}

class _EnergyConservationPageState extends State<EnergyConservationPage> {
  bool isDarkMode = false;
  double usageLevel = 50; // user energy usage %
  double energySaved = 20; // demo progress

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      isDarkMode ? Colors.grey.shade900 : const Color(0xFFEAF6EA),
      body: SafeArea(
        child: Column(
          children: [

            /// 🔋 AppBar (Carbon style)
            Container(
              margin: const EdgeInsets.all(12),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Colors.grey.shade900, Colors.black]
                      : [Colors.green.shade600, Colors.green.shade800],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon:
                    const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      "Energy Conservation Tips",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    /// ⚙ Personalized Usage Card
                    _glassCard(
                      child: Column(
                        children: [
                          Text(
                            "Your Energy Usage",
                            style: _titleStyle(),
                          ),
                          const SizedBox(height: 10),
                          Slider(
                            value: usageLevel,
                            min: 0,
                            max: 100,
                            divisions: 10,
                            label: "${usageLevel.toInt()}%",
                            onChanged: (v) {
                              setState(() {
                                usageLevel = v;
                              });
                            },
                          ),
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
                          Text("Energy Saved",
                              style: _titleStyle()),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: min(energySaved / 100, 1),
                            valueColor:
                            const AlwaysStoppedAnimation(Colors.green),
                            backgroundColor: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${energySaved.toInt()}% energy saved this month",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// 💡 General Tips
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "General Energy Saving Tips",
                        style: _titleStyle(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...generalTips.map((tip) => _tipCard(tip)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔲 Glass Card
  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
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
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: Colors.black.withOpacity(0.25),
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
        color: isDarkMode
            ? Colors.grey.shade800
            : Colors.white,
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
                Text(
                  tip["title"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  tip["desc"],
                  style: const TextStyle(fontSize: 13),
                ),
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
    );
  }
}
