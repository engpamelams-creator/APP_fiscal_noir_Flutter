import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiscal_noir/core/theme/app_theme.dart';

class NoirInput extends StatelessWidget {
  final String hint;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const NoirInput({
    super.key,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.black,
        border: Border.all(color: AppTheme.white, width: 1),
        borderRadius: BorderRadius.circular(0), // Sharp edges for Noir style
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(color: AppTheme.white),
        cursorColor: AppTheme.white,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: AppTheme.lightGrey),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
