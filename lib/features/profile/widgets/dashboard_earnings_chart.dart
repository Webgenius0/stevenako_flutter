import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardEarningsChart extends StatelessWidget {
  const DashboardEarningsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFA78BFA).withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFA78BFA).withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Earnings · Last 30 days',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9F75FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Views',
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Tips',
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 180.h,
            width: double.infinity,
            child: CustomPaint(painter: EarningsLineChartPainter()),
          ),
        ],
      ),
    );
  }
}

class EarningsLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final Paint gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final Paint purpleLinePaint = Paint()
      ..color = const Color(0xFF9F75FF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final Paint greenLinePaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines and Y-axis labels
    final List<String> yLabels = ['1200', '900', '600', '300', '0'];
    final double stepY = (height - 30.h) / 4;

    for (int i = 0; i < 5; i++) {
      final double y = 10.h + i * stepY;
      canvas.drawLine(Offset(35.w, y), Offset(width, y), gridPaint);

      final TextPainter labelPainter = TextPainter(
        text: TextSpan(
          text: yLabels[i],
          style: GoogleFonts.inter(
            color: Colors.white30,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(canvas, Offset(0, y - 6.h));
    }

    // X-axis labels
    final List<String> xLabels = ['Jun 3', 'Jun 12', 'Jun 21', 'Jun 30'];
    final double startX = 40.w;
    final double endX = width - 10.w;
    final double stepX = (endX - startX) / 3;

    for (int i = 0; i < 4; i++) {
      final double x = startX + i * stepX;
      final TextPainter xLabelPainter = TextPainter(
        text: TextSpan(
          text: xLabels[i],
          style: GoogleFonts.inter(
            color: Colors.white30,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      xLabelPainter.layout();
      xLabelPainter.paint(canvas, Offset(x - 15.w, height - 15.h));
    }

    // Purple Line (Views) - Path
    final Path purplePath = Path();
    final double chartHeight = height - 30.h;
    final double chartY0 = 10.h;

    final List<Offset> purplePoints = [
      Offset(startX, chartY0 + chartHeight * 0.85),
      Offset(startX + stepX * 0.8, chartY0 + chartHeight * 0.70),
      Offset(startX + stepX * 1.5, chartY0 + chartHeight * 0.60),
      Offset(startX + stepX * 2.2, chartY0 + chartHeight * 0.40),
      Offset(startX + stepX * 2.6, chartY0 + chartHeight * 0.50),
      Offset(endX, chartY0 + chartHeight * 0.20),
    ];

    purplePath.moveTo(purplePoints[0].dx, purplePoints[0].dy);
    for (int i = 0; i < purplePoints.length - 1; i++) {
      final p0 = purplePoints[i];
      final p1 = purplePoints[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      purplePath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }
    canvas.drawPath(purplePath, purpleLinePaint);

    // Green Line (Tips) - Path
    final Path greenPath = Path();
    final List<Offset> greenPoints = [
      Offset(startX, chartY0 + chartHeight * 0.95),
      Offset(startX + stepX * 0.8, chartY0 + chartHeight * 0.92),
      Offset(startX + stepX * 1.5, chartY0 + chartHeight * 0.91),
      Offset(startX + stepX * 2.2, chartY0 + chartHeight * 0.90),
      Offset(startX + stepX * 2.6, chartY0 + chartHeight * 0.93),
      Offset(endX, chartY0 + chartHeight * 0.86),
    ];

    greenPath.moveTo(greenPoints[0].dx, greenPoints[0].dy);
    for (int i = 0; i < greenPoints.length - 1; i++) {
      final p0 = greenPoints[i];
      final p1 = greenPoints[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      greenPath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }
    canvas.drawPath(greenPath, greenLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
