import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ============================================================
// QrCodeScreeen — Profile QR code with download/share actions.
// Matches the provided design 1:1.
// (Class name kept exactly as given, typo and all, so it stays
// a drop-in replacement for your existing stub.)
//
// NOTE: This uses the `qr_flutter` package to render a real,
// scannable QR code (rather than a static image), so add this
// to your pubspec.yaml:
//
//   dependencies:
//     qr_flutter: ^4.1.0
// ============================================================

class QrCodeScreeen extends StatefulWidget {
  final String displayName;
  final String handle;
  final String avatarUrl;
  final String profileUrl; // the actual data encoded in the QR code

  const QrCodeScreeen({
    super.key,
    this.displayName = 'Frances Swann',
    this.handle = '@Frances487',
    this.avatarUrl = 'https://i.pravatar.cc/300?img=45',
    this.profileUrl = 'https://yourapp.com/u/Frances487',
  });

  @override
  State<QrCodeScreeen> createState() => _QrCodeScreeenState();
}

class _QrCodeScreeenState extends State<QrCodeScreeen> {
  static const Color _bgTop = Color(0xFF1E1B2E);
  static const Color _bgBottom = Color(0xFF0F0E17);
  static const Color _hintColor = Color(0xFF8B8A99);
  static const Color _qrBg = Color(0xFF242238);
  static const Color _circleBg = Color(0xFF2E2C42);

  final GlobalKey _qrKey = GlobalKey();
  bool _isSaving = false;

  void _onBack() {
    Navigator.of(context).maybePop();
  }

  Future<void> _onDownload() async {
    setState(() => _isSaving = true);
    // TODO: capture `_qrKey`'s RenderRepaintBoundary to a PNG and save it
    // to the device gallery (e.g. using `image_gallery_saver` or similar).
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR code saved'),
        duration: Duration(milliseconds: 900),
      ),
    );
  }

  void _onShare() {
    // TODO: capture the QR widget as an image and share it via
    // the `share_plus` package, e.g.:
    // Share.shareXFiles([XFile(pngPath)], text: widget.profileUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _onBack,
                      icon: const Icon(Icons.chevron_left,
                          color: Colors.white, size: 30),
                    ),
                    const Expanded(
                      child: Text(
                        'QR Code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 44), // balances the back button
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ---- Avatar
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: Image.network(
                    widget.avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF2A2A3A),
                      child: const Icon(Icons.person,
                          color: Colors.white54, size: 40),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---- Name + handle
              Text(
                widget.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.handle,
                style: const TextStyle(
                  color: _hintColor,
                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 36),

              // ---- QR code card
              RepaintBoundary(
                key: _qrKey,
                child: Container(
                  width: 260,
                  height: 260,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _qrBg,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: QrImageView(
                    data: widget.profileUrl,
                    version: QrVersions.auto,
                    backgroundColor: Colors.transparent,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Colors.white,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ---- Download / Share actions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CircleActionButton(
                    icon: Icons.file_download_outlined,
                    isLoading: _isSaving,
                    onTap: _onDownload,
                  ),
                  const SizedBox(width: 20),
                  _CircleActionButton(
                    icon: Icons.share_outlined,
                    onTap: _onShare,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Reusable circular action button
// ============================================================

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  const _CircleActionButton({
    required this.icon,
    required this.onTap,
    this.isLoading = false,
  });

  static const Color _circleBg = Color(0xFF2E2C42);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _circleBg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 64,
          height: 64,
          child: isLoading
              ? const Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
            ),
          )
              : Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}