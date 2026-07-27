import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stevenako_flutter/features/home/presentation/photo_scree.dart';
import 'package:stevenako_flutter/features/home/presentation/post_screen.dart';
import 'package:stevenako_flutter/features/home/presentation/releas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _activeSubTab = 0; // 0 = Video, 1 = Photos, 2 = Posts

  // Entrance animation for the top bar
  late final AnimationController _entranceController;
  late final Animation<double> _entranceFade;
  late final Animation<Offset> _entranceSlide;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _entranceFade = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _entranceSlide = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      ReelsSubScreen(isActive: _activeSubTab == 0),
      const PhotosSubScreen(),
      const PostsSubScreen(),
    ];

    return Stack(
      children: [
        // Sub-tab content: state-preserving fade/slide transition.
        // Every screen stays mounted (so video controllers on the
        // Reels tab keep their buffered state); only opacity/offset
        // and hit-testing change on switch.
        Positioned.fill(
          child: Stack(
            children: List.generate(screens.length, (index) {
              final bool isActive = _activeSubTab == index;
              return IgnorePointer(
                ignoring: !isActive,
                child: AnimatedOpacity(
                  opacity: isActive ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOut,
                  child: AnimatedSlide(
                    offset: isActive ? Offset.zero : const Offset(0, 0.02),
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    child: screens[index],
                  ),
                ),
              );
            }),
          ),
        ),

        // Custom Top Navigation Tab Bar Overlay (animates in on load)
        Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: FadeTransition(
            opacity: _entranceFade,
            child: SlideTransition(
              position: _entranceSlide,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sliding Tab Selector Container
                  Container(
                    height: 40,
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24, width: 1.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSubTabButton(0, 'Video'),
                        _buildSubTabButton(1, 'Photos'),
                        _buildSubTabButton(2, 'Posts'),
                      ],
                    ),
                  ),

                  // Search & Filter Actions
                  Row(
                    children: [
                      _buildTopActionButton(Icons.search, () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Search tapped!')),
                        );
                      }),
                      const SizedBox(width: 10),
                      _buildTopActionButton(Icons.tune, () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Filter tapped!')),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubTabButton(int index, String label) {
    final bool isActive = _activeSubTab == index;
    return _TapScale(
      onTap: () {
        setState(() {
          _activeSubTab = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: isActive
              ? const LinearGradient(
            colors: [Color(0xFF9F75FF), Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.85, end: isActive ? 1.0 : 0.85),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white70,
              fontSize: 13.5.sp,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopActionButton(IconData icon, VoidCallback onTap) {
    return _TapScale(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 1.0),
        ),
        child: Icon(icon, color: Colors.white, size: 18.sp),
      ),
    );
  }
}

// Reusable tactile tap-scale wrapper — press down to shrink slightly,
// release to bounce back. Matches the feel of the FAB elsewhere in the app.
class _TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _TapScale({required this.child, required this.onTap});

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale> {
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
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}