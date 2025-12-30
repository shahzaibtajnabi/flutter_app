import 'package:flutter/material.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  bool isDarkMode = false;

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
  Widget build(BuildContext context) {
    int completed =
        challenges.where((c) => c["status"] == "completed").length;
    double progress = completed / challenges.length;

    return Scaffold(
      backgroundColor:
      isDarkMode ? Colors.grey.shade900 : const Color(0xFFF1F8F3),
      appBar: AppBar(
        title: const Text("Sustainability Challenges"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.grey.shade800, Colors.black]
                  : [Colors.green.shade600, Colors.green.shade800],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              setState(() => isDarkMode = !isDarkMode);
            },
          ),
        ],
      ),

      body: Column(
        children: [
          /// 🔹 Progress Overview
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Colors.grey.shade800, Colors.grey.shade700]
                      : [Colors.green.shade100, Colors.green.shade200],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Your Progress",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                    const AlwaysStoppedAnimation(Colors.green),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$completed / ${challenges.length} Challenges Completed",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          /// 🔹 Challenge List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                final isCompleted = challenge["status"] == "completed";

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor:
                              Colors.green.shade100,
                              child: Icon(
                                challenge["icon"],
                                color: Colors.green.shade700,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                challenge["title"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.green.shade800,
                                ),
                              ),
                            ),
                            Icon(
                              isCompleted
                                  ? Icons.check_circle
                                  : Icons.hourglass_bottom,
                              color: isCompleted
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          challenge["desc"],
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// 🔘 Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  challenge["status"] = "pending";
                                });
                              },
                              child: const Text("Decline"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  challenge["status"] = "completed";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isCompleted
                                    ? Colors.grey
                                    : Colors.green.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                isCompleted
                                    ? "Completed"
                                    : "Accept",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
