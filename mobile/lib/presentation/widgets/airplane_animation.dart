import 'package:flutter/material.dart';
import '../../presentation/theme/app_colors.dart';

class AirplaneAnimation extends StatefulWidget {
  final Widget child;

  const AirplaneAnimation({super.key, required this.child});

  @override
  State<AirplaneAnimation> createState() => _AirplaneAnimationState();
}

class _AirplaneAnimationState extends State<AirplaneAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _position;
  late Animation<double> _glowOpacity;
  late Animation<double> _entityScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    _position = Tween<Offset>(
      begin: const Offset(1.0, 0.7),
      end: const Offset(0.5, 0.3),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 1.0, curve: Curves.easeOut),
      ),
    );

    _entityScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.66, 1.0),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Airplane
            Positioned(
              left: _position.value.dx * size.width,
              top: _position.value.dy * size.height,
              child: const Icon(Icons.airplanemode_active, size: 48, color: AppColors.earthBrown),
            ),
            // Entity + Glow
            Transform.scale(
              scale: _entityScale.value,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: _glowOpacity.value > 0
                      ? [
                          BoxShadow(
                             color: AppColors.sunnyYellow
                                 .withValues(alpha: _glowOpacity.value),
                            blurRadius: 50,
                            spreadRadius: 20,
                          ),
                        ]
                      : [],
                ),
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );
  }
}
