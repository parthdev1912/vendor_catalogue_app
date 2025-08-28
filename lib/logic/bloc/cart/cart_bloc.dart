import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_catalogue_app/logic/bloc/cart/cart_event.dart';
import 'package:vendor_catalogue_app/logic/bloc/cart/cart_state.dart';
import 'package:vendor_catalogue_app/logic/models/carts/cart_item_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<CartItemModel> _cartItems = [];

  CartBloc() : super(CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<DecreaseQuantity>(_onDecreaseQuantity);
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
    on<LoadCart>(_onLoadCart);
    on<ClearCart>(_onClearCart);

    add(LoadCart());
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final existingItemIndex = _cartItems.indexWhere(
          (item) => item.product.id == event.product.id,
    );

    if (existingItemIndex >= 0) {
      _cartItems[existingItemIndex].quantity++;
    } else {
      _cartItems.add(CartItemModel(product: event.product));
    }

    await _saveCartToPrefs();
    emit(CartUpdated(List.from(_cartItems)));
  }

  void _onDecreaseQuantity(DecreaseQuantity event, Emitter<CartState> emit) async {
    final itemIndex = _cartItems.indexWhere(
          (item) => item.product.id == event.productId,
    );

    if (itemIndex >= 0) {
      if (_cartItems[itemIndex].quantity > 1) {
        _cartItems[itemIndex].quantity--;
      } else {
        _cartItems.removeAt(itemIndex);
      }
    }

    await _saveCartToPrefs();
    emit(CartUpdated(List.from(_cartItems)));
  }


  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    _cartItems.removeWhere((item) => item.product.id == event.productId);
    await _saveCartToPrefs();
    emit(CartUpdated(List.from(_cartItems)));
  }

  void _onUpdateCartQuantity(UpdateCartQuantity event, Emitter<CartState> emit) async {
    final itemIndex = _cartItems.indexWhere(
          (item) => item.product.id == event.productId,
    );

    if (itemIndex >= 0) {
      if (event.quantity <= 0) {
        _cartItems.removeAt(itemIndex);
      } else {
        _cartItems[itemIndex].quantity = event.quantity;
      }
    }

    await _saveCartToPrefs();
    emit(CartUpdated(List.from(_cartItems)));
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    await _loadCartFromPrefs();
    emit(CartUpdated(List.from(_cartItems)));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    _cartItems.clear();
    await _saveCartToPrefs();
    emit(CartUpdated(List.from(_cartItems)));
  }

  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _cartItems.map((item) => item.toJson()).toList();
    await prefs.setString('cart_items', json.encode(cartJson));
  }

  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart_items');

    if (cartString != null) {
      final cartJson = json.decode(cartString) as List;
      _cartItems = cartJson.map((item) => CartItemModel.fromJson(item)).toList();
    }
  }

}

