import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool isHomeSearch;
  final String? hintText;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? padding;
  const SearchTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.padding,
    this.hintText,
    this.suffixIcon,
    this.isHomeSearch = false,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.only(left: 30.0, right: 30, top: 16, bottom: 16),
      child: widget.isHomeSearch
          ? Container(
          height: 60,
          decoration: ShapeDecoration(
            color: const Color(0xFFBFC6D6).withOpacity(0.20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(52),
            ),
            // opacity: 0.20,
          ),
          child: Row(
            children: [
              const SizedBox(width: 26),
              const Icon(Icons.search),
              const SizedBox(width: 20),
              Text(
                "Search products",
                style: const TextStyle(
                  color: Color(0XFF12181B),
                  fontSize: 14,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w700,
                ).copyWith(
                  color: const Color(0XFF12181B).withOpacity(0.40),
                ),
              ),
            ],
          ))
          : TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFBFC6D6).withOpacity(0.20),
            contentPadding: const EdgeInsets.all(16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(52.0),
              borderSide: const BorderSide(color: Color(0xFFBFC6D6), width: 2.0),
          ),
          hintText: widget.hintText ?? "searchProducts",
          hintStyle: const TextStyle(
            color:  Colors.black54,
            fontSize: 16,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700).copyWith(
              color: const Color(0XFF12181B).withOpacity(0.40),
          ),
          prefixIcon: const Padding(
            padding:  EdgeInsets.only(
              left: 26.0,
              right: 14,
            ),
            child: Icon(
                Icons.search,
                color: Colors.black,
            ),
          ),
          suffixIcon: widget.suffixIcon,
          prefixIconConstraints: const BoxConstraints(
            maxHeight: 60,
            maxWidth: 60,
          ),
          prefixIconColor: const Color(0xFFBFC6D6).withOpacity(0.20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(52.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(52.0),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: widget.onChanged,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black, // You can customize the text color here.
        ),
      ),
    );
  }
}
