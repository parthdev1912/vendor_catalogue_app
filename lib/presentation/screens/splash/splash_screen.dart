import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vendor_catalogue_app/config/assets/assets.gen.dart';
import 'package:vendor_catalogue_app/constants/preference_helper.dart';
import 'package:vendor_catalogue_app/constants/preference_key.dart';
import 'package:vendor_catalogue_app/presentation/screens/home/home_screen.dart';
import 'package:vendor_catalogue_app/presentation/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    Timer(const Duration(seconds: 4), () {
      String _isAccessToken = PreferenceHelper.getStringPrefValue(key: SharedPreferencesConstants.accessToken) ?? '';
      if(_isAccessToken.isEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _animation,
                  child: ScaleTransition(
                    scale: _animation,
                    child: Center(
                      child: AppAssets.appLogo.appLogo.image(height: 150, width: 150),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
