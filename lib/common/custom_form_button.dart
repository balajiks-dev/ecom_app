import 'package:flutter/material.dart';
import 'package:sample_ecommerce/constants/app_colors.dart';


class CustomFormButton extends StatelessWidget {
  final String innerText;
  final void Function()? onPressed;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  const CustomFormButton({
    super.key,
    required this.innerText,
    required this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: width ?? size.width * 0.8,
      height: height ?? 60,
      decoration: BoxDecoration(
        color: AppColors.secondary1Color,
        borderRadius: BorderRadius.circular(borderRadius ?? 26),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          innerText,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize ?? 20,
          ),
        ),
      ),
    );
  }
}
