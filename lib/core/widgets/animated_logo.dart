import 'package:flutter/material.dart';
import 'package:tube_filter/core/constants/app_colors.dart';
import 'dart:math' as math;

class AnimatedLogo extends StatefulWidget {
  final double size;
  final bool animate;
  
  const AnimatedLogo({
    super.key, 
    this.size = 100,
    this.animate = true,
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _LiquidLogoPainter(_controller.value),
          );
        },
      ),
    );
  }
}

class _LiquidLogoPainter extends CustomPainter {
  final double animationValue;
  
  _LiquidLogoPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Define the Logo Shape (Rounded Play Button / Funnel)
    final path = Path();
    final iconSize = radius * 0.8;
    
    // Draw a rounded triangle pointing right (Play)
    // Adjusted to look slightly like a funnel (wider base?)
    // Let's stick to a clean rounded play button for recognition
    path.moveTo(center.dx - iconSize * 0.3, center.dy - iconSize * 0.6); // Top Left
    path.lineTo(center.dx + iconSize * 0.7, center.dy);                  // Tip
    path.lineTo(center.dx - iconSize * 0.3, center.dy + iconSize * 0.6); // Bottom Left
    path.close();

    // 1. Draw Container Outline
    final outlinePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path, outlinePaint);

    // 2. Clip to the shape for the liquid
    canvas.save();
    canvas.clipPath(path);

    // 3. Draw Liquid
    // The liquid level goes up and down or stays full?
    // Let's make it fill up continuously: 0 -> 100% then reset
    // Or just wave at 60%?
    // User wants "Liquid Filter", so filling up implies "Filtering".
    // Let's do a continuous loop: Fill from empty to full.
    
    final fillLevel = animationValue; // 0.0 to 1.0

    final liquidPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    
    final waterPath = Path();
    
    // Wave parameters
    final waveHeight = radius * 0.1;
    final waveLength = size.width;
    
    waterPath.moveTo(0, size.height); // Bottom left

    // Draw sine wave across the top of the liquid
    // y = baseHeight + sin(x)
    final baseHeight = size.height * (1 - fillLevel);

    for (double i = 0; i <= size.width; i++) {
        // Simple wave moving right
        double offset = (animationValue * 2 * math.pi) + (i / waveLength * 2 * math.pi);
        double y = baseHeight + math.sin(offset) * waveHeight;
        
        if (i == 0) {
            waterPath.lineTo(i, y);
        } else {
            waterPath.lineTo(i, y);
        }
    }

    waterPath.lineTo(size.width, size.height); // Bottom right
    waterPath.lineTo(0, size.height); // Close
    waterPath.close();

    canvas.drawPath(waterPath, liquidPaint);

    // 4. Draw Bubbles (Optional "Fizz")
    final bubblePaint = Paint()
      ..color = Colors.white.withAlpha(100)
      ..style = PaintingStyle.fill;
    
    // deterministically pseudorandom bubbles based on animationValue
    for(int i=0; i<5; i++) {
        double bubbleX = (size.width * ((i * 0.2 + animationValue) % 1.0)); 
        double bubbleY = size.height - (size.height * ((i * 0.3 + animationValue * 2) % 1.0));
        
        // Only draw if within the liquid (roughly)
        if (bubbleY > baseHeight) {
             canvas.drawCircle(Offset(bubbleX, bubbleY), radius * 0.05, bubblePaint);
        }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_LiquidLogoPainter oldDelegate) => true;
}
