import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class EcoProductsPage extends StatefulWidget {
  const EcoProductsPage({super.key});

  @override
  State<EcoProductsPage> createState() => _EcoProductsPageState();
}

class _EcoProductsPageState extends State<EcoProductsPage> {
  String selectedCategory = "All";
  String searchQuery = "";
  bool isDarkMode = false;

  late VideoPlayerController _videoController;
  bool videoReady = false;

  final List<Map<String, String>> products = [
    {
      "title": "Bamboo Toothbrush",
      "category": "Kitchen",
      "description": "Eco-friendly bamboo toothbrush with biodegradable handle.",
      "certification": "FSC Certified",
      "image": "assets/images/eco_products_pic/bambo.jpg",
    },
    {
      "title": "Reusable Coffee Cup",
      "category": "Office",
      "description": "Reusable cup to reduce plastic waste.",
      "certification": "BPA Free",
      "image": "assets/images/eco_products_pic/cup2.jpg",
    },
    {
      "title": "Eco Travel Bottle",
      "category": "Travel",
      "description": "Stainless steel water bottle for travel.",
      "certification": "Food Grade Steel",
      "image": "assets/images/eco_products_pic/bottle.jpg",
    },
  ];

  List<Map<String, String>> get filteredProducts {
    return products.where((product) {
      final matchesCategory =
          selectedCategory == "All" || product["category"] == selectedCategory;
      final matchesSearch =
      product["title"]!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _videoController =
    VideoPlayerController.asset('assets/videos/nature_background.mp4')
      ..initialize().then((_) {
        setState(() => videoReady = true);
        _videoController
          ..setLooping(true)
          ..setVolume(0)
          ..play();
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
          /// 🎥 BACKGROUND VIDEO
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
            Container(color: Colors.black),

          /// 🌫 Overlay
          Container(
            color:
            (isDarkMode ? Colors.black : Colors.white).withOpacity(0.15),
          ),

          SafeArea(
            child: Column(
              children: [
                /// 🔝 CUSTOM APP BAR (Carbon style)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [Colors.grey.shade800, Colors.grey.shade900]
                          : [Colors.green.shade600, Colors.green.shade800],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Eco-Friendly Products",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                      )
                    ],
                  ),
                ),

                /// 🔍 SEARCH BAR
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (v) => setState(() => searchQuery = v),
                    decoration: InputDecoration(
                      hintText: "Search eco products...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor:
                      Colors.white.withOpacity(isDarkMode ? 0.85 : 0.95),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                /// 🏷 CATEGORY FILTER
                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: ["All", "Kitchen", "Office", "Travel"]
                        .map((cat) => Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: selectedCategory == cat,
                        selectedColor: Colors.green.shade700,
                        labelStyle: TextStyle(
                          color: selectedCategory == cat
                              ? Colors.white
                              : Colors.black,
                        ),
                        onSelected: (_) {
                          setState(() => selectedCategory = cat);
                        },
                      ),
                    ))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🛒 PRODUCT LIST
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: isDarkMode
                              ? Colors.grey.shade800.withOpacity(0.9)
                              : Colors.white.withOpacity(0.95),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// 🖼 IMAGE
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(22)),
                              child: Image.asset(
                                product["image"]!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product["title"]!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.green.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product["description"]!,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "✔ ${product["certification"]}",
                                    style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  /// 🛒 BUTTONS
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.shopping_cart),
                                        label: const Text("Buy"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          Colors.green.shade700,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(14),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                          Colors.green.shade700,
                                          side: BorderSide(
                                              color:
                                              Colors.green.shade700),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(14),
                                          ),
                                        ),
                                        child: const Text("Learn More"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
