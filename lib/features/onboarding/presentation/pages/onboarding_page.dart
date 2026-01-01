import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tube_filter/core/constants/app_colors.dart';
import 'package:tube_filter/core/widgets/animated_logo.dart';
import 'package:tube_filter/features/home/presentation/pages/home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Welcome to FixTube',
      'desc':
          'Take back control of your video feed. No algorithms, just what you want.',
      'icon': 'smart_display_rounded', // Will convert to IconData
    },
    {
      'title': 'Add Your Channels',
      'desc':
          'Subscribe to your favorite creators using their Channel ID or Handle.',
      'icon': 'subscriptions_rounded',
    },
    {
      'title': 'Filter the Noise',
      'desc':
          'Set "Include" keywords for what you love, and "Exclude" for what you hide.',
      'icon': 'tune_rounded',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(30),
                            shape: BoxShape.circle,
                          ),
                          child: index == 0
                              ? const AnimatedLogo(size: 80)
                              : Icon(
                                  _getIcon(_slides[index]['icon']!),
                                  size: 80,
                                  color: AppColors.primary,
                                ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          _slides[index]['title']!,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.color,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _slides[index]['desc']!,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_currentPage < _slides.length - 1) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _finishOnboarding();
                    }
                  },
                  child: Text(
                    _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'smart_display_rounded':
        return Icons.smart_display_rounded;
      case 'subscriptions_rounded':
        return Icons.subscriptions_rounded;
      case 'tune_rounded':
        return Icons.tune_rounded;
      default:
        return Icons.star;
    }
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }
}
