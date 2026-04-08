class Clothes {
  int id;
  String name;
  String image;
  double price;
  int quantity;
  int incart;

  Clothes({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.incart,
  });

  factory Clothes.fromJson(Map<String, dynamic> json) {
    return Clothes(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      image: json['image'],
      price: double.parse(json['price'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      incart: int.parse(json['incart'].toString()),
    );
  }
}
