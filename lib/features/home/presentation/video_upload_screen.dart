import 'package:flutter/material.dart';

// ============================================================
// VideoUploadScreen — Full-screen video/photo preview with
// Music / Trim editing pills and a bottom "Continue" CTA.
// Matches the provided design 1:1.
// ============================================================
class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  // TODO: Replace with your actual captured video/photo asset or controller.
  // For now this uses a placeholder image so the layout can be verified.
  final String _previewImagePath = 'assets/images/preview_placeholder.jpg';

  void _onClose() {
    Navigator.of(context).maybePop();
  }

  void _onMusicTap() {
    // TODO: open music picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Music tapped'), duration: Duration(milliseconds: 800)),
    );
  }

  void _onTrimTap() {
    // TODO: open trim editor
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trim tapped'), duration: Duration(milliseconds: 800)),
    );
  }

  void _onContinue() {
    // TODO: proceed to next step (caption / post details screen, upload, etc.)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ---------------------------------------------------
          // Background preview (video frame / captured photo)
          // ---------------------------------------------------
          Positioned.fill(
            child: Image.asset(
              _previewImagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback so the screen still renders if the asset is missing.
                return Container(color: const Color(0xFF2A2A2A));
              },
            ),
          ),

          // Subtle top gradient so the header controls stay legible
          // over bright backgrounds.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Subtle bottom gradient behind the Continue button.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 160,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.45),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ---------------------------------------------------
          // Foreground UI
          // ---------------------------------------------------
          SafeArea(
            child: Column(
              children: [
                // ---- Top bar: close button + title + right-side pills
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CircleIconButton(
                        icon: Icons.close,
                        onTap: _onClose,
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Preview',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      // Balances the close button so "Preview" stays centered.
                      const SizedBox(width: 44),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ---- Right-aligned Music / Trim pills
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _PillButton(
                          label: 'Music',
                          icon: Icons.music_note_rounded,
                          onTap: _onMusicTap,
                        ),
                        const SizedBox(height: 14),
                        _PillButton(
                          label: 'Trim',
                          icon: Icons.content_cut_rounded,
                          onTap: _onTrimTap,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // ---- Bottom Continue CTA
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: _ContinueButton(onTap: _onContinue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Reusable pieces
// ============================================================

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.28),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.32),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ContinueButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: double.infinity,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF7C3AED),
                Color(0xFF6D28D9),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Text(
            'Continue',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}