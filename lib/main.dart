import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_filter/core/constants/api_keys.dart';
import 'package:tube_filter/core/database/app_database.dart';
import 'package:tube_filter/core/services/youtube_service.dart';
import 'package:tube_filter/core/theme/theme_provider.dart';
import 'package:tube_filter/features/channels/data/channel_repository.dart';
import 'package:tube_filter/features/channels/providers/channel_provider.dart';
import 'package:tube_filter/features/home/presentation/pages/home_page.dart';

import 'package:tube_filter/features/home/data/video_repository.dart';
import 'package:tube_filter/features/home/providers/feed_provider.dart';
import 'package:tube_filter/core/services/background_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tube_filter/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:tube_filter/core/services/widget_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Wrap in try-catch to prevent white screen if services fail
  try {
    await BackgroundService.initialize();
  } catch (e) {
    debugPrint('BackgroundService init failed: $e');
  }

  try {
    await WidgetService.initialize();
  } catch (e) {
    debugPrint('WidgetService init failed: $e');
  }

  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = !prefs.containsKey('seen_onboarding');

  runApp(TubeFilterApp(showOnboarding: showOnboarding));
}

class TubeFilterApp extends StatelessWidget {
  final bool showOnboarding;

  const TubeFilterApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    // Create shared instances to avoid multiple database connections
    final database = AppDatabase();
    final youtubeService = YouTubeService(apiKey: ApiKeys.youtubeApiKey);

    return MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<YouTubeService>.value(value: youtubeService),
        Provider<ChannelRepository>(
          create: (_) => ChannelRepository(database),
        ),
        Provider<VideoRepository>(
          create: (_) => VideoRepository(database, youtubeService),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProxyProvider<VideoRepository, FeedProvider>(
          create: (context) => FeedProvider(context.read<VideoRepository>()),
          update: (_, repo, prev) => prev ?? FeedProvider(repo),
        ),
        ChangeNotifierProxyProvider2<ChannelRepository, YouTubeService,
            ChannelProvider>(
          create: (context) => ChannelProvider(
            context.read<ChannelRepository>(),
            context.read<YouTubeService>(),
          ),
          update: (_, channelRepo, youtubeService, prev) =>
              prev ?? ChannelProvider(channelRepo, youtubeService),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'FixTube',
            theme: themeProvider.themeData,
            home: showOnboarding ? const OnboardingPage() : const HomePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
