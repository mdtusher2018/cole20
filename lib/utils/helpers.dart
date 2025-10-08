import 'package:cole20/core/apiEndPoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cole20/core/providers.dart';

String getFullImagePath(String imagePath) {
  if (imagePath.isEmpty) {
    return "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg";
  }
  if (imagePath.contains("public")) {
    imagePath = imagePath.replaceFirst("public", "");
  }

  if (imagePath.startsWith('http')) {
    return imagePath;
  }
  if (imagePath.startsWith('/')) {
    return '${ApiEndpoints.baseImageUrl}$imagePath';
  }
  return '${ApiEndpoints.baseImageUrl}/$imagePath';
}

extension Refreshable on Widget {
  Widget withRefresh(Future<void> Function() onRefresh) {
    return RefreshIndicator(onRefresh: onRefresh, child: this);
  }
}

Color hexToColor(String hex) {
  final cleanHex = hex.replaceAll("#", "");
  return Color(int.parse("FF$cleanHex", radix: 16));
}

void clearAllProviders(WidgetRef ref) {
  // Auth
  ref.invalidate(authNotifierProvider);
  ref.invalidate(authRepositoryProvider);

  // Profile
  ref.invalidate(profileNotifierProvider);
  ref.invalidate(profileRepositoryProvider);

  // Rituals
  ref.invalidate(ritualRepositoryProvider);
  ref.invalidate(homePageNotifierProvider);

  // Notifications
  ref.invalidate(notificationNotifierProvider);
  ref.invalidate(notificationRepositoryProvider);

  // API & Storage
  ref.invalidate(apiClientProvider);
  ref.invalidate(apiServiceProvider);
  ref.invalidate(localStorageProvider);
  ref.invalidate(sessionMemoryProvider);
}
