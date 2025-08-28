import 'package:vendor_catalogue_app/logic/models/products/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.product,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}