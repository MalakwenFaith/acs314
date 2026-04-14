import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = true;
  bool isCheckingOut = false;
  List<dynamic> cartItems = [];
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';

      final response = await http.get(Uri.parse(
        "http://localhost/flutter_api/get_cart.php?user_email=$email",
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        double total = 0;
        for (var item in data) {
          total += double.parse(item['price'].toString()) *
              int.parse(item['quantity'].toString());
        }
        setState(() {
          cartItems = data;
          totalPrice = total;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        Get.snackbar("Error", "Failed to load cart");
      }
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Network Error", "Could not connect: $e");
    }
  }

  Future<void> removeFromCart(String cartId) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost/flutter_api/remove_from_cart.php"),
        body: {"cart_id": cartId},
      );

      final data = jsonDecode(response.body);
      if (data['success'] == 1) {
        Get.snackbar("Removed", "Item removed from cart",
            snackPosition: SnackPosition.BOTTOM);
        fetchCart(); // refresh cart
      } else {
        Get.snackbar("Error", "Failed to remove item");
      }
    } catch (e) {
      Get.snackbar("Network Error", "Could not connect: $e");
    }
  }

  Future<void> checkout() async {
    if (cartItems.isEmpty) {
      Get.snackbar("Empty Cart", "Add items to cart first");
      return;
    }

    setState(() => isCheckingOut = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';

      final response = await http.post(
        Uri.parse("http://localhost/flutter_api/checkout.php"),
        body: {"user_email": email},
      );

      final data = jsonDecode(response.body);
      if (data['success'] == 1) {
        Get.snackbar(
          "Order Placed! 🎉",
          "Your order has been placed successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchCart(); // cart will now be empty
      } else {
        Get.snackbar("Error", data['message']);
      }
    } catch (e) {
      Get.snackbar("Network Error", "Could not connect: $e");
    } finally {
      setState(() => isCheckingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.pink,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pink))
          : cartItems.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 80, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("Your cart is empty",
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // CART ITEMS LIST
                    Expanded(
                      child: RefreshIndicator(
                        color: Colors.pink,
                        onRefresh: fetchCart,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            final itemTotal =
                                double.parse(item['price'].toString()) *
                                    int.parse(item['quantity'].toString());

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    // IMAGE
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: item['image'] != null &&
                                              item['image'] != ""
                                          ? Image.memory(
                                              base64Decode(item['image']),
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(Icons.image,
                                              size: 70, color: Colors.grey),
                                    ),
                                    const SizedBox(width: 12),

                                    // DETAILS
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "KSh ${item['price']}  x  ${item['quantity']}",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "KSh ${itemTotal.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              color: Colors.pink,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // REMOVE BUTTON
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () =>
                                          removeFromCart(item['id'].toString()),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // TOTAL + CHECKOUT BUTTON
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: .2),
                            blurRadius: 10,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "KSh ${totalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isCheckingOut ? null : checkout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: isCheckingOut
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      "Checkout",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
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
