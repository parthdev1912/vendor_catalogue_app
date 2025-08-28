import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vendor_catalogue_app/config/assets/fonts.gen.dart';
import 'package:vendor_catalogue_app/constants/color_constant.dart';
import 'package:vendor_catalogue_app/constants/strings.dart';
import 'package:vendor_catalogue_app/logic/bloc/auth/auth_bloc.dart';
import 'package:vendor_catalogue_app/logic/bloc/auth/auth_event.dart';
import 'package:vendor_catalogue_app/logic/bloc/cart/cart_bloc.dart';
import 'package:vendor_catalogue_app/logic/bloc/cart/cart_event.dart';
import 'package:vendor_catalogue_app/logic/bloc/cart/cart_state.dart';
import 'package:vendor_catalogue_app/logic/bloc/product/product_bloc.dart';
import 'package:vendor_catalogue_app/logic/bloc/product/product_event.dart';
import 'package:vendor_catalogue_app/logic/bloc/product/product_state.dart';
import 'package:vendor_catalogue_app/logic/models/products/product_model.dart';
import 'package:vendor_catalogue_app/presentation/screens/cart/cart_screen.dart';
import 'package:vendor_catalogue_app/presentation/screens/login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isConnected = true;
  bool _wasDisconnected = false;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    context.read<ProductBloc>().add(FetchProducts());
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    final result = connectivityResults.firstOrNull ?? ConnectivityResult.none;
    _updateConnectionStatus(result);

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((results) {
      final isConnected = results.any((r) => r != ConnectivityResult.none);
      _updateConnectionStatus(isConnected ? ConnectivityResult.wifi : ConnectivityResult.none);
    });
  }


  void _updateConnectionStatus(ConnectivityResult result) {
    final bool isConnected = result != ConnectivityResult.none;

    if (mounted) {
      setState(() {
        if (!_isConnected && isConnected && _wasDisconnected) {
          Future.delayed(Duration(milliseconds: 200), () {
            if (mounted) {
              context.read<ProductBloc>().add(FetchProducts());
              _showConnectionRestoredSnackbar();
            }
          });
          _wasDisconnected = false;
        } else if (_isConnected && !isConnected) {
          _wasDisconnected = true;
        }
        _isConnected = isConnected;
      });
    }
  }

  void _showConnectionRestoredSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.wifi,
              color: Colors.white,
              size: 20.h,
            ),
            SizedBox(width: 12.w),
            Text(
              AppStrings.internetConnectionRestored,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 52.h,
        backgroundColor: ColorConstant.primary,
        centerTitle: true,
        title: Text(
          AppStrings.appName,
          style: TextStyle(
            fontFamily: AppFonts.worksans,
            fontSize: 16.sp,
            color: ColorConstant.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                int itemCount = 0;
                if (state is CartUpdated) {
                  itemCount = state.totalItems;
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    );
                  },
                  child: Container(
                    width: 48.w,
                    height: 48.h,
                    margin: EdgeInsets.only(right: 4.w),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 24.h,
                        ),
                        if (itemCount > 0)
                          Positioned(
                            right: 6.w,
                            top: 6.h,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16.w,
                                minHeight: 16.h,
                              ),
                              child: Text(
                                '$itemCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () {
                context.read<AuthBloc>().add(LogoutRequested());
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Container(
                width: 48.w,
                height: 48.h,
                margin: EdgeInsets.only(right: 6.w),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 24.h,
                ),
              ),
            ),
          ]
      ),
      body: SafeArea(
        child: BlocBuilder<ProductBloc,ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return _buildShimmerList();
            } else if (state is ProductSuccess) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProductBloc>().add(RefreshProducts());
                },
                child: _buildProductList(state.products),
              );
            } else if (state is ProductError) {
              // Check if it's a no internet error
              if (state.message == 'NO_INTERNET_CONNECTION' || !_isConnected) {
                return _buildNoInternetWidget();
              } else {
                return _buildErrorWidget(state.message);
              }
            }
            return Center(child: CircularProgressIndicator(color: ColorConstant.primary));
          },
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Container(
                width: 60.w,
                height: 60.h,
                color: Colors.white,
              ),
              title: Container(
                height: 16.h,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 12.h,
                color: Colors.white,
                margin: EdgeInsets.only(top: 4.h),
              ),
              trailing: Container(
                width: 80.w,
                height: 30.h,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductList(List<ProductModel> products) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            int quantity = 0;
            if (cartState is CartUpdated) {
              final matchingItems = cartState.items.where(
                    (item) => item.product.id == product.id,
              );
              if (matchingItems.isNotEmpty) {
                quantity = matchingItems.first.quantity;
              }
            }

            return Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: ColorConstant.primary,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        imageUrl: product.thumbnail,
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
                                  text: product.title,
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
                                height: 24.h,
                                child: textFits
                                    ? Text(
                                  product.title,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    height: 1.3.sp,
                                    color: ColorConstant.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                                    : Marquee(
                                  text: product.title,
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
                               "\₹ ${product.price.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstant.primary,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  product.category.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                    letterSpacing: 0.5.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber[600],
                                    size: 16.h,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${product.rating}',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              quantity > 0
                                  ? _buildQuantityControls(product, quantity)
                                  : _buildAddButton(product),
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
      },
    );
  }

  Widget _buildAddButton(ProductModel product) {
    return Container(
      height: 30.h,
      child: ElevatedButton(
        onPressed: () {
          context.read<CartBloc>().add(AddToCart(product));
          _showAddedToCartSnackbar(product);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          AppStrings.add,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls(ProductModel product, int quantity) {
    return Container(
      height: 30.h,
      decoration: BoxDecoration(
        color: ColorConstant.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: ColorConstant.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onTap: () {
              context.read<CartBloc>().add(DecreaseQuantity(product.id));
            },
          ),
          Container(
            constraints: BoxConstraints(minWidth: 30.w),
            child: Text(
              '$quantity',
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
              context.read<CartBloc>().add(AddToCart(product));
            },
          ),
        ],
      ),
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

  void _showAddedToCartSnackbar(ProductModel product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20.h,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                '${product.title} added to cart',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildNoInternetWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 80.h,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20.h),
          Text(
            AppStrings.noInternetConnection,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              AppStrings.checkInternetConnection,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(height: 30.h),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProductBloc>().add(FetchProducts());
            },
            icon: Icon(Icons.refresh),
            label: Text(AppStrings.tryAgain),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80.h,
            color: Colors.red,
          ),
          SizedBox(height: 20.h),
          Text(
            AppStrings.errorMessage,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(FetchProducts());
            },
            child: Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}