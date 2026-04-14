import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_acs315/controllerss/clothescontroller.dart';

class Clothes extends StatefulWidget {
  const Clothes({super.key});

  @override
  State<Clothes> createState() => _ClothesState();
}

class _ClothesState extends State<Clothes> {
  final ClothesController clothesController = Get.put(ClothesController());
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  String sortOption = 'Default';

  final List<String> sortOptions = [
    'Default',
    'Price: Low to High',
    'Price: High to Low',
    'Name: A to Z',
    'In Stock First',
  ];

  List get filteredList {
    List list = clothesController.clothesList.toList();

    if (searchQuery.isNotEmpty) {
      list = list
          .where((item) =>
              item.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    switch (sortOption) {
      case 'Price: Low to High':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Name: A to Z':
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'In Stock First':
        list.sort((a, b) => b.quantity.compareTo(a.quantity));
        break;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
              child: Row(
                children: [
                  // SEARCH BAR
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search clothes...",
                        hintStyle:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.pink),
                        suffixIcon: searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    searchQuery = '';
                                    searchController.clear();
                                  });
                                },
                                child: const Icon(Icons.clear,
                                    color: Colors.grey, size: 18),
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.pink),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.pink, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.pink.shade100),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // SORT DROPDOWN
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink.shade100),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: sortOption,
                        icon: const Icon(Icons.sort,
                            color: Colors.pink, size: 20),
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87),
                        items: sortOptions.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option,
                                style: const TextStyle(fontSize: 12)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            sortOption = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // RESULTS COUNT
            if (searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
                child: Row(
                  children: [
                    Text(
                      "${filteredList.length} result${filteredList.length == 1 ? '' : 's'} for \"$searchQuery\"",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

            // GRID
            Expanded(
              child: RefreshIndicator(
                color: Colors.pink,
                onRefresh: () async {
                  await clothesController.getClothes();
                },
                child: filteredList.isEmpty
                    ? const Center(
                        child: Text(
                          "No results found",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: GridView.builder(
                          itemCount: filteredList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return _buildClothesCard(item);
                          },
                        ),
                      ),
              ),
            ),
          ],
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

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: item.quantity > 0
                        ? () async {
                            final prefs = await SharedPreferences.getInstance();
                            final email = prefs.getString('email') ?? '';

                            final response = await http.post(
                              Uri.parse(
                                  "http://localhost/flutter_api/add_to_cart.php"),
                              body: {
                                "user_email": email,
                                "clothesid": item.id.toString(),
                                "quantity": "1",
                              },
                            );

                            final data = jsonDecode(response.body);
                            if (data['success'] == 1) {
                              Get.snackbar(
                                "Added to Cart ✅",
                                "${item.name} added successfully",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.pink,
                                colorText: Colors.white,
                              );
                            } else {
                              Get.snackbar("Error", data['message']);
                            }
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
