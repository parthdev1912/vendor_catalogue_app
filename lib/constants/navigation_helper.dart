import 'package:flutter/material.dart';
import 'package:vendor_catalogue_app/presentation/screens/login/login_screen.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? get context => navigatorKey.currentState?.context;
  static bool _isNavigating = false;


  static void navigateToLoginScreen() {
    if (_isNavigating) {
      return;
    }
    if (navigatorKey.currentState != null && context != null) {
      _navigateNow();
    } else {
    }
  }

  static void _navigateNow() {
    if (_isNavigating) {
      print('NavigationService: Already navigating, skipping');
      return;
    }

    _isNavigating = true;

    try {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
            (route) => false,
      );
    } catch (e) {
    } finally {
      Future.delayed(const Duration(milliseconds: 1000), () {
        _isNavigating = false;
      });
    }
  }

}