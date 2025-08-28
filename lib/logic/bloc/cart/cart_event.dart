import 'package:vendor_catalogue_app/logic/models/products/product_model.dart';

abstract class CartEvent {}
class AddToCart extends CartEvent {
  final ProductModel product;
  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final int productId;
  RemoveFromCart(this.productId);
}

class DecreaseQuantity extends CartEvent {
  final int productId;
  DecreaseQuantity(this.productId);
}

class UpdateCartQuantity extends CartEvent {
  final int productId;
  final int quantity;
  UpdateCartQuantity(this.productId, this.quantity);
}

class LoadCart extends CartEvent {}

class ClearCart extends CartEvent {}