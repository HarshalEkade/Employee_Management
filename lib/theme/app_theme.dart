import 'package:flutter/material.dart';

class AppPalette {
  static const Color deepNavy = Color(0xFF0A0C23);
  static const Color panelNavy = Color(0xFF13173B);
  static const Color cardNavy = Color(0xFF1B1F45);
  static const Color accentPink = Color(0xFFFF5C8D);
  static const Color accentGreen = Color(0xFF3FE884);
  static const Color accentBlue = Color(0xFF3DA6FF);
  static const Color accentPurple = Color(0xFF6B5BFF);
  static const Color accentCyan = Color(0xFF24D6FF);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFCFD5FF);
  static const Color divider = Color(0xFF1F2448);

  static const Gradient headerGradient = LinearGradient(
    colors: [Color(0xFF111437), Color(0xFF0E112E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient cardGradient = LinearGradient(
    colors: [Color(0xFF1D2046), Color(0xFF141736)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient primaryBar = LinearGradient(
    colors: [Color(0xFF1EC8FF), Color(0xFF2F68FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Gradient successBar = LinearGradient(
    colors: [Color(0xFF42F884), Color(0xFF1DAA55)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Gradient dangerBar = LinearGradient(
    colors: [Color(0xFFFF6E9D), Color(0xFFEB3468)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.text,
    this.onTap,
    this.gradient = AppPalette.primaryBar,
    this.height = 46,
  });

  final String text;
  final VoidCallback? onTap;
  final Gradient gradient;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

