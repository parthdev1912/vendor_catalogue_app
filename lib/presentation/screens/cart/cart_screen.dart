import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';
import 'package:vendor_catalogue_app/config/assets/fonts.gen.dart';
import 'package:vendor_catalogue_app/constants/color_constant.dart';
import 'package:vendor_catalogue_app/constants/strings.dart';
import 'package:vendor_catalogue_app/logic/bloc/cart/cart_bloc.dart';
import 'package:vendor_catalogue_app/logic/bloc/cart/cart_event.dart';
import 'package:vendor_catalogue_app/logic/bloc/cart/cart_state.dart';
import 'package:vendor_catalogue_app/logic/models/carts/cart_item_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.064,
        backgroundColor: ColorConstant.primary,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppStrings.shoppingCart,
          style: TextStyle(
            fontFamily: AppFonts.worksans,
            fontSize: 16,
            color: ColorConstant.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartUpdated && state.items.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    _showClearCartDialog(context);
                  },
                  child: Text(
                    AppStrings.clearAll,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartUpdated) {
              if (state.items.isEmpty) {
                return _buildEmptyCart(context);
              }
              return Column(
                children: [
                  Expanded(
                    child: _buildCartList(state.items),
                  ),
                  _buildCartSummary(state, context),
                ],
              );
            }
            return Center(child: CircularProgressIndicator(color: ColorConstant.primary));
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            AppStrings.cartEmptyMes,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            AppStrings.addProductMes,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.primary,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              AppStrings.continueShopping,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(List<CartItemModel> items) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorConstant.primary,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 90.w,
                height: 90.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: item.product.thumbnail,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.grey[400],
                        size: 24.h,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey[400],
                        size: 24.h,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: SizedBox(
                  height: 90.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final textPainter = TextPainter(
                            text: TextSpan(
                              text: item.product.title,
                              style: TextStyle(
                                fontSize: 16.sp,
                                height: 1.3.sp,
                                color: ColorConstant.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            maxLines: 1,
                            textDirection: TextDirection.ltr,
                          )..layout();

                          final textFits = textPainter.width <= constraints.maxWidth;

                          return Container(
                            height: 15.h,
                            child: textFits
                                ? Text(
                              item.product.title,
                              style: TextStyle(
                                fontSize: 16.sp,
                                height: 1.3.sp,
                                color: ColorConstant.black,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                                : Marquee(
                              text: item.product.title,
                              style: TextStyle(
                                fontSize: 16.sp,
                                height: 1.3.sp,
                                color: ColorConstant.black,
                                fontWeight: FontWeight.w600,
                              ),
                              blankSpace: 10.0,
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              pauseAfterRound: Duration(seconds: 3),
                              accelerationDuration: Duration(seconds: 2),
                              accelerationCurve: Curves.linear,
                              decelerationDuration: Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Item Price: \₹ ${item.product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Item Qty: ${item.quantity}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.totalPrice,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.primary,
                            ),
                          ),
                          Text(
                            '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: ColorConstant.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showRemoveItemDialog(context, item);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                AppStrings.removeItem,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: ColorConstant.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: ColorConstant.primary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildQuantityButton(
                                  icon: Icons.remove,
                                  onTap: () {
                                    context.read<CartBloc>().add(DecreaseQuantity(item.product.id));
                                  },
                                ),
                                Container(
                                  constraints: BoxConstraints(minWidth: 30.w),
                                  child: Text(
                                    '${item.quantity}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: ColorConstant.primary,
                                    ),
                                  ),
                                ),
                                _buildQuantityButton(
                                  icon: Icons.add,
                                  onTap: () {
                                    context.read<CartBloc>().add(AddToCart(item.product));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.h,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: ColorConstant.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 16.h,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCartSummary(CartUpdated state, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.totalItems,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '${state.totalItems}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.totalAmt,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '\$${state.totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRemoveItemDialog(BuildContext context, CartItemModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppStrings.removeItem),
          content: Text('Are you sure you want to remove "${item.product.title}" from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<CartBloc>().add(RemoveFromCart(item.product.id));
                Navigator.of(context).pop();
              },
              child: Text(
                AppStrings.remove,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppStrings.clearCart),
          content: Text(AppStrings.clearCartMes),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<CartBloc>().add(ClearCart());
                Navigator.of(context).pop();
              },
              child: Text(
                AppStrings.clearAll,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

}
