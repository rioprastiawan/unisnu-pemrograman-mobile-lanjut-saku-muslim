import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';
import '../models/ayat.dart';

class QuranApiService {
  static const String baseUrl = 'https://equran.id/api/v2';
  
  // Fetch list of all surahs
  Future<List<Surah>> fetchAllSurahs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/surat'),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        
        return data.map((surahJson) => Surah.fromJson(surahJson)).toList();
      } else {
        throw Exception('Gagal memuat data surah: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat mengambil data surah: $e');
    }
  }
  
  // Fetch specific surah with ayat
  Future<SurahDetail> fetchSurahDetail(int nomorSurah) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/surat/$nomorSurah'),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return SurahDetail.fromJson(jsonData['data']);
      } else {
        throw Exception('Gagal memuat detail surah: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat mengambil detail surah: $e');
    }
  }
}
