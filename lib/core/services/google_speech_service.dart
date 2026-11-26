import 'package:akar/core/constants/api_constants.dart';
import 'package:akar/core/errors/exceptions.dart';
import 'package:akar/core/network/dio_client.dart';
import 'package:akar/core/utils/error_utils.dart';
import 'package:akar/utils/app_logger.dart';
import 'package:dio/dio.dart';

class GoogleSpeechService {
  static const String _maintenanceMessage =
      'Fitur dikte suara sedang dalam pemeliharaan. Silakan ketik keterangan secara manual.';

  final Dio _dio;

  GoogleSpeechService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  Future<String> transcribeAudioBytes(
    List<int> audioBytes, {
    int sampleRateHertz = 16000,
  }) async {
    if (audioBytes.isEmpty) {
      return '';
    }

    try {
      final formData = FormData.fromMap({
        'audio': MultipartFile.fromBytes(audioBytes, filename: 'speech.wav'),
        'language_code': 'id-ID',
        'sample_rate_hertz': sampleRateHertz,
      });

      final response = await _dio.post(
        ApiConstants.speechTranscribe,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final transcript = _extractTranscript(response.data);
      return transcript.trim();
    } on DioException catch (e, stack) {
      final statusCode = e.response?.statusCode;
      AppLogger.e('Speech proxy transcription failed', e, stack);
      if (statusCode == 404 || statusCode == 501) {
        throw ServerException(_maintenanceMessage, statusCode: statusCode);
      }
      throw ErrorUtils.toAppException(
        e,
        fallbackMessage: 'Gagal memproses suara. Silakan coba lagi.',
      );
    } catch (e, stack) {
      AppLogger.e('Unexpected error transcribing audio', e, stack);
      throw ErrorUtils.toAppException(
        e,
        fallbackMessage: 'Gagal memproses suara. Silakan coba lagi.',
      );
    }
  }

  String _extractTranscript(dynamic data) {
    if (data is! Map) return '';
    final nested = data['data'];
    if (nested is Map && nested['transcript'] != null) {
      return nested['transcript'].toString();
    }
    if (data['transcript'] != null) {
      return data['transcript'].toString();
    }
    return '';
  }
}
