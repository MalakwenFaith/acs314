import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllerss/clothescontroller.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    final ClothesController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.pink,
      ),
      body: Obx(() {
        // FILTER ITEMS THAT ARE IN CART
        final cartItems =
            controller.clothesList.where((item) => item.incart > 0).toList();

        if (cartItems.isEmpty) {
          return const Center(
            child: Text(
              "Your cart is empty",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // CALCULATE TOTAL PRICE
        double total =
            cartItems.fold(0, (sum, item) => sum + (item.price * item.incart));

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];

                  return ListTile(
                    leading: item.image.isNotEmpty
                        ? Image.memory(
                            base64Decode(item.image),
                            width: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image),
                    title: Text(item.name),
                    subtitle: Text(
                        "KSh ${item.price} x ${item.incart} = ${item.price * item.incart}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // DECREASE
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (item.incart > 0) {
                              item.incart--;
                              controller.update();
                            }
                          },
                        ),

                        Text(item.incart.toString()),

                        // INCREASE
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (item.incart < item.quantity) {
                              item.incart++;
                              controller.update();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // TOTAL + CHECKOUT
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "KSh ${total.toStringAsFixed(2)}",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.pink),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.snackbar(
                          "Success",
                          "Order placed successfully!",
                          backgroundColor: Colors.pink,
                          colorText: Colors.white,
                        );

                        // CLEAR CART AFTER CHECKOUT
                        for (var item in cartItems) {
                          item.incart = 0;
                        }
                        controller.update();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      child: const Text("Checkout"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
