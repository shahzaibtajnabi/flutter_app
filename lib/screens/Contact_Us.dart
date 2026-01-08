import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage>
    with TickerProviderStateMixin {
  bool isDarkMode = false;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final messageController = TextEditingController();

  late VideoPlayerController _videoController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
    nameController.dispose();
    emailController.dispose();
    numberController.dispose();
    messageController.dispose();
    _videoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Message sent successfully 🌱"),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      _formKey.currentState!.reset();
    }
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

          /// 🌫 Gradient Overlay
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

          /// 🌿 Content
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
                      "Contact Us",
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
                          size: 26,
                        ),
                        onPressed: () =>
                            setState(() => isDarkMode = !isDarkMode),
                      ),
                    ],
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        /// Hero Card
                        _glassCard(
                          title: "Get In Touch",
                          child: Column(
                            children: [
                              Icon(Icons.contact_support,
                                  size: 80,
                                  color: Colors.green.shade600),
                              const SizedBox(height: 12),
                              Text(
                                "We’d love to hear from you 🌱",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.green.shade800,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// Form Card
                        _glassCard(
                          title: "Send Message",
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _inputField(
                                    nameController, "Name", Icons.person),
                                const SizedBox(height: 14),
                                _inputField(
                                    emailController, "Email", Icons.email),
                                const SizedBox(height: 14),
                                _inputField(numberController,
                                    "Contact Number", Icons.phone),
                                const SizedBox(height: 14),
                                _inputField(messageController, "Message",
                                    Icons.message,
                                    maxLines: 4),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: submitForm,
                                  icon: const Icon(Icons.send,
                                      color: Colors.white),
                                  label: const Text(
                                    "Send Message",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins'),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    Colors.green.shade700,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(25),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

  /// ================= HELPERS =================

  Widget _glassCard({required String title, required Widget child}) {
    return Container(
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
              offset: const Offset(0, 10)),
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
              color:
              isDarkMode ? Colors.white : Colors.green.shade800,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _inputField(
      TextEditingController controller,
      String label,
      IconData icon, {
        int maxLines = 1,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (v) => v!.isEmpty ? "Required" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green.shade600),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
