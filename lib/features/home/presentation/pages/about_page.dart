import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tube_filter/core/constants/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String appVersion = '1.0.0';
  static const String developerName = 'Sarfaraz Ahamed Shovon';
  static const String appDescription =
      'FixTube is a smart YouTube content filter that helps you curate '
      'your feed by filtering videos based on keywords, blocking shorts, '
      'and organizing channels into categories.';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.play_circle_filled,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // App Name
            Text(
              'FixTube',
              style: GoogleFonts.playball(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              'Version $appVersion',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                appDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Developer Section
            const _SectionTitle(title: 'Developer'),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: const Text(
                developerName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Flutter Developer'),
            ),
            const SizedBox(height: 32),

            // Features Section
            const _SectionTitle(title: 'Features'),
            const SizedBox(height: 12),
            _buildFeatureItem(Icons.filter_alt, 'Smart Keyword Filtering'),
            _buildFeatureItem(Icons.block, 'Shorts Blocking'),
            _buildFeatureItem(Icons.category, 'Channel Categories'),
            _buildFeatureItem(Icons.bookmark, 'Bookmarks'),
            _buildFeatureItem(Icons.widgets, 'Home Screen Widget'),
            _buildFeatureItem(Icons.dark_mode, 'Multiple Themes'),
            const SizedBox(height: 32),

            // Footer
            Text(
              '© ${DateTime.now().year} $developerName',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Made with ❤️ using Flutter',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
