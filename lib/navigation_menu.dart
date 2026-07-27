
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'features/home/presentation/home_screen.dart';
import 'features/explore/presentation/explore_screen.dart';
import 'features/home/presentation/upload_post_screen.dart';
import 'features/home/presentation/video_upload_screen.dart';
import 'features/message/presentation/message_screen.dart';
import 'features/profile/presentation/profile_screen.dart';

// Bouncy Tactile Floating Action Button
class TactileFAB extends StatefulWidget {
  final bool isMenuOpen;
  final VoidCallback onTap;

  const TactileFAB({
    super.key,
    required this.isMenuOpen,
    required this.onTap,
  });

  @override
  State<TactileFAB> createState() => _TactileFABState();
}

class _TactileFABState extends State<TactileFAB> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF9F75FF), // Lighter purple
                Color(0xFF7C3AED), // Rich purple
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutBack,
            turns: widget.isMenuOpen ? 0.375 : 0.0, // Rotate + 135 degrees to form x
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// NavigationMenu — The main screen with tab switching and FAB menu
// ============================================================
class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _currentIndex = 0;
  bool _isMenuOpen = false;

  final List<Widget> screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const MessageScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _isMenuOpen = false;
    });
  }

  void _onFABTapped() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  // Centralized helper: closes the menu, then runs whatever action was passed in.
  void _closeMenuThen(VoidCallback action) {
    setState(() {
      _isMenuOpen = false;
    });
    action();
  }

  Widget _buildMenuButton(IconData icon, String text) {

    return Container(
      width: 220,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 14),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E1B2E),
                  Color(0xFF0F0E17),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
          ),
          // Backdrop blur/dim when FAB menu is open
          IgnorePointer(
            ignoring: !_isMenuOpen,
            child: AnimatedOpacity(
              opacity: _isMenuOpen ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isMenuOpen = false;
                  });
                },
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Staggered menu popup buttons above the FAB
          Positioned(
            bottom: bottomPadding + 112.0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !_isMenuOpen,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StaggeredMenuItem(
                    isVisible: _isMenuOpen,
                    delay: const Duration(milliseconds: 160),
                    onTap: () {
                      _closeMenuThen(() {
                        Get.to(() => const VideoUploadScreen());
                      });
                    },
                    child: _buildMenuButton(
                        Icons.videocam_outlined, 'Upload Video'),
                  ),
                  const SizedBox(height: 12),
                  StaggeredMenuItem(
                    isVisible: _isMenuOpen,
                    delay: const Duration(milliseconds: 80),
                    onTap: () {
                      _closeMenuThen(() {
                        Get.to(UploadPostScreen());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Upload Photos tapped!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        // TODO: hook up real photo upload navigation here
                      });
                    },
                    child: _buildMenuButton(Icons.upload, 'Upload Photos'),
                  ),
                  const SizedBox(height: 12),
                  StaggeredMenuItem(
                    isVisible: _isMenuOpen,
                    delay: const Duration(milliseconds: 0),
                    onTap: () {
                      // Get.to(UploadPostScreen());
                      _closeMenuThen(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Create a Post tapped!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        // TODO: hook up real "create post" navigation here
                      });
                    },
                    child:
                    _buildMenuButton(Icons.bookmark_border, 'Create a Post'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        isMenuOpen: _isMenuOpen,
        onTap: _onTabTapped,
        onFABTap: _onFABTapped,
      ),
    );
  }
}

// Staggered Animation Wrapper for popup menu items
class StaggeredMenuItem extends StatefulWidget {
  final bool isVisible;
  final Duration delay;
  final Widget child;
  final VoidCallback onTap;

  const StaggeredMenuItem({
    super.key,
    required this.isVisible,
    required this.delay,
    required this.child,
    required this.onTap,
  });

  @override
  State<StaggeredMenuItem> createState() => _StaggeredMenuItemState();
}

class _StaggeredMenuItemState extends State<StaggeredMenuItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    if (widget.isVisible) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant StaggeredMenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _startAnimation();
      } else {
        _controller.reverse();
      }
    }
  }

  void _startAnimation() {
    Future.delayed(widget.delay, () {
      if (mounted && widget.isVisible) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          ),
        );
      },
      // FIX: previously widget.onTap was never used anywhere, so tapping
      // a menu item did nothing except whatever InkWell used to be inside
      // _buildMenuButton. Now the GestureDetector below actually fires
      // widget.onTap, and it uses HitTestBehavior.opaque so taps register
      // even over the "empty" padding area of the button, not just the text/icon.
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: widget.child,
      ),
    );
  }
}

// ============================================================
// CustomBottomNavBar — The bottom navigation bar component
// ============================================================
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isMenuOpen;
  final ValueChanged<int> onTap;
  final VoidCallback onFABTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.isMenuOpen,
    required this.onTap,
    required this.onFABTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // Total height: 72 (bar height) + 24 (dome height) + bottomPadding
    final navBarHeight = 96.0 + bottomPadding;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background clipped shape
        ClipPath(
          clipper: BottomNavBarClipper(),
          child: Container(
            height: navBarHeight,
            width: double.infinity,
            color: const Color(0xFF13141F), // Bottom nav bar color from design
            padding: EdgeInsets.only(
              top: 24.0, // Shift layout down below the dome height
              bottom: bottomPadding,
              left: 16.0,
              right: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Left nav items
                _buildNavItem(0, 'Home'),
                _buildNavItem(1, 'Live'),

                // Spacer for the center cutout
                const SizedBox(width: 64),

                // Right nav items
                _buildNavItem(2, 'Chat'),
                _buildNavItem(3, 'Profile'),
              ],
            ),
          ),
        ),
        // Floating Action Button nested inside the center rising dome
        Positioned(
          top:
          4, // Nested cleanly in the dome area (peaking at y=0, bottom at y=24)
          left: MediaQuery.of(context).size.width / 2 - 28,
          child: TactileFAB(
            isMenuOpen: isMenuOpen,
            onTap: onFABTap,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(int index, String label) {
    final bool isActive = currentIndex == index;
    final Color activeColor = const Color(0xFF9F75FF);
    final Color inactiveColor = const Color(0xFF7C7C8A);
    final Color color = isActive ? activeColor : inactiveColor;

    Widget iconWidget;
    switch (index) {
      case 0:
        iconWidget = HouseIcon(isActive: isActive, color: color);
        break;
      case 1:
        iconWidget = BroadcastIcon(isActive: isActive, color: color);
        break;
      case 2:
        iconWidget = ChatIcon(isActive: isActive, color: color);
        break;
      case 3:
        iconWidget = ProfileIcon(isActive: isActive, color: color);
        break;
      default:
        iconWidget = const SizedBox.shrink();
    }

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            if (isActive) ...[
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: activeColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else ...[
              const SizedBox(
                height: 16,
              ), // Reserve space to prevent layout shifting
            ],
          ],
        ),
      ),
    );
  }
}

// Clipper class to generate a perfectly smooth convex dome shape (arch) rising upwards
class BottomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const r = 24.0; // Corner radius of top-left and top-right
    final center = size.width / 2;
    const flatY = 24.0; // Y-coordinate of the flat top edge

    path.moveTo(0, flatY + r);
    // Top-left corner
    path.quadraticBezierTo(0, flatY, r, flatY);

    // Line to the start of the dome
    const domeWidth = 52.0;
    final domeStart = center - domeWidth;
    path.lineTo(domeStart, flatY);

    // First cubic curve rising up to center dome (y = 0)
    path.cubicTo(center - 28.0, flatY, center - 26.0, 0.0, center, 0.0);

    // Second cubic curve falling back down to flat top edge (y = flatY)
    final domeEnd = center + domeWidth;
    path.cubicTo(center + 26.0, 0.0, center + 28.0, flatY, domeEnd, flatY);

    // Line to top-right corner
    path.lineTo(size.width - r, flatY);

    // Top-right corner
    path.quadraticBezierTo(size.width, flatY, size.width, flatY + r);

    // Bottom-right and bottom-left
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Custom 100% Matching House Icon
class HouseIcon extends StatelessWidget {
  final bool isActive;
  final Color color;
  final double size;

  const HouseIcon({
    super.key,
    required this.isActive,
    required this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HousePainter(isActive: isActive, color: color),
    );
  }
}

class _HousePainter extends CustomPainter {
  final bool isActive;
  final Color color;

  _HousePainter({required this.isActive, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    // House roof and walls
    path.moveTo(w * 0.15, h * 0.85);
    path.lineTo(w * 0.15, h * 0.45);
    path.quadraticBezierTo(w * 0.15, h * 0.38, w * 0.22, h * 0.33);
    path.lineTo(w * 0.44, h * 0.13);
    path.quadraticBezierTo(w * 0.5, h * 0.08, w * 0.56, h * 0.13);
    path.lineTo(w * 0.78, h * 0.33);
    path.quadraticBezierTo(w * 0.85, h * 0.38, w * 0.85, h * 0.45);
    path.lineTo(w * 0.85, h * 0.85);
    path.quadraticBezierTo(w * 0.85, h * 0.92, w * 0.78, h * 0.92);
    path.lineTo(w * 0.22, h * 0.92);
    path.quadraticBezierTo(w * 0.15, h * 0.92, w * 0.15, h * 0.85);
    path.close();

    if (isActive) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);

      // Draw vertical door slit (using background color cutout)
      final doorPaint = Paint()
        ..color =
        const Color(0xFF13141F) // Same as bottom bar background
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(w * 0.5, h * 0.58),
        Offset(w * 0.5, h * 0.76),
        doorPaint,
      );
    } else {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, paint);

      // Draw door slit inside
      final doorPaint = Paint()
        ..color = color
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(w * 0.5, h * 0.58),
        Offset(w * 0.5, h * 0.76),
        doorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HousePainter oldDelegate) =>
      oldDelegate.isActive != isActive || oldDelegate.color != color;
}

// Custom 100% Matching Broadcast Icon ((o))
class BroadcastIcon extends StatelessWidget {
  final bool isActive;
  final Color color;
  final double size;

  const BroadcastIcon({
    super.key,
    required this.isActive,
    required this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _BroadcastPainter(color: color),
    );
  }
}

class _BroadcastPainter extends CustomPainter {
  final Color color;

  _BroadcastPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Draw center solid dot
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 2.5, dotPaint);

    // Draw inner waves (radius 6.0)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 6.0),
      2.3, // ~132 degrees
      1.68, // sweep
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 6.0),
      5.44, // ~312 degrees
      1.68, // sweep
      false,
      paint,
    );

    // Draw outer waves (radius 11.0)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 11.0),
      2.3,
      1.68,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 11.0),
      5.44,
      1.68,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BroadcastPainter oldDelegate) =>
      oldDelegate.color != color;
}

// Custom 100% Matching Chat Icon (Rounded Speech Bubble with 3 dots)
class ChatIcon extends StatelessWidget {
  final bool isActive;
  final Color color;
  final double size;

  const ChatIcon({
    super.key,
    required this.isActive,
    required this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ChatPainter(isActive: isActive, color: color),
    );
  }
}

class _ChatPainter extends CustomPainter {
  final bool isActive;
  final Color color;

  _ChatPainter({required this.isActive, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bubblePath = Path();
    // Rounded rect
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.05, h * 0.15, w * 0.9, h * 0.65),
      const Radius.circular(7.0),
    );
    bubblePath.addRRect(rrect);

    // Speech tail on bottom left
    final tailPath = Path()
      ..moveTo(w * 0.22, h * 0.8)
      ..lineTo(w * 0.15, h * 0.95)
      ..lineTo(w * 0.35, h * 0.8)
      ..close();

    // Combine paths
    final fullPath = Path.combine(PathOperation.union, bubblePath, tailPath);

    if (isActive) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(fullPath, paint);

      // Draw three dark dots inside
      final dotPaint = Paint()
        ..color =
        const Color(0xFF13141F) // Same as bottom bar background
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(w * 0.32, h * 0.48), 2.0, dotPaint);
      canvas.drawCircle(Offset(w * 0.50, h * 0.48), 2.0, dotPaint);
      canvas.drawCircle(Offset(w * 0.68, h * 0.48), 2.0, dotPaint);
    } else {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(fullPath, paint);

      // Draw three grey dots inside
      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(w * 0.32, h * 0.48), 1.8, dotPaint);
      canvas.drawCircle(Offset(w * 0.50, h * 0.48), 1.8, dotPaint);
      canvas.drawCircle(Offset(w * 0.68, h * 0.48), 1.8, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChatPainter oldDelegate) =>
      oldDelegate.isActive != isActive || oldDelegate.color != color;
}

// Custom 100% Matching Profile Icon
class ProfileIcon extends StatelessWidget {
  final bool isActive;
  final Color color;
  final double size;

  const ProfileIcon({
    super.key,
    required this.isActive,
    required this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ProfilePainter(isActive: isActive, color: color),
    );
  }
}

class _ProfilePainter extends CustomPainter {
  final bool isActive;
  final Color color;

  _ProfilePainter({required this.isActive, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final headCenter = Offset(w / 2, h * 0.38);
    final headRadius = w * 0.2;

    final bodyPath = Path();
    bodyPath.moveTo(w * 0.15, h * 0.88);
    bodyPath.quadraticBezierTo(w * 0.15, h * 0.68, w * 0.35, h * 0.68);
    bodyPath.lineTo(w * 0.65, h * 0.68);
    bodyPath.quadraticBezierTo(w * 0.85, h * 0.68, w * 0.85, h * 0.88);

    if (isActive) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      // Draw head
      canvas.drawCircle(headCenter, headRadius, paint);
      // Draw body
      canvas.drawPath(bodyPath, paint);
    } else {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      // Draw head
      canvas.drawCircle(headCenter, headRadius, paint);
      // Draw body
      canvas.drawPath(bodyPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProfilePainter oldDelegate) =>
      oldDelegate.isActive != isActive || oldDelegate.color != color;
}