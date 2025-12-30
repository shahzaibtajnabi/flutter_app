import 'package:flutter/material.dart';

class EducationalContentPage extends StatefulWidget {
  const EducationalContentPage({super.key});

  @override
  State<EducationalContentPage> createState() => _EducationalContentPageState();
}

class _EducationalContentPageState extends State<EducationalContentPage> {
  bool isDarkMode = false;
  String selectedCategory = "All";
  String searchQuery = "";

  final List<Map<String, dynamic>> contents = [
    {
      "title": "Climate Change Basics",
      "category": "Climate Change",
      "image": "assets/images/education/climate.jpg",
      "description": "Understand the science behind global warming.",
      "fav": false,
    },
    {
      "title": "Recycling Tips",
      "category": "Recycling",
      "image": "assets/images/education/recycling.jpg",
      "description": "Learn how to reduce, reuse, and recycle effectively.",
      "fav": false,
    },
    {
      "title": "Renewable Energy Sources",
      "category": "Energy",
      "image": "assets/images/education/energy.jpg",
      "description": "Solar, wind, and other green energy options.",
      "fav": false,
    },
    {
      "title": "Sustainable Food Choices",
      "category": "Food",
      "image": "assets/images/education/food.jpg",
      "description": "Reduce your carbon footprint with smart food choices.",
      "fav": false,
    },
    {
      "title": "Eco-Friendly Travel",
      "category": "Travel",
      "image": "assets/images/education/travel.jpg",
      "description": "Tips for traveling green and reducing emissions.",
      "fav": false,
    },
  ];

  List<Map<String, dynamic>> get filteredContents {
    return contents.where((c) {
      final matchesCategory =
          selectedCategory == "All" || c["category"] == selectedCategory;
      final matchesSearch =
      c["title"].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.grey.shade900, Colors.grey.shade800]
                    : [Colors.green.shade50, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// Main UI
          SafeArea(
            child: Column(
              children: [
                /// Custom AppBar
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
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          "Educational Content",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() => isDarkMode = !isDarkMode);
                        },
                      ),
                    ],
                  ),
                ),

                /// Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search articles, videos...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor:
                      isDarkMode ? Colors.grey.shade800 : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() => searchQuery = val);
                    },
                  ),
                ),

                /// Category Filter
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: ["All", "Climate Change", "Recycling", "Energy", "Food", "Travel"]
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

                /// Content List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredContents.length,
                    itemBuilder: (context, i) {
                      final c = filteredContents[i];
                      return _contentCard(c, i);
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

  /// Content Card
  Widget _contentCard(Map<String, dynamic> c, int index) {
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
                  c["image"],
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
                    c["fav"] ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.orangeAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      contents[index]["fav"] = !contents[index]["fav"];
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
                  c["title"],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  c["description"],
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
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
