import 'package:vendor_catalogue_app/logic/models/carts/cart_item_model.dart';

abstract class CartState {}
class CartInitial extends CartState {}
class CartUpdated extends CartState {
  final List<CartItemModel> items;
  final int totalItems;
  final double totalPrice;

  CartUpdated(this.items)
      : totalItems = items.fold(0, (sum, item) => sum + item.quantity),
        totalPrice = items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
}