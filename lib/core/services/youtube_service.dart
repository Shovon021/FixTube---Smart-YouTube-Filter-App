import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class YouTubeService {
  final String apiKey;
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  YouTubeService({required this.apiKey});

  /// Fetches channel details including the Uploads Playlist ID.
  /// Input can be a Channel ID or @handle.
  Future<Map<String, dynamic>?> getChannelDetails(
    String channelIdentifier,
  ) async {
    String param = 'id';
    if (channelIdentifier.startsWith('@')) {
      param = 'forHandle';
    }

    final url = Uri.parse(
      '$_baseUrl/channels?part=snippet,contentDetails&$param=$channelIdentifier&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null && (data['items'] as List).isNotEmpty) {
          final item = data['items'][0];
          return {
            'id': item['id'],
            'title': item['snippet']['title'],
            'thumbnail': item['snippet']['thumbnails']['high']['url'],
            'uploadPlaylistId':
                item['contentDetails']['relatedPlaylists']['uploads'],
          };
        }
      }
    } catch (e) {
      debugPrint('Error fetching channel: $e');
    }
    return null;
  }

  /// Fetches the latest videos from the channel's "Uploads" playlist.
  /// This costs only 1 unit per call.
  Future<List<Map<String, dynamic>>> getPlaylistVideos(
    String playlistId,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/playlistItems?part=snippet,contentDetails&maxResults=20&playlistId=$playlistId&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null) {
          return (data['items'] as List).map((item) {
            final snippet = item['snippet'];
            // contentDetails might be in the item or fetched separately for videos.
            // Actually, playlistItems gives contentDetails but for duration we strictly need 'video' endpoint usually.
            // BUT: 'playlistItems' contentDetails only has videoId and PublishedAt sometimes.
            // Let's check docs: https://developers.google.com/youtube/v3/docs/playlistItems#resource
            // contentDetails in playlistItems does NOT have duration.
            // We must do a second call to 'videos' endpoint with the IDs.

            return {
              'id': snippet['resourceId']['videoId'],
              'title': snippet['title'],
              'description': snippet['description'],
              'publishedAt': snippet['publishedAt'],
              'thumbnail': _getBestThumbnail(snippet['thumbnails']),
              'channelTitle': snippet['channelTitle'],
            };
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching videos: $e');
    }
    return [];
  }

  // Helper to safely get the best available thumbnail
  String _getBestThumbnail(Map<String, dynamic> thumbnails) {
    if (thumbnails['high'] != null) return thumbnails['high']['url'];
    if (thumbnails['medium'] != null) return thumbnails['medium']['url'];
    if (thumbnails['default'] != null) return thumbnails['default']['url'];
    return ''; // Should not happen given YouTube API guarantees default
  }

  /// Fetch details for a list of video IDs (max 50) to get duration
  Future<Map<String, String>> getVideoDurations(List<String> videoIds) async {
    if (videoIds.isEmpty) return {};

    final ids = videoIds.join(',');
    final url = Uri.parse(
      '$_baseUrl/videos?part=contentDetails&id=$ids&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, String> durations = {};
        if (data['items'] != null) {
          for (var item in data['items']) {
            durations[item['id']] = item['contentDetails']['duration'];
          }
        }
        return durations;
      }
    } catch (e) {
      debugPrint('Error fetching durations: $e');
    }
    return {};
  }

  /// Search for channels by query string (e.g. "MKBHD")
  Future<List<Map<String, dynamic>>> searchChannels(String query) async {
    final url = Uri.parse(
      '$_baseUrl/search?part=snippet&type=channel&q=$query&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null) {
          return (data['items'] as List).map((item) {
            final snippet = item['snippet'];
            return {
              'id': snippet['channelId'],
              'title': snippet['title'],
              'thumbnail':
                  snippet['thumbnails']['default']['url'], // Default is small enough for list
            };
          }).toList();
        }
      }
    } catch (e) {
      debugPrint('Error searching channels: $e');
    }
    return [];
  }
}
