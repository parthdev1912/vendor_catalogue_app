import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/assets/fonts.gen.dart';
import '../../constants/color_constant.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final TextCapitalization? textCapitalization;

  const CustomTextField({
    Key? key,
    this.hintText,
    this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.validator,
    this.inputFormatters,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textCapitalization: textCapitalization!,
        validator: (value) {
          final result = validator?.call(value);
          return result != null ? '' : null;
        },
        style: TextStyle(color: ColorConstant.black,fontFamily: AppFonts.worksans, fontWeight: FontWeight.w500),
        inputFormatters: inputFormatters,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: ColorConstant.textColor,fontWeight: FontWeight.w300,fontFamily: AppFonts.worksans),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          labelText: labelText,
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
            borderSide: const BorderSide(color: ColorConstant.black,width: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          helperText: null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          errorStyle: TextStyle(
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
