import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SustainableRecipesPage extends StatefulWidget {
  const SustainableRecipesPage({super.key});

  @override
  State<SustainableRecipesPage> createState() =>
      _SustainableRecipesPageState();
}

class _SustainableRecipesPageState extends State<SustainableRecipesPage>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoController;

  bool isDarkMode = false;
  String selectedCategory = "All";

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> recipes = [
    {
      "title": "Green Smoothie Bowl",
      "category": "Breakfast",
      "image": "assets/images/recipes_pic/breakfast.jpg",
      "description": "Healthy smoothie bowl with fruits & seeds",
      "carbon": "1.2 kg CO₂ saved",
      "ingredients": "Banana, Spinach, Almond milk",
      "steps": "Blend all ingredients & serve cold",
      "fav": false,
    },
    {
      "title": "Veggie Power Lunch",
      "category": "Lunch",
      "image": "assets/images/recipes_pic/lunch.jpg",
      "description": "Plant-based balanced lunch meal",
      "carbon": "2.8 kg CO₂ saved",
      "ingredients": "Rice, Veggies, Olive oil",
      "steps": "Cook rice, sauté veggies, mix well",
      "fav": false,
    },
    {
      "title": "Eco Dinner Bowl",
      "category": "Dinner",
      "image": "assets/images/recipes_pic/dinner.jpg",
      "description": "Low carbon, high protein dinner",
      "carbon": "3.5 kg CO₂ saved",
      "ingredients": "Quinoa, Beans, Greens",
      "steps": "Boil quinoa, mix beans & veggies",
      "fav": false,
    },
  ];

  @override
  void initState() {
    super.initState();

    /// 🎥 Video Background
    _videoController =
    VideoPlayerController.asset("assets/videos/nature_background.mp4")
      ..initialize().then((_) {
        _videoController
          ..setLooping(true)
          ..setVolume(0)
          ..play();
        setState(() {});
      });

    /// ✨ Fade Animation
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
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredRecipes {
    return recipes.where((r) {
      return selectedCategory == "All" ||
          r["category"] == selectedCategory;
    }).toList();
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

          /// 🌈 Gradient Overlay (Carbon Style)
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
                      "Sustainable Recipes",
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

                  /// 🍽 Category Filter
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 55,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                        children: ["All", "Breakfast", "Lunch", "Dinner"]
                            .map(
                              (cat) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6),
                            child: ChoiceChip(
                              label: Text(cat),
                              selected:
                              selectedCategory == cat,
                              selectedColor:
                              Colors.green.shade700,
                              labelStyle: TextStyle(
                                color: selectedCategory == cat
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onSelected: (_) =>
                                  setState(() =>
                                  selectedCategory = cat),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ),

                  /// 📋 Recipe List
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, i) =>
                            _recipeCard(filteredRecipes[i], i),
                        childCount: filteredRecipes.length,
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

  /// 🍲 Glass Recipe Card
  Widget _recipeCard(Map<String, dynamic> r, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
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
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🖼 Image + Favorite
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(25)),
                child: Image.asset(
                  r["image"],
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: IconButton(
                  icon: Icon(
                    r["fav"]
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => setState(() =>
                  recipes[index]["fav"] =
                  !recipes[index]["fav"]),
                ),
              ),
            ],
          ),

          /// 📄 Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  r["title"],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? Colors.white
                        : Colors.green.shade800,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 6),
                Text(r["description"]),
                const SizedBox(height: 8),
                Text(
                  "🌱 ${r["carbon"]}",
                  style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text("🧾 Ingredients: ${r["ingredients"]}"),
                Text("👩‍🍳 Steps: ${r["steps"]}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
