import 'package:cole20/core/apiEndPoints.dart';
import 'package:flutter/material.dart';

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
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: this,
    );
  }
}

  Color hexToColor(String hex) {
    final cleanHex = hex.replaceAll("#", "");
    return Color(int.parse("FF$cleanHex", radix: 16));
  }