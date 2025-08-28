import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendor_catalogue_app/constants/navigation_helper.dart';
import 'package:vendor_catalogue_app/constants/strings.dart';
import 'package:vendor_catalogue_app/constants/theme.dart';
import 'package:vendor_catalogue_app/logic/bloc/cart/cart_bloc.dart';
import 'package:vendor_catalogue_app/logic/bloc/product/product_bloc.dart';
import 'data/services/snackbar_service.dart';
import 'logic/bloc/auth/auth_bloc.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/screens/splash/splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(
                authRepository: context.read<AuthRepository>(),
              ),
        ),
        BlocProvider(
          create: (context) =>
              ProductBloc(
                authRepository: context.read<AuthRepository>(),
              ),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: SnackbarService.scaffoldMessengerKey,
          navigatorKey: NavigationService.navigatorKey,
          title: AppStrings.appName,
          theme: AppTheme.lightTheme,
          key: GlobalObjectKey(this),
          home: SplashScreen(),
        ),
      ),
    );
  }
}

