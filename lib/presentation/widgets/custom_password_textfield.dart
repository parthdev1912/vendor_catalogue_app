import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendor_catalogue_app/config/assets/fonts.gen.dart';
import 'package:vendor_catalogue_app/constants/color_constant.dart';

class CustomPasswordTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final TextCapitalization? textCapitalization;

  const CustomPasswordTextField({
    Key? key,
    this.hintText,
    this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.isPassword = false,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.prefixIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomPasswordTextField> createState() => _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscureText : false,
        textCapitalization: widget.textCapitalization!,
        validator: (value) {
          final result = widget.validator?.call(value);
          return result != null ? '' : null;
        },
        style: TextStyle(
          color: ColorConstant.black,
          fontFamily: AppFonts.worksans,
          fontWeight: FontWeight.w500,
        ),
        inputFormatters: widget.inputFormatters,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: ColorConstant.textColor,
            fontWeight: FontWeight.w300,
            fontFamily: AppFonts.worksans,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: ColorConstant.black,
            ),
            onPressed: _toggleVisibility,
          )
              : null,
          prefixIcon: widget.prefixIcon,
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: ColorConstant.textColor),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstant.textColor, width: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstant.textColor, width: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstant.black, width: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          helperText: null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          errorStyle: const TextStyle(
            color: Colors.transparent,
            fontSize: 0,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade900, width: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
