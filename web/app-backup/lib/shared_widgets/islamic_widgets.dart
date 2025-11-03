import 'package:flutter/material.dart';
import '../app/config/app_config.dart';

/// Custom loading indicator with Islamic design
class IslamicLoadingIndicator extends StatefulWidget {
  const IslamicLoadingIndicator({
    super.key,
    this.size = 32.0,
    this.strokeWidth = 3.0,
    this.color,
  });

  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  State<IslamicLoadingIndicator> createState() =>
      _IslamicLoadingIndicatorState();
}

class _IslamicLoadingIndicatorState extends State<IslamicLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor =
        widget.color ??
        (isDark ? AppColors.primaryGreenLight : AppColors.primaryGreen);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _IslamicLoadingPainter(
              animation: _controller.value,
              color: effectiveColor,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _IslamicLoadingPainter extends CustomPainter {
  final double animation;
  final Color color;
  final double strokeWidth;

  _IslamicLoadingPainter({
    required this.animation,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    // Create paint
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    // Draw rotating arcs to create Islamic pattern
    const int arcCount = 8;
    const double arcLength = 0.8; // Length of each arc in radians

    for (int i = 0; i < arcCount; i++) {
      final double startAngle =
          (i * 2 * 3.14159 / arcCount) + (animation * 2 * 3.14159);
      final double opacity = (i + 1) / arcCount;

      paint.color = color.withValues(alpha: opacity * 0.8);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        arcLength,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Islamic-themed app logo widget
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 64.0, this.showShadow = true});

  final double size;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color:
            isDark ? AppColors.primaryGreenMediumDark : AppColors.primaryGreen,
        shape: BoxShape.circle,
        boxShadow:
            showShadow
                ? [
                  BoxShadow(
                    color: (isDark
                            ? AppColors.primaryGreenDark
                            : AppColors.primaryGreen)
                        .withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
                : null,
      ),
      child: Icon(
        Icons.mosque_outlined,
        size: size * 0.5,
        color: AppColors.textOnPrimary,
      ),
    );
  }
}

/// Animated text widget for app name
class AnimatedAppName extends StatelessWidget {
  const AnimatedAppName({
    super.key,
    required this.animation,
    this.fontSize = 32.0,
  });

  final Animation<double> animation;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Text(
            AppConstants.appName,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              letterSpacing: 1.2,
            ),
          ),
        );
      },
    );
  }
}

/// Islamic phrase widget (بسم الله)
class IslamicPhrase extends StatelessWidget {
  const IslamicPhrase({
    super.key,
    this.text = 'بِسْمِ اللَّهِ',
    this.fontSize = 18.0,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.accentGoldDark : AppColors.accentGold,
        fontFamily: 'serif', // Better for Arabic text
      ),
    );
  }
}
