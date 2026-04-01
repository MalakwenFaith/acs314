import 'package:flutter/material.dart';

class Clothes extends StatelessWidget {
  const Clothes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clothes"),
        backgroundColor: Colors.pink,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // RED DRESS
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/red dress.png",
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " Dress",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Ksh 2500"),
                  ],
                )
              ],
            ),
          ),

          // JACKET
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/jacket.png",
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Leather Jacket",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Ksh 5000"),
                  ],
                )
              ],
            ),
          ),

          // CORSET
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/corset.png",
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Corset",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Ksh 2000"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
