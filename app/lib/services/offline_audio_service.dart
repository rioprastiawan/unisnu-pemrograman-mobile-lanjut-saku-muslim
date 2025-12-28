import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../services/database_helper.dart';
import '../services/premium_service.dart';

/// Service untuk mengelola download audio offline (Premium Feature)
class OfflineAudioService {
  static final OfflineAudioService _instance = OfflineAudioService._internal();
  factory OfflineAudioService() => _instance;
  OfflineAudioService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final PremiumService _premiumService = PremiumService();
  
  final Map<int, double> _downloadProgress = {};
  final Map<int, bool> _isDownloading = {};

  /// Check if user can download (premium only)
  Future<bool> canDownload() async {
    return await _premiumService.isPremium();
  }

  /// Get download progress for a surah
  double getDownloadProgress(int surahNumber) {
    return _downloadProgress[surahNumber] ?? 0.0;
  }

  /// Check if currently downloading
  bool isDownloading(int surahNumber) {
    return _isDownloading[surahNumber] ?? false;
  }

  /// Download audio for a surah
  Future<bool> downloadAudio({
    required int surahNumber,
    required String audioUrl,
    required Function(double) onProgress,
  }) async {
    // Check premium status
    final isPremium = await canDownload();
    if (!isPremium) {
      throw Exception('Premium feature required');
    }

    // Check if already downloaded
    final isDownloaded = await _dbHelper.isSurahAudioDownloaded(surahNumber);
    if (isDownloaded) {
      return true;
    }

    try {
      _isDownloading[surahNumber] = true;
      _downloadProgress[surahNumber] = 0.0;

      // Get directory for audio files
      final directory = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${directory.path}/audio');
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }

      // File path
      final filePath = '${audioDir.path}/surah_$surahNumber.mp3';
      final file = File(filePath);

      // Download with progress
      final request = http.Request('GET', Uri.parse(audioUrl));
      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Failed to download: ${response.statusCode}');
      }

      final contentLength = response.contentLength ?? 0;
      int downloadedBytes = 0;

      final sink = file.openWrite();
      
      await for (var chunk in response.stream) {
        sink.add(chunk);
        downloadedBytes += chunk.length;
        
        if (contentLength > 0) {
          final progress = downloadedBytes / contentLength;
          _downloadProgress[surahNumber] = progress;
          onProgress(progress);
        }
      }

      await sink.close();

      // Save to database
      final fileSize = await file.length();
      await _dbHelper.saveOfflineAudio(
        surahNumber: surahNumber,
        filePath: filePath,
        fileSize: fileSize,
      );

      _isDownloading[surahNumber] = false;
      _downloadProgress[surahNumber] = 1.0;

      return true;
    } catch (e) {
      _isDownloading[surahNumber] = false;
      _downloadProgress[surahNumber] = 0.0;
      debugPrint('Error downloading audio: $e');
      return false;
    }
  }

  /// Delete downloaded audio
  Future<bool> deleteAudio(int surahNumber) async {
    try {
      // Get file path from database
      final filePath = await _dbHelper.getOfflineAudioPath(surahNumber);
      if (filePath == null) return false;

      // Delete file
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }

      // Remove from database
      await _dbHelper.deleteOfflineAudio(surahNumber);

      return true;
    } catch (e) {
      debugPrint('Error deleting audio: $e');
      return false;
    }
  }

  /// Get all downloaded audio info
  Future<List<Map<String, dynamic>>> getAllDownloadedAudio() async {
    return await _dbHelper.getAllDownloadedAudio();
  }

  /// Get total size of downloaded audio (in MB)
  Future<double> getTotalDownloadedSize() async {
    final bytes = await _dbHelper.getTotalOfflineAudioSize();
    return bytes / (1024 * 1024); // Convert to MB
  }

  /// Clear all downloads
  Future<void> clearAllDownloads() async {
    final downloads = await getAllDownloadedAudio();
    
    for (final download in downloads) {
      final surahNumber = download['surah_number'] as int;
      await deleteAudio(surahNumber);
    }
  }

  /// Check if audio file exists
  Future<bool> audioFileExists(int surahNumber) async {
    final filePath = await _dbHelper.getOfflineAudioPath(surahNumber);
    if (filePath == null) return false;

    final file = File(filePath);
    return await file.exists();
  }

  /// Format file size
  String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}
