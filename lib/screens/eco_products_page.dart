import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class EcoProductsPage extends StatefulWidget {
  const EcoProductsPage({super.key});

  @override
  State<EcoProductsPage> createState() => _EcoProductsPageState();
}

class _EcoProductsPageState extends State<EcoProductsPage>
    with TickerProviderStateMixin {
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

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _videoController =
    VideoPlayerController.asset('assets/videos/nature_background.mp4')
      ..initialize().then((_) {
        _videoController
          ..setLooping(true)
          ..setVolume(0)
          ..play();
        setState(() => videoReady = true);
      });

    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _fadeController,
          curve: Curves.easeIn,
        ));
    _fadeController.forward();
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
          // Background video
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

          // Overlay gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.black.withOpacity(0.6), Colors.transparent]
                    : [Colors.white.withOpacity(0.25), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Content
          FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  /// AppBar
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
                      "Eco-Friendly Products",
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
                          size: 26,
                        ),
                        onPressed: () => setState(() => isDarkMode = !isDarkMode),
                      ),
                    ],
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Search Bar
                        _glassCard(
                          title: "Search Products",
                          child: TextField(
                            onChanged: (v) => setState(() => searchQuery = v),
                            decoration: InputDecoration(
                              hintText: "Search eco products...",
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor:
                              isDarkMode ? Colors.grey.shade800 : Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Category Chips
                        SizedBox(
                          height: 42,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
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
                                      : (isDarkMode
                                      ? Colors.white70
                                      : Colors.black87),
                                  fontFamily: 'Poppins',
                                ),
                                onSelected: (_) {
                                  setState(() => selectedCategory = cat);
                                },
                              ),
                            ))
                                .toList(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Product List
                        ...filteredProducts.map((product) => _productCard(product)).toList(),
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

  // Glass card widget
  Widget _glassCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // Product Card
  Widget _productCard(Map<String, String> product) {
    return _glassCard(
      title: product["title"]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              product["image"]!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product["description"]!,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "✔ ${product["certification"]}",
            style: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Buy"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green.shade700,
                  side: BorderSide(color: Colors.green.shade700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text("Learn More"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
