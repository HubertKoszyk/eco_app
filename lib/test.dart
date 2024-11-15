import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchAirQualityData() async {
  String apiKey = 'YOUR_API_KEY';
  String url = 'https://api.openaq.org/v2/measurements?country=PL&limit=1000&order_by=[location,datetime]&sort=desc&api_key=$apiKey';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['results'];
  } else {
    throw Exception('Failed to load air quality data');
  }
}