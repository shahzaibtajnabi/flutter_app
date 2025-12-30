import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// ------------------ EcoMapCard for Web ------------------
class EcoMapCard extends StatelessWidget {
  const EcoMapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            color: Colors.black.withOpacity(0.25),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(33.6844, 73.0479), // Islamabad, Pakistan
            zoom: 12,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.sustainable_living_app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(33.7000, 73.0500), // Example marker in Islamabad
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------ EcoTravelPage ------------------
class EcoTravelPage extends StatefulWidget {
  const EcoTravelPage({super.key});

  @override
  State<EcoTravelPage> createState() => _EcoTravelPageState();
}

class _EcoTravelPageState extends State<EcoTravelPage> {
  bool isDarkMode = false;

  final List<Map<String, dynamic>> travelOptions = [
    {
      "title": "Public Transport",
      "subtitle": "Metro, Bus, Train",
      "desc": "Reduces carbon emissions up to 60%",
      "icon": Icons.directions_bus,
      "badge": "Low Carbon",
      "color": Colors.green,
    },
    {
      "title": "Carpool",
      "subtitle": "Share rides",
      "desc": "Save fuel & money by sharing rides",
      "icon": Icons.people,
      "badge": "Eco Choice",
      "color": Colors.teal,
    },
    {
      "title": "Eco Hotels",
      "subtitle": "Green stays",
      "desc": "Solar powered & plastic-free hotels",
      "icon": Icons.hotel,
      "badge": "Sustainable",
      "color": Colors.orange,
    },
    {
      "title": "Cycling / Walking",
      "subtitle": "Zero emission",
      "desc": "Healthiest & greenest travel option",
      "icon": Icons.directions_bike,
      "badge": "Zero CO₂",
      "color": Colors.lightGreen,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey.shade900 : const Color(0xFFEAF6EA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Eco-Travel Guide",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.grey.shade800, Colors.grey.shade900]
                  : [Colors.green.shade600, Colors.green.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() => isDarkMode = !isDarkMode);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.grey.shade800, Colors.grey.shade700]
                    : [Colors.white, Colors.green.shade50],
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.black.withOpacity(0.2),
                )
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.eco,
                    size: 40,
                    color: isDarkMode ? Colors.greenAccent : Colors.green),
                const SizedBox(height: 10),
                Text(
                  "Travel Smart, Travel Green 🌍",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Choose eco-friendly travel options to reduce your carbon footprint.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          /// Eco Map Card
          const EcoMapCard(),

          const SizedBox(height: 20),

          /// Travel Cards
          ...travelOptions.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                    color: item["color"].withOpacity(0.3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: item["color"].withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item["icon"],
                      size: 32,
                      color: item["color"],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              item["title"],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: item["color"],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item["badge"],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item["subtitle"],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: item["color"],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item["desc"],
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          /// Tip Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.grey.shade800, Colors.grey.shade700]
                    : [Colors.green.shade100, Colors.green.shade200],
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.lightbulb, color: Colors.orange),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Tip: Combine walking, cycling & public transport for the lowest carbon travel.",
                    style: TextStyle(fontWeight: FontWeight.w600),
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

/// ------------------ Main App ------------------
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EcoTravelPage(),
  ));
}
