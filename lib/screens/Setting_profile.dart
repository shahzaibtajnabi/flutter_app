import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// ================= BACKGROUND VIDEO (Reusable) =================
class BackgroundVideo extends StatefulWidget {
  const BackgroundVideo({super.key});

  @override
  State<BackgroundVideo> createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/nature_background.mp4")
      ..initialize().then((_) {
        _controller
          ..setLooping(true)
          ..setVolume(0)
          ..play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) return const SizedBox();
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}

/// ================= SETTINGS / PROFILE PAGE =================
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    // Slide animation
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _slideAnimation = Tween(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundVideo(),

          // Overlay for readability
          Container(
            color: isDarkMode
                ? Colors.black.withOpacity(0.5)
                : Colors.white.withOpacity(0.25),
          ),

          SafeArea(
            child: Column(
              children: [
                _appBar(),

                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        SlideTransition(position: _slideAnimation, child: _profileCard()),
                        SlideTransition(position: _slideAnimation, child: _settingsOptions()),
                        SlideTransition(position: _slideAnimation, child: _logoutCard()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= APP BAR =================
  Widget _appBar() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey.shade900, Colors.black]
              : [Colors.green.shade600, Colors.green.shade800],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(0.3))],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              "Settings / Profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white),
            onPressed: () => setState(() => isDarkMode = !isDarkMode),
          ),
        ],
      ),
    );
  }

  /// ================= PROFILE CARD =================
  Widget _profileCard() {
    return _glassCard(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.green.shade700,
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            "John Doe",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
                letterSpacing: 1.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "john.doe@email.com",
            style: TextStyle(
                fontSize: 16,
                color: Colors.green.shade600,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// ================= SETTINGS OPTIONS =================
  Widget _settingsOptions() {
    return _glassCard(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.lock, color: Colors.green.shade700),
            title: Text("Change Password",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade800)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.green.shade400),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Change Password tapped"),
                  backgroundColor: Colors.green.shade700,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
          const Divider(),
          SwitchListTile(
            secondary: Icon(Icons.notifications, color: Colors.green.shade700),
            title: Text("Enable Notifications",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade800)),
            value: notificationsEnabled,
            activeColor: Colors.green.shade700,
            onChanged: (val) => setState(() => notificationsEnabled = val),
          ),
        ],
      ),
    );
  }

  /// ================= LOGOUT CARD =================
  Widget _logoutCard() {
    return _glassCard(
      child: ListTile(
        leading: Icon(Icons.logout, color: Colors.red.shade700),
        title: Text("Logout",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.red.shade700)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.red.shade400),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Logged out successfully"),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
      ),
    );
  }

  /// ================= GLASS CARD HELPER =================
  Widget _glassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
          BoxShadow(blurRadius: 16, color: Colors.black.withOpacity(0.25)),
        ],
      ),
      child: child,
    );
  }
}
