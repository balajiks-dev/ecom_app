import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sample_ecommerce/constants/app_colors.dart';


/// Thin, the least thick - 100
/// Extra-light - 200
/// Light - 300
/// Normal / regular / plain - 400
/// Medium - 500
/// Semi-bold - 600
/// Bold - 700
/// Extra-bold - 800
/// Black, the most thick - 900

class TextStyles {
  static TextStyle whiteMedium14 = GoogleFonts.inter(
    color: AppColors.whiteColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle blackRegular14 = GoogleFonts.inter(
    color: AppColors.blackColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle whiteRegular14 = GoogleFonts.inter(
    color: AppColors.whiteColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
