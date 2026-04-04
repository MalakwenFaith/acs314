import 'dart:convert';
import 'package:flutter_application_acs315/modelss/clothes_models.dart';
import 'package:http/http.dart' as http;

class ClothesService {
  static const String url =
      'http://10.0.2.2/flutter_api/clothes.php'; // localhost

  static Future<List<Clothes>> fetchClothes() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Clothes.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load clothes');
    }
  }
}
