import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doa.dart';

class DoaService {
  static const String baseUrl = 'https://equran.id/api';
  
  // Fetch all doa
  Future<List<Doa>> fetchAllDoa() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/doa'),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        if (jsonData['status'] == 'success') {
          final List<dynamic> data = jsonData['data'];
          return data.map((doaJson) => Doa.fromJson(doaJson)).toList();
        } else {
          throw Exception('Status tidak success');
        }
      } else {
        throw Exception('Gagal memuat data doa: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat mengambil data doa: $e');
    }
  }
  
  // Get doa by group
  Future<List<Doa>> fetchDoaByGroup(String group) async {
    final allDoa = await fetchAllDoa();
    return allDoa.where((doa) => doa.grup == group).toList();
  }
  
  // Get unique groups
  Future<List<String>> fetchDoaGroups() async {
    final allDoa = await fetchAllDoa();
    final groups = allDoa.map((doa) => doa.grup).toSet().toList();
    groups.sort();
    return groups;
  }
  
  // Search doa by name or translation
  Future<List<Doa>> searchDoa(String query) async {
    final allDoa = await fetchAllDoa();
    final lowerQuery = query.toLowerCase();
    
    return allDoa.where((doa) {
      return doa.nama.toLowerCase().contains(lowerQuery) ||
             doa.idn.toLowerCase().contains(lowerQuery) ||
             doa.grup.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
