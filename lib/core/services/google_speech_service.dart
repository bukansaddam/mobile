import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:logger/logger.dart';

import '../constants/api_constants.dart';

class _AuthData {
  final String token;
  final String projectId;
  _AuthData({required this.token, required this.projectId});
}

class GoogleSpeechService {
  final Dio _dio;
  final Logger _logger = Logger();

  static const String _credentialAssetPath =
      'lib/core/crd/akar-504702-d2d27b0e66f2.json';

  GoogleSpeechService({Dio? dio}) : _dio = dio ?? Dio();

  Future<_AuthData> _getAuthData() async {
    try {
      final jsonString = await rootBundle.loadString(_credentialAssetPath);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final accountCredentials = ServiceAccountCredentials.fromJson(jsonMap);
      final projectId = jsonMap['project_id'] as String? ?? 'akar-504702';

      final authClient = await clientViaServiceAccount(
        accountCredentials,
        ApiConstants.googleCloudScopes,
      );

      final token = authClient.credentials.accessToken.data;
      authClient.close();
      return _AuthData(token: token, projectId: projectId);
    } catch (e, stack) {
      _logger.e(
        'Failed to get Google Cloud access token',
        error: e,
        stackTrace: stack,
      );
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
      _logger.e(
        'Error transcribing audio with Google Speech v2 API (Chirp 2 - Singapore)',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  Stream<String> transcribeAudioStream(
    Stream<List<int>> audioStream, {
    int sampleRateHertz = 16000,
  }) async* {
    try {
      final jsonString = await rootBundle.loadString(_credentialAssetPath);
      final serviceAccount = ServiceAccount.fromString(jsonString);
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
      _logger.e(
        'Error streaming audio to Google Speech API',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
}
