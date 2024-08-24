import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample_ecommerce/constants/styles.dart';

import '../../utils/remove_emoji_input_formatter.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isMandatory;
  final bool isPassword;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Color? backgroundColor;
  final Color? labelColor;
  final Color? suffixIconColor;
  final int? maxLength;
  final Widget? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.inputFormatters,
    this.isMandatory = false,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.backgroundColor,
    this.labelColor,
    this.suffixIconColor,
    this.maxLength,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;
  bool _isFocused = false;
  late List<TextInputFormatter> _inputFormatters;

  @override
  void initState() {
    super.initState();
    (_inputFormatters = widget.inputFormatters ?? []).add(RemoveEmojiInputFormatter());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Focus(
        onFocusChange: (focused) {
          setState(() {
            _isFocused = focused;
          });
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(10.0), // Border radius
            border: Border.all(
              color: Colors.black12
            )
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 0, left: widget.prefixIcon != null ? 0 : 10, top: 0),
            child: TextFormField(
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              obscuringCharacter: '*',
              maxLength: widget.maxLength,
              controller: widget.controller,
              cursorColor: widget.labelColor ?? Colors.black,
              keyboardType: widget.keyboardType,
              autocorrect: false,
              style: TextStyles.whiteMedium14.copyWith(
                color: widget.labelColor ?? Colors.black,
              ),
              obscureText: widget.isPassword ? !_obscureText : false,
              inputFormatters: _inputFormatters,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
                suffixIconConstraints: const BoxConstraints(
                  maxHeight: 32,
                  minHeight: 20,
                ),
                prefixIcon: widget.prefixIcon,
                prefixIconConstraints: const BoxConstraints(
                  maxHeight: 32,
                  minHeight: 20,
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                  onPressed: () {
                    _obscureText = !_obscureText;
                    setState(() {});
                  },
                  icon: Icon(
                    _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: widget.suffixIconColor ?? Colors.white,
                    size: 18,
                  ),
                )
                    : null,
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: TextStyles.blackRegular14.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: widget.labelColor ?? Colors.black.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
