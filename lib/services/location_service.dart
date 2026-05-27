import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static String? _cachedCountryCode;

  /// Detects the user's two-letter ISO country code.
  /// Uses a primary API and a secondary fallback API in case of network or rate limits.
  static Future<String> getUserCountryCode() async {
    if (_cachedCountryCode != null) {
      return _cachedCountryCode!;
    }
    
    // Primary API
    try {
      final response = await http
          .get(Uri.parse('https://ipapi.co/json/'))
          .timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String country = data['country_code']?.toString().toUpperCase() ?? '';
        if (country.isNotEmpty) {
          _cachedCountryCode = country;
          return country;
        }
      }
    } catch (e) {
      print("Primary IP Geolocation failed: $e");
    }

    // Fallback API
    try {
      final response = await http
          .get(Uri.parse('https://ip-api.com/json'))
          .timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String country = data['countryCode']?.toString().toUpperCase() ?? '';
        if (country.isNotEmpty) {
          _cachedCountryCode = country;
          return country;
        }
      }
    } catch (e) {
      print("Fallback IP Geolocation failed: $e");
    }

    return '';
  }
}
