import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';
import '../models/holiday.dart';

class ApiService {
  static const String baseUrl = 'https://date.nager.at/api/v3';

  // Obtiene el listado de países disponibles
  static Future<List<Country>> fetchAvailableCountries() async {
    final response = await http.get(Uri.parse('$baseUrl/AvailableCountries'));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Country.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar la lista de países');
    }
  }

  // Obtiene las próximas festividades del país seleccionado
  static Future<List<Holiday>> fetchNextPublicHolidays(String countryCode) async {
    final response = await http.get(Uri.parse('$baseUrl/NextPublicHolidays/$countryCode'));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Holiday.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar las festividades');
    }
  }
}