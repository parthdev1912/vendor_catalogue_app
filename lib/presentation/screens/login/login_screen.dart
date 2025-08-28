import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendor_catalogue_app/config/assets/assets.gen.dart';
import 'package:vendor_catalogue_app/config/assets/fonts.gen.dart';
import 'package:vendor_catalogue_app/constants/color_constant.dart';
import 'package:vendor_catalogue_app/constants/strings.dart';
import 'package:vendor_catalogue_app/logic/bloc/auth/auth_event.dart';
import 'package:vendor_catalogue_app/presentation/screens/home/home_screen.dart';
import 'package:vendor_catalogue_app/presentation/widgets/custom_password_textfield.dart';
import 'package:vendor_catalogue_app/presentation/widgets/custom_textfield.dart';
import '../../../logic/bloc/auth/auth_bloc.dart';
import '../../../logic/bloc/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppAssets.appLogo.appLogo.image(height: 150, width: 150),
                SizedBox(height: 25.h),
                CustomTextField(
                  labelText: AppStrings.userName,
                  controller: _usernameController,
                  prefixIcon: Icon(Icons.person),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return ' ';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                CustomPasswordTextField(
                  labelText: AppStrings.passWorld,
                  controller: _passwordController,
                  prefixIcon: Icon(Icons.lock),
                  isPassword: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return ' ';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            FocusScope.of(context).unfocus();
                            context.read<AuthBloc>().add(
                              LoginRequested(
                                _usernameController.text,
                                _passwordController.text,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50.h),
                          shadowColor: Colors.transparent,
                          backgroundColor: ColorConstant.primary,
                          disabledBackgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: state is AuthLoading
                            ? CircularProgressIndicator(color: ColorConstant.primary)
                            : Text(
                          AppStrings.login,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: AppFonts.worksans,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.white
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}