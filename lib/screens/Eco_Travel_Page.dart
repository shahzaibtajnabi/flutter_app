import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';

/// ------------------ EcoTravelPage ------------------
class EcoTravelPage extends StatefulWidget {
  const EcoTravelPage({super.key});

  @override
  State<EcoTravelPage> createState() => _EcoTravelPageState();
}

class _EcoTravelPageState extends State<EcoTravelPage>
    with TickerProviderStateMixin {
  bool isDarkMode = false;
  LatLng currentLocation = LatLng(0, 0);

  late VideoPlayerController _videoController;
  bool videoReady = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
  void initState() {
    super.initState();
    _initVideo();
    _checkLocationPermission();

    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _fadeController,
          curve: Curves.easeIn,
        ));
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

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDialog("Location is off. Please turn it on.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationDialog("Location permission denied. Please allow access.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationDialog(
          "Location permissions are permanently denied. Please enable them in settings.");
      return;
    }

    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(pos.latitude, pos.longitude);
    });
  }

  void _showLocationDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Location Required"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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

          /// Overlay
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

          /// Content
          FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // AppBar
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    floating: true,
                    snap: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: const Text(
                      "Eco Travel Guide",
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
                        ),
                        onPressed: () => setState(() => isDarkMode = !isDarkMode),
                      ),
                    ],
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Header card
                        _glassCard(
                          title: "Travel Smart, Travel Green 🌍",
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                "Choose eco-friendly travel options to reduce your carbon footprint.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white70 : Colors.black87,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Map Card
                        if (currentLocation.latitude != 0 &&
                            currentLocation.longitude != 0)
                          _glassMapCard(currentLocation)
                        else
                          const SizedBox(
                              height: 250,
                              child: Center(child: CircularProgressIndicator())),

                        const SizedBox(height: 20),

                        // Travel options cards
                        ...travelOptions.map((item) {
                          return _glassCard(
                            title: item["title"],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: item["color"].withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        item["icon"],
                                        size: 32,
                                        color: item["color"],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                item["title"],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.green.shade800,
                                                  fontFamily: 'Poppins',
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item["subtitle"],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: item["color"],
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item["desc"],
                                            style: TextStyle(
                                              color:
                                              isDarkMode ? Colors.white70 : Colors.black87,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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

  // Glass Card widget
  Widget _glassCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey.shade800.withOpacity(0.9), Colors.grey.shade700.withOpacity(0.9)]
              : [Colors.white.withOpacity(0.9), Colors.green.shade50.withOpacity(0.9)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 10),
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
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // Glass Map Card
  Widget _glassMapCard(LatLng location) {
    return _glassCard(
      title: "Your Location",
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: FlutterMap(
            options: MapOptions(center: location, zoom: 14),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.sustainable_living_app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: location,
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
      ),
    );
  }
}
