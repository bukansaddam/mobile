import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioRecorderService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final Logger _logger = Logger();
  String? _currentPath;

  Future<PermissionStatus> getPermissionStatus() async {
    return await Permission.microphone.status;
  }

  Future<PermissionStatus> requestPermissionStatus() async {
    final hasRecorderPerm = await _audioRecorder.hasPermission();
    if (hasRecorderPerm) {
      return PermissionStatus.granted;
    }

    final status = await Permission.microphone.request();
    if (status.isGranted) {
      return status;
    }

    final recheck = await _audioRecorder.hasPermission();
    return recheck ? PermissionStatus.granted : status;
  }

  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  Future<bool> checkPermission() async {
    final status = await requestPermissionStatus();
    return status.isGranted;
  }

  Future<bool> isRecording() async {
    return await _audioRecorder.isRecording();
  }

  Future<void> startRecording() async {
    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) {
        throw Exception('Microphone permission not granted.');
      }

      final tempDir = await getTemporaryDirectory();
      _currentPath =
          '${tempDir.path}/speech_record_${DateTime.now().millisecondsSinceEpoch}.wav';

      const config = RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      );

      await _audioRecorder.start(config, path: _currentPath!);
      _logger.i('Recording started at $_currentPath');
    } catch (e, stack) {
      _logger.e('Error starting audio recording', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<Stream<List<int>>> startAudioStream() async {
    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) {
        throw Exception('Microphone permission not granted.');
      }

      const config = RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      );

      _logger.i('Starting audio stream...');
      return await _audioRecorder.startStream(config);
    } catch (e, stack) {
      _logger.e('Error starting audio stream', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<List<int>?> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _logger.i('Recording stopped at $path');
      final filePath = path ?? _currentPath;
      if (filePath == null) return null;

      final file = File(filePath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();

        try {
          await file.delete();
        } catch (_) {}
        return bytes;
      }
      return null;
    } catch (e, stack) {
      _logger.e('Error stopping audio recording', error: e, stackTrace: stack);
      rethrow;
    }
  }

  Future<void> cancelRecording() async {
    try {
      final path = await _audioRecorder.stop();
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (_) {}
  }

  void dispose() {
    _audioRecorder.dispose();
  }
}
