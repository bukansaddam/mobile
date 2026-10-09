import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:akar/utils/app_logger.dart';

import '../constants/api_constants.dart';

class _AuthData {
  final String token;
  final String projectId;
  final DateTime expiry;

  _AuthData({
    required this.token,
    required this.projectId,
    required this.expiry,
  });

  /// Token is valid if current time is before expiry minus 5 minutes safety margin
  bool get isValid =>
      DateTime.now().isBefore(expiry.subtract(const Duration(minutes: 5)));
}

class GoogleSpeechService {
  final Dio _dio;

  static const String _credentialAssetPath =
      'lib/core/crd/akar-504702-d2d27b0e66f2.json';

  _AuthData? _cachedAuthData;
  String? _cachedCredentialJson;
  ServiceAccount? _cachedServiceAccount;

  GoogleSpeechService({Dio? dio}) : _dio = dio ?? Dio();

  Future<_AuthData> _getAuthData() async {
    if (_cachedAuthData != null && _cachedAuthData!.isValid) {
      return _cachedAuthData!;
    }

    try {
      final jsonString = _cachedCredentialJson ??= await rootBundle.loadString(
        _credentialAssetPath,
      );
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final accountCredentials = ServiceAccountCredentials.fromJson(jsonMap);
      final projectId = jsonMap['project_id'] as String? ?? 'akar-504702';

      final authClient = await clientViaServiceAccount(
        accountCredentials,
        ApiConstants.googleCloudScopes,
      );

      final token = authClient.credentials.accessToken.data;
      final expiry = authClient.credentials.accessToken.expiry;
      authClient.close();

      _cachedAuthData = _AuthData(
        token: token,
        projectId: projectId,
        expiry: expiry,
      );
      return _cachedAuthData!;
    } catch (e, stack) {
      AppLogger.e('Failed to get Google Cloud access token', e, stack);
      rethrow;
    }
  }

  Future<String> transcribeAudioBytes(
    List<int> audioBytes, {
    int sampleRateHertz = 16000,
  }) async {
    try {
      final authData = await _getAuthData();
      final base64Audio = base64Encode(audioBytes);

      final url = ApiConstants.googleSpeechRecognizeUrl(authData.projectId);

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authData.token}',
            'Content-Type': 'application/json; charset=utf-8',
          },
        ),
        data: {
          'config': {
            'autoDecodingConfig': {},
            'model': 'chirp_2',
            'languageCodes': ['id-ID'],
            'features': {'enableAutomaticPunctuation': true},
          },
          'content': base64Audio,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>?;
        if (results == null || results.isEmpty) {
          return '';
        }

        final StringBuffer transcriptBuffer = StringBuffer();
        for (final result in results) {
          final alternatives = result['alternatives'] as List<dynamic>?;
          if (alternatives != null && alternatives.isNotEmpty) {
            final transcript = alternatives[0]['transcript'] as String?;
            if (transcript != null && transcript.trim().isNotEmpty) {
              if (transcriptBuffer.isNotEmpty) {
                transcriptBuffer.write(' ');
              }
              transcriptBuffer.write(transcript.trim());
            }
          }
        }
        return transcriptBuffer.toString();
      } else {
        throw Exception(
          'Google Speech v2 API error: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } catch (e, stack) {
      AppLogger.e(
        'Error transcribing audio with Google Speech v2 API (Chirp 2 - Singapore)',
        e,
        stack,
      );
      rethrow;
    }
  }

  Stream<String> transcribeAudioStream(
    Stream<List<int>> audioStream, {
    int sampleRateHertz = 16000,
  }) async* {
    try {
      final jsonString = _cachedCredentialJson ??= await rootBundle.loadString(
        _credentialAssetPath,
      );
      final serviceAccount = _cachedServiceAccount ??=
          ServiceAccount.fromString(jsonString);
      final speechToText = SpeechToText.viaServiceAccount(serviceAccount);

      final config = RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        sampleRateHertz: sampleRateHertz,
        languageCode: 'id-ID',
      );

      final streamingConfig = StreamingRecognitionConfig(
        config: config,
        interimResults: true,
      );

      final responseStream = speechToText.streamingRecognize(
        streamingConfig,
        audioStream,
      );

      await for (final response in responseStream) {
        final results = response.results;
        if (results.isNotEmpty) {
          final transcript = results
              .map(
                (res) => res.alternatives.isNotEmpty
                    ? res.alternatives.first.transcript
                    : '',
              )
              .where((text) => text.trim().isNotEmpty)
              .join(' ');

          if (transcript.isNotEmpty) {
            yield transcript;
          }
        }
      }
    } catch (e, stack) {
      AppLogger.e('Error streaming audio to Google Speech API', e, stack);
      rethrow;
    }
  }
}
