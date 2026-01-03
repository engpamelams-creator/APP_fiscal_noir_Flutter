import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fiscal_noir/core/theme/app_theme.dart';

class NoirButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const NoirButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.white,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: AppTheme.black,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  label.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: AppTheme.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
        ),
      ),
    );
  }
}
