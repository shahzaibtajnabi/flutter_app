import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// ================= BACKGROUND VIDEO =================
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

/// ================= ABOUT US PAGE =================
class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
  bool isDarkMode = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _slideController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _slideAnimation = Tween(begin: const Offset(0, 0.4), end: Offset.zero)
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

          /// Modern Overlay with Gradient
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

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: CustomScrollView(
                slivers: [
                  // Modern SliverAppBar
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    pinned: false,
                    floating: true,
                    snap: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: const Text(
                      "About Us",
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
                          size: 28,
                        ),
                        onPressed: () => setState(() => isDarkMode = !isDarkMode),
                      ),
                    ],
                  ),

                  // Content Slivers
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _heroCard(),
                        _missionCard(),
                        _teamCard(),
                        _contactCard(),
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

  /// ================= UI SECTIONS =================
  Widget _heroCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: _glassCard(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade100.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(Icons.eco, size: 60, color: Colors.green.shade700),
            ),
            const SizedBox(height: 16),
            Text(
              "Sustainable Living App",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.green.shade800,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Empowering greener choices, one step at a time.",
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _missionCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: _glassCard(
        title: "Our Mission",
        icon: Icons.lightbulb,
        child: Text(
          "Our mission is to help people reduce their carbon footprint "
              "through awareness, eco-friendly habits, and sustainable choices.",
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: isDarkMode ? Colors.white : Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _teamCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: _glassCard(
        title: "Meet Our Team",
        icon: Icons.people,
        child: Column(
          children: const [
            _TeamRow("John Doe", "Lead Developer"),
            _TeamRow("Jane Smith", "UI/UX Designer"),
            _TeamRow("Ali Khan", "Backend Developer"),
          ],
        ),
      ),
    );
  }

  Widget _contactCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: _glassCard(
        title: "Get In Touch",
        icon: Icons.contact_mail,
        child: Column(
          children: const [
            _InfoRow(Icons.email, "info@sustainableapp.com"),
            SizedBox(height: 8),
            _InfoRow(Icons.web, "www.sustainableapp.com"),
          ],
        ),
      ),
    );
  }

  Widget _glassCard({String? title, IconData? icon, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey.shade800.withOpacity(0.9), Colors.grey.shade700.withOpacity(0.9)]
              : [Colors.white.withOpacity(0.9), Colors.green.shade50.withOpacity(0.9)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.green.shade700, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.green.shade800,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          if (title != null) const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// ================= SMALL WIDGETS =================
class _TeamRow extends StatelessWidget {
  final String name, role;
  const _TeamRow(this.name, this.role, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.person, color: Colors.green.shade600, size: 20),
          const SizedBox(width: 12),
          Text(
            "$name – $role",
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade600, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}