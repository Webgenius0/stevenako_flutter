import 'package:flutter/material.dart';

// ============================================================
// AddLocationScreen — Search + "use current location" + a
// suggested locations list. Matches the provided design 1:1.
// ============================================================

class _LocationOption {
  final String title; // e.g. "New York, USA"
  final String subtitle; // e.g. "Manhattan, New York"

  const _LocationOption({required this.title, required this.subtitle});
}

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  static const Color _bgTop = Color(0xFF1E1B2E);
  static const Color _bgBottom = Color(0xFF0F0E17);
  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _purple = Color(0xFF7C3AED);
  static const Color _purpleLight = Color(0xFF9F75FF);
  static const Color _hintColor = Color(0xFF8B8A99);
  static const Color _iconBg = Color(0xFF352F4D);

  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _usingCurrentLocation = false;

  // Track the currently selected option so the Continue button knows
  // what to confirm. Either a suggested location title, or the special
  // 'current_location' marker.
  String? _selectedValue;

  // TODO: Replace with real geocoding/places-API results.

  final List<_LocationOption> _suggested = const [
    _LocationOption(title: 'New York, USA', subtitle: 'Manhattan, New York'),
    _LocationOption(title: 'Los Angeles, USA', subtitle: 'California'),
    _LocationOption(title: 'London, UK', subtitle: 'England'),
    _LocationOption(title: 'Tokyo, Japan', subtitle: 'Kanto Region'),
    _LocationOption(title: 'Paris, France', subtitle: 'Île-de-France'),
    _LocationOption(title: 'Sydney, Australia', subtitle: 'New South Wales'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_LocationOption> get _filtered {
    if (_query.trim().isEmpty) return _suggested;
    final q = _query.toLowerCase();
    return _suggested
        .where(
          (l) =>
      l.title.toLowerCase().contains(q) ||
          l.subtitle.toLowerCase().contains(q),
    )
        .toList();
  }

  void _onBack() {
    Navigator.of(context).maybePop();
  }

  Future<void> _onUseCurrentLocation() async {
    setState(() => _usingCurrentLocation = true);

    // TODO: hook up real geolocation (e.g. `geolocator` package) + reverse
    // geocoding here to resolve an actual address/title before marking
    // this as selected.
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() {
      _usingCurrentLocation = false;
      _selectedValue = 'current_location';
    });
  }

  void _onSelectLocation(_LocationOption location) {
    setState(() => _selectedValue = location.title);
  }

  void _onContinue() {
    if (_selectedValue == null) return;
    Navigator.of(context).maybePop(_selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

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
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Add location',
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

              // ---- Search field
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: _cardBorder),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: _hintColor, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _query = v),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: 'Search location...',
                            hintStyle: TextStyle(
                              color: _hintColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // ---- Scrollable list: "use current location" + suggested
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [
                    _UseCurrentLocationRow(
                      isLoading: _usingCurrentLocation,
                      isSelected: _selectedValue == 'current_location',
                      onTap: _onUseCurrentLocation,
                    ),
                    const SizedBox(height: 22),
                    const Padding(
                      padding: EdgeInsets.only(left: 2, bottom: 12),
                      child: Text(
                        'SUGGESTED',
                        style: TextStyle(
                          color: _hintColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    for (int i = 0; i < results.length; i++) ...[
                      _LocationRow(
                        option: results[i],
                        isSelected: _selectedValue == results[i].title,
                        onTap: () => _onSelectLocation(results[i]),
                      ),
                      if (i != results.length - 1) const SizedBox(height: 14),
                    ],
                    if (results.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Center(
                          child: Text(
                            'No locations found',
                            style: TextStyle(color: _hintColor, fontSize: 15),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ---- Bottom Continue CTA
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: _ContinueButton(
                  label: 'Continue',
                  enabled: _selectedValue != null,
                  onTap: _onContinue,
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

class _UseCurrentLocationRow extends StatelessWidget {
  final bool isLoading;
  final bool isSelected;
  final VoidCallback onTap;

  const _UseCurrentLocationRow({
    required this.isLoading,
    required this.isSelected,
    required this.onTap,
  });

  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _purple = Color(0xFF7C3AED);
  static const Color _purpleLight = Color(0xFF9F75FF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? _purple : _cardBorder,
              width: isSelected ? 1.4 : 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_purpleLight, _purple],
                  ),
                ),
                alignment: Alignment.center,
                child: isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
                    : const Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Use current location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: _purple, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final _LocationOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocationRow({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _hintColor = Color(0xFF8B8A99);
  static const Color _iconBg = Color(0xFF352F4D);
  static const Color _iconColor = Color(0xFF9F75FF);
  static const Color _purple = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? _purple : _cardBorder,
              width: isSelected ? 1.4 : 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _iconBg,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.location_on,
                  color: _iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      option.subtitle,
                      style: const TextStyle(color: _hintColor, fontSize: 14.5),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: _purple, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Continue CTA (same style as your other screens)
// ============================================================

class _ContinueButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _ContinueButton({
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(30),
        child: Opacity(
          opacity: enabled ? 1.0 : 0.45,
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
              boxShadow: enabled
                  ? [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
                  : null,
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}