import 'package:flutter/material.dart';

class VideoOverlayService {
  Future<String?> processBrandedVideo(String originalVideoPath, String challengeTitle) async {
    await Future.delayed(const Duration(seconds: 2));
    return originalVideoPath;
  }
}
