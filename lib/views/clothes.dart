import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_acs315/modelss/clothes_models.dart';
import 'clothes_service.dart';

class Clothes extends StatefulWidget {
  const Clothes({super.key});

  @override
  State<Clothes> createState() => _ClothesState();
}

class _ClothesState extends State<Clothes> {
  late Future<List<Clothes>> clothesList;

  @override
  void initState() {
    super.initState();
    clothesList = ClothesService.fetchClothes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clothes")),
      body: FutureBuilder<List<Clothes>>(
        future: clothesList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No clothes available'));
          }

          final clothes = snapshot.data!;

          return ListView.builder(
            itemCount: clothes.length,
            itemBuilder: (context, index) {
              final item = clothes[index];
              Uint8List imageBytes = base64Decode(item.image);

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.memory(imageBytes, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Text(
                      'Price: \$${item.price}\nAvailable: ${item.quantity}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      setState(() {
                        if (item.incart < item.quantity) {
                          item.incart++;
                        }
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
