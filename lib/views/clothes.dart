import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_acs315/controllerss/clothescontroller.dart';

class Clothes extends StatelessWidget {
  const Clothes({super.key});

  @override
  Widget build(BuildContext context) {
    final ClothesController clothesController = Get.put(ClothesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("WELCOME!"),
        backgroundColor: Colors.pink,
      ),
      body: Obx(() {
        if (clothesController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.pink),
          );
        }

        if (clothesController.clothesList.isEmpty) {
          return const Center(
            child: Text(
              "No clothes available",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: clothesController.clothesList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final item = clothesController.clothesList[index];
              return _buildClothesCard(item);
            },
          ),
        );
      }),
    );
  }

  Widget _buildClothesCard(dynamic item) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: item.image.isNotEmpty
                  ? Image.memory(
                      base64Decode(item.image),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.grey),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image_not_supported,
                          size: 50, color: Colors.grey),
                    ),
            ),
          ),

          // DETAILS
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAME
                Text(
                  item.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // PRICE
                Text(
                  "KSh ${item.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),

                // QUANTITY
                Text(
                  item.quantity > 0
                      ? "In Stock: ${item.quantity}"
                      : "Out of Stock",
                  style: TextStyle(
                    color: item.quantity > 0 ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),

                // ADD TO CART BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: item.quantity > 0
                        ? () {
                            Get.snackbar(
                              "Added to Cart",
                              "${item.name} added successfully",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.pink,
                              colorText: Colors.white,
                            );
                            // TODO: cart logic here
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: Text(
                      item.quantity > 0 ? "Add to Cart" : "Out of Stock",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
