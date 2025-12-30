import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SustainableRecipesPage extends StatefulWidget {
  const SustainableRecipesPage({super.key});

  @override
  State<SustainableRecipesPage> createState() =>
      _SustainableRecipesPageState();
}

class _SustainableRecipesPageState extends State<SustainableRecipesPage> {
  late VideoPlayerController _videoController;

  bool isDarkMode = false;
  String selectedCategory = "All";

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
    _videoController =
    VideoPlayerController.asset("assets/videos/nature_background.mp4")
      ..initialize().then((_) {
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

  List<Map<String, dynamic>> get filteredRecipes {
    return recipes.where((r) {
      return selectedCategory == "All" ||
          r["category"] == selectedCategory;
    }).toList();
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

          /// Overlay
          Container(
            color: isDarkMode
                ? Colors.black.withOpacity(0.45)
                : Colors.white.withOpacity(0.15),
          ),

          /// Main UI
          SafeArea(
            child: Column(
              children: [

                /// 🍽 Custom AppBar (Carbon style)
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
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          "Sustainable Recipes",
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

                /// Category Filter
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: ["All", "Breakfast", "Lunch", "Dinner"]
                        .map(
                          (cat) => Padding(
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
                      ),
                    )
                        .toList(),
                  ),
                ),

                const SizedBox(height: 10),

                /// Recipe List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, i) {
                      final r = filteredRecipes[i];
                      return _recipeCard(r, i);
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

  /// 🍲 Recipe Card
  Widget _recipeCard(Map<String, dynamic> r, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
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
            blurRadius: 18,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Image + Favorite
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.asset(
                  r["image"],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: IconButton(
                  icon: Icon(
                    r["fav"] ? Icons.favorite : Icons.favorite_border,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      recipes[index]["fav"] =
                      !recipes[index]["fav"];
                    });
                  },
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r["title"],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                    isDarkMode ? Colors.white : Colors.green.shade800,
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
