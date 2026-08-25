class ApiConstants {
  ApiConstants._();

  //Base URL
  static const String baseUrl = 'https://akaraslinmas.id';

  //Auth
  static const String login = '/api/login';
  static const String register = '/api/register';

  //News / Announcement
  static const String news = '/api/news';

  //Surveys
  static const String surveys = '/api/surveys';

  //Tracking
  static const String position = '/api/positions/me';
  static const String tracking = '/api/positions/me';

  //Google Speech
  static const List<String> googleCloudScopes = [
    'https://www.googleapis.com/auth/cloud-platform',
  ];

  static String googleSpeechRecognizeUrl(String projectId) =>
      'https://asia-southeast1-speech.googleapis.com/v2/projects/$projectId/locations/asia-southeast1/recognizers/_:recognize';
}
