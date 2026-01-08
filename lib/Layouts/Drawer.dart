import 'package:flutter/material.dart';
import 'package:sustainable_living_app/screens/Contact_Us.dart';
import 'package:sustainable_living_app/screens/Setting_profile.dart';
import '../screens/About_Us.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey.shade900, Colors.black]
                : [Colors.green.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            /// 🔹 Drawer Header with glass style & animation
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          colors: isDarkMode
                              ? [
                            Colors.grey.shade800.withOpacity(0.9),
                            Colors.grey.shade700.withOpacity(0.9)
                          ]
                              : [Colors.green.shade600, Colors.green.shade800],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.eco, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text(
                              "Sustainable Living",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            /// 🔹 Drawer List Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _animatedTile(
                    icon: Icons.info,
                    title: "About Us",
                    page: const AboutUsPage(),
                  ),
                  _animatedTile(
                    icon: Icons.contact_mail,
                    title: "Contact Us",
                    page: const ContactUsPage(),
                  ),
                  _animatedTile(
                    icon: Icons.settings,
                    title: "Settings",
                    page: const SettingsPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Animated Glass-style Drawer Tile
  Widget _animatedTile({
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [
                    Colors.grey.shade800.withOpacity(0.9),
                    Colors.grey.shade700.withOpacity(0.9)
                  ]
                      : [Colors.white.withOpacity(0.95), Colors.green.shade50.withOpacity(0.9)],
                ),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.white.withOpacity(0.05),
                    offset: const Offset(-5, -5),
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(icon, color: Colors.green.shade700),
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade800,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.green.shade400),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => page,
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeInOut));
                        return SlideTransition(position: animation.drive(tween), child: child);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
