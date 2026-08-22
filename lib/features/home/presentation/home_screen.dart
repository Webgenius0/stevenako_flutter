import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:stevenako_flutter/features/home/presentation/photo_scree.dart';
import 'package:stevenako_flutter/features/home/presentation/post_navtaiosn_screeen.dart';
import 'package:stevenako_flutter/features/home/presentation/releas_screen.dart';
import 'package:stevenako_flutter/features/home/presentation/search_scren.dart';

class HomeScreen extends StatefulWidget {
  final bool isActive;
  const HomeScreen({super.key, this.isActive = true});

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
    _entranceSlide =
        Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

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
      ReelsSubScreen(isActive: widget.isActive && _activeSubTab == 0),
      const PhotosSubScreen(),
      PostsSubScreenTwo(),
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
          top: MediaQuery.of(context).padding.top + 12,
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
                    height: 40.h,
                    padding: EdgeInsets.all(3.0.sp),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.white24, width: 1.0.w),
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
                      _buildTopActionButton(
                        'assets/images/search-normal.png',
                        () {
                          // Your onTap code here
                          Get.to(SearchScren());
                        },
                      ),

                      SizedBox(width: 30.w),
                      _buildTopActionButton(
                        'assets/images/Settings.png',
                        () {},
                      ),
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
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17.r),
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF402380), Color(0xFF7C3AED)],
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

  Widget _buildTopActionButton(String imagePath, VoidCallback onTap) {
    return _TapScale(
      onTap: onTap,
      child: Center(
        child: Image.asset(
          imagePath,
          width: 24.w,
          height: 24.h,
          color: Colors.white,
        ),
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
