import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class CustomWormEffect extends WormEffect {
  final Color activeDotBorderColor;
  final double activeDotBorderWidth;

  CustomWormEffect({
    this.activeDotBorderColor = Colors.blue,
    this.activeDotBorderWidth = 2.0,
    double dotWidth = 10.0,
    double dotHeight = 10.0,
    double spacing = 16.0,
    Color dotColor = Colors.grey, // Background color for inactive dots
    Color activeDotColor = Colors.blue, required PageController controller,
  }) : super(
    dotWidth: dotWidth,
    dotHeight: dotHeight,
    spacing: spacing,
    dotColor: dotColor,
    activeDotColor: activeDotColor,
  );

  @override
  void paint(Canvas canvas, Size size, int count, double progress) {
    final activeDotPaint = Paint()..color = activeDotColor;
    final dotPaint = Paint()..color = dotColor;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = activeDotBorderWidth;

    for (int i = 0; i < count; i++) {
      final xPos = i * (dotWidth + spacing);
      final isActive = (i == progress.floor() || i == progress.ceil());

      final dotRect = Rect.fromLTWH(
        xPos,
        0,
        dotWidth,
        dotHeight,
      );

      final rrect = RRect.fromRectAndRadius(
        dotRect,
        Radius.circular(dotWidth / 2),
      );

      if (isActive) {
        // Draw the active dot background
        canvas.drawRRect(rrect, activeDotPaint);

        // Draw the active dot border
        borderPaint.color = activeDotBorderColor;
        canvas.drawRRect(rrect, borderPaint);
      } else {
        // Draw the inactive dot background
        canvas.drawRRect(rrect, dotPaint);

        // Draw the inactive dot border
        borderPaint.color = dotColor;
        canvas.drawRRect(rrect, borderPaint);
      }
    }
  }
}
