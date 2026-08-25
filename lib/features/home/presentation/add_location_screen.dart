import 'package:flutter/material.dart';
import '../../../helpers/toast.dart';
import '../data/location_service.dart';
import '../model/location_option_model.dart';

/// AddLocationScreen — Supports user current location fetching via geolocator/geocoding,
/// top card updates, keyword search filtering, and popular location selection.
class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  static const Color _bgTop = Color(0xFF1E1B2E);
  static const Color _bgBottom = Color(0xFF0F0E17);
  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _hintColor = Color(0xFF8B8A99);

  final TextEditingController _searchController = TextEditingController();
  final LocationService _locationService = LocationService.instance;

  late List<LocationOptionModel> _popularLocations;
  LocationOptionModel? _fetchedCurrentLocation;
  LocationOptionModel? _selectedLocation;

  String _query = '';
  bool _isLoadingCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    _popularLocations = _locationService.getPopularLocations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filtered locations based on current search query.
  /// Returns empty list when query is empty (initial state only shows Use Current Location button).
  List<LocationOptionModel> get _filteredLocations {
    if (_query.trim().isEmpty) return [];
    return _locationService.filterLocations(_popularLocations, _query);
  }

  /// Whether current location card matches the current search query.
  bool get _currentLocationMatchesQuery {
    if (_query.trim().isEmpty) return true;
    if (_fetchedCurrentLocation == null) return false;
    final q = _query.trim().toLowerCase();
    return _fetchedCurrentLocation!.title.toLowerCase().contains(q) ||
        _fetchedCurrentLocation!.subtitle.toLowerCase().contains(q);
  }

  void _onBack() {
    Navigator.of(context).maybePop();
  }

  /// Trigger geolocation & reverse geocoding to fetch current location.
  Future<void> _onUseCurrentLocation() async {
    setState(() => _isLoadingCurrentLocation = true);

    try {
      final currentLocation = await _locationService.fetchCurrentLocation();

      if (!mounted) return;

      if (currentLocation != null) {
        setState(() {
          _fetchedCurrentLocation = currentLocation;
          _selectedLocation = currentLocation;
        });
        ToastUtil.showShortToast('Location set to: ${currentLocation.title}');
      }
    } catch (e) {
      if (!mounted) return;
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      ToastUtil.showShortToast(errorMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoadingCurrentLocation = false);
      }
    }
  }

  void _onSelectLocation(LocationOptionModel location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _onContinue() {
    if (_selectedLocation == null) return;
    Navigator.of(context).maybePop(_selectedLocation);
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final filteredCards = _filteredLocations;
    final isSearching = _query.trim().isNotEmpty;
    final showCurrentLocationCard = !isSearching || _currentLocationMatchesQuery;

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
              // ---- Top Header Bar ----
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
                    const SizedBox(width: 44),
                  ],
                ),
              ),

              // ---- Search Input Bar ----
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
                      if (_query.isNotEmpty)
                        GestureDetector(
                          onTap: _onClearSearch,
                          child: const Icon(
                            Icons.close,
                            color: _hintColor,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // ---- Scrollable Content List ----
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [
                    // ---- Current Location Top Card ----
                    if (showCurrentLocationCard) ...[
                      _UseCurrentLocationCard(
                        isLoading: _isLoadingCurrentLocation,
                        fetchedLocation: _fetchedCurrentLocation,
                        isSelected: _selectedLocation?.id == 'current_location',
                        onTap: _onUseCurrentLocation,
                      ),
                      const SizedBox(height: 22),
                    ],

                    // ---- Filtered Location Cards (Shown when searching) ----
                    for (int i = 0; i < filteredCards.length; i++) ...[
                      _LocationCardItem(
                        option: filteredCards[i],
                        isSelected: _selectedLocation?.id == filteredCards[i].id,
                        onTap: () => _onSelectLocation(filteredCards[i]),
                      ),
                      if (i != filteredCards.length - 1)
                        const SizedBox(height: 14),
                    ],

                    // ---- Empty Results State (When user searches but no locations match) ----
                    if (isSearching && filteredCards.isEmpty && !showCurrentLocationCard) ...[
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_off_outlined,
                                color: _hintColor,
                                size: 48,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No locations found',
                                style: TextStyle(
                                  color: _hintColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ---- Bottom Continue CTA Button ----
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: _ContinueButton(
                  label: 'Continue',
                  enabled: _selectedLocation != null,
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
// Modular OOP Sub-Widgets
// ============================================================

/// Use Current Location Top Card Widget.
class _UseCurrentLocationCard extends StatelessWidget {
  final bool isLoading;
  final LocationOptionModel? fetchedLocation;
  final bool isSelected;
  final VoidCallback onTap;

  const _UseCurrentLocationCard({
    required this.isLoading,
    required this.fetchedLocation,
    required this.isSelected,
    required this.onTap,
  });

  static const Color _cardBorder = Color(0xFF2E2C3E);
  static const Color _purple = Color(0xFF7C3AED);
  static const Color _purpleLight = Color(0xFF9F75FF);
  static const Color _hintColor = Color(0xFF8B8A99);

  @override
  Widget build(BuildContext context) {
    final titleText = fetchedLocation?.title ?? 'Use current location';
    final subtitleText = fetchedLocation?.subtitle;

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
              width: isSelected ? 1.5 : 1,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      titleText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitleText != null && subtitleText.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitleText,
                        style: const TextStyle(
                          color: _hintColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
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

/// Standard Location Item Card Widget.
class _LocationCardItem extends StatelessWidget {
  final LocationOptionModel option;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocationCardItem({
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
              width: isSelected ? 1.5 : 1,
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
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      option.subtitle,
                      style: const TextStyle(
                        color: _hintColor,
                        fontSize: 14.5,
                      ),
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

/// Action Continue Button Widget.
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
                colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
              ),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
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
