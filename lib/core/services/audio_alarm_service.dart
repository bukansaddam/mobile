import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AudioAlarmService {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  double _volume = 1.0;
  bool _soundEnabled = true;
  Timer? _fallbackTimer;

  bool get isPlaying => _isPlaying;
  double get volume => _volume;
  bool get soundEnabled => _soundEnabled;

  AudioAlarmService();

  AudioPlayer _getAudioPlayer() {
    if (_audioPlayer == null) {
      try {
        _audioPlayer = AudioPlayer();
        _audioPlayer?.setReleaseMode(ReleaseMode.loop);
      } catch (e) {
        debugPrint('Warning initializing AudioPlayer: $e');
      }
    }
    return _audioPlayer ?? AudioPlayer();
  }

  /// Memutar suara sirine alarm bencana alam secara berulang (looping)
  Future<void> startEmergencyAlarm() async {
    if (!_soundEnabled) return;
    _isPlaying = true;

    try {
      final player = _getAudioPlayer();
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(_volume);
      await player.play(AssetSource('sounds/emergency_alarm.wav'));
      debugPrint('🚨 Emergency alarm siren started ringing via AudioPlayer!');
    } catch (e) {
      debugPrint(
        'AudioPlayer failed (e.g. MissingPluginException). Using SystemSound fallback: $e',
      );
      _startSystemFallbackRinging();
    }
  }

  /// Fallback dering menggunakan SystemSound + Haptic jika plugin native belum ter-link
  void _startSystemFallbackRinging() {
    _fallbackTimer?.cancel();
    _fallbackTimer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (!_isPlaying || !_soundEnabled) {
        timer.cancel();
        return;
      }
      try {
        SystemSound.play(SystemSoundType.alert);
        HapticFeedback.vibrate();
      } catch (_) {}
    });
  }

  /// Uji suara alarm darurat (memutar 4 detik lalu berhenti)
  Future<void> playTestAlarm() async {
    if (!_soundEnabled) return;
    _isPlaying = true;

    try {
      final player = _getAudioPlayer();
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setVolume(_volume);
      await player.play(AssetSource('sounds/emergency_alarm.wav'));
      Timer(const Duration(seconds: 4), () {
        stopAlarm();
      });
    } catch (e) {
      debugPrint('AudioPlayer test failed, using SystemSound fallback: $e');
      _startSystemFallbackRinging();
      Timer(const Duration(seconds: 4), () {
        stopAlarm();
      });
    }
  }

  /// Menghentikan dering alarm
  Future<void> stopAlarm() async {
    _isPlaying = false;
    _fallbackTimer?.cancel();
    _fallbackTimer = null;

    try {
      await _audioPlayer?.stop();
      debugPrint('🔕 Emergency alarm siren stopped.');
    } catch (e) {
      debugPrint('Error stopping AudioPlayer: $e');
    }
  }

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    if (!enabled && _isPlaying) {
      stopAlarm();
    }
  }

  void setVolume(double val) {
    _volume = val;
    try {
      _audioPlayer?.setVolume(val);
    } catch (_) {}
  }

  void dispose() {
    stopAlarm();
    _audioPlayer?.dispose();
    _audioPlayer = null;
  }
}
