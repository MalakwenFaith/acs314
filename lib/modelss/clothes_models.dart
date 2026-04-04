class ClothesModel {
  int id;
  String name;
  String price;
  String imageUrl;
  int quantity;
  bool inCart;

  ClothesModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.inCart,
  });
}
