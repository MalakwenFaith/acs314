import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_acs315/modelss/clothes_models.dart';

class ClothesController extends GetxController {
  var isLoading = true.obs;
  var clothesList = <Clothes>[].obs;

  @override
  void onInit() {
    super.onInit();
    getClothes();
  }

  Future<void> getClothes() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse("http://localhost/flutter_api/clothes.php"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> serverData = jsonDecode(response.body);
        final List<Clothes> fetched =
            serverData.map((item) => Clothes.fromJson(item)).toList();
        clothesList.assignAll(fetched);
      } else {
        Get.snackbar("Error", "Failed to load clothes");
      }
    } catch (e) {
      Get.snackbar("Network Error", "Could not connect: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
