import 'package:flutter/material.dart';

// ============================================================
// UploadPostScreen — Caption + settings screen shown after
// trimming/editing a video, before publishing.
// Matches the provided design 1:1.
// ============================================================
class UploadPostScreen extends StatefulWidget {
  final String? thumbnailPath; // path to the video's preview frame

  const UploadPostScreen({super.key, this.thumbnailPath});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final TextEditingController _captionController = TextEditingController();

  bool _allowComments = true;
  bool _allowGifts = true;

  static const Color _bgTop = Color(0xFF1E1B2E);
  static const Color _bgBottom = Color(0xFF0F0E17);
  static const Color _cardColor = Color(0xFF1A1926);
  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _purple = Color(0xFF7C3AED);
  static const Color _purpleLight = Color(0xFF9F75FF);
  static const Color _hintColor = Color(0xFF8B8A99);

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _onBack() {
    Navigator.of(context).maybePop();
  }

  void _onTagPeople() {
    // TODO: open tag-people picker
  }

  void _onLocation() {
    // TODO: open location picker
  }

  void _onPrivacy() {
    // TODO: open "who can watch" privacy options
  }

  void _onSaveDraft() {
    // TODO: persist draft locally / to backend
  }

  void _onPostNow() {
    // TODO: upload video + caption + settings to backend
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
                        'Post',
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

              // ---- Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Caption box + thumbnail
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: _cardBorder),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: TextField(
                                  controller: _captionController,
                                  maxLines: null,
                                  minLines: 5,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.5,
                                    height: 1.35,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintText:
                                    'Describe your video, add hashtags, or mention your friends',
                                    hintStyle: TextStyle(
                                      color: _hintColor,
                                      fontSize: 16.5,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: SizedBox(
                                width: 84,
                                child: widget.thumbnailPath != null
                                    ? Image.asset(
                                  widget.thumbnailPath!,
                                  fit: BoxFit.cover,
                                )
                                    : Container(color: const Color(0xFF2A2A2A)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      _NavRow(
                        icon: Icons.person_outline,
                        label: 'Tag people',
                        onTap: _onTagPeople,
                      ),
                      const SizedBox(height: 12),
                      _NavRow(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        onTap: _onLocation,
                      ),
                      const SizedBox(height: 12),
                      _NavRow(
                        icon: Icons.lock_open_outlined,
                        label: 'Anyone can watch this',
                        onTap: _onPrivacy,
                      ),
                      const SizedBox(height: 12),
                      _ToggleRow(
                        icon: Icons.chat_bubble_outline,
                        label: 'Allow comments',
                        value: _allowComments,
                        onChanged: (v) => setState(() => _allowComments = v),
                      ),
                      const SizedBox(height: 12),
                      _ToggleRow(
                        icon: Icons.card_giftcard_outlined,
                        label: 'Allow Gifts',
                        value: _allowGifts,
                        onChanged: (v) => setState(() => _allowGifts = v),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // ---- Bottom action bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _onSaveDraft,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: _purpleLight, width: 1.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Save as Draft',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [_purpleLight, _purple],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _purple.withOpacity(0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: _onPostNow,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Post Now',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Reusable rows
// ============================================================

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1A1926),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF2E2C3E)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: Color(0xFF8B8A99), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2E2C3E)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF7C3AED),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFF3A384A),
              trackOutlineColor:
              const MaterialStatePropertyAll(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}