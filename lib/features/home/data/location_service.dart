import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../model/location_option_model.dart';

abstract class ILocationService {
  Future<LocationOptionModel?> fetchCurrentLocation();
  List<LocationOptionModel> getPopularLocations();
  List<LocationOptionModel> filterLocations(
    List<LocationOptionModel> locations,
    String query,
  );
}

class LocationService implements ILocationService {
  static LocationService? _instance;
  LocationService._internal();

  static LocationService get instance =>
      _instance ??= LocationService._internal();

  @override
  List<LocationOptionModel> getPopularLocations() {
    return const [
      LocationOptionModel(
        id: 'ny_usa',
        title: 'New York, USA',
        subtitle: 'Manhattan, New York',
        latitude: 40.7128,
        longitude: -74.0060,
      ),
      LocationOptionModel(
        id: 'la_usa',
        title: 'Los Angeles, USA',
        subtitle: 'California',
        latitude: 34.0522,
        longitude: -118.2437,
      ),
      LocationOptionModel(
        id: 'london_uk',
        title: 'London, UK',
        subtitle: 'England',
        latitude: 51.5074,
        longitude: -0.1278,
      ),
      LocationOptionModel(
        id: 'tokyo_jp',
        title: 'Tokyo, Japan',
        subtitle: 'Kanto Region',
        latitude: 35.6762,
        longitude: 139.6503,
      ),
      LocationOptionModel(
        id: 'paris_fr',
        title: 'Paris, France',
        subtitle: 'Île-de-France',
        latitude: 48.8566,
        longitude: 2.3522,
      ),
      LocationOptionModel(
        id: 'sydney_au',
        title: 'Sydney, Australia',
        subtitle: 'New South Wales',
        latitude: -33.8688,
        longitude: 151.2093,
      ),
    ];
  }

  @override
  List<LocationOptionModel> filterLocations(
    List<LocationOptionModel> locations,
    String query,
  ) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return locations;

    return locations.where((loc) {
      final titleMatch = loc.title.toLowerCase().contains(trimmed);
      final subtitleMatch = loc.subtitle.toLowerCase().contains(trimmed);
      return titleMatch || subtitleMatch;
    }).toList();
  }

  @override
  Future<LocationOptionModel?> fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable GPS.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Please enable them from Settings.',
      );
    }

    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    String title = 'Current Location';
    String subtitle =
        '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';

    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final String city =
            place.locality ?? place.subAdministrativeArea ?? place.administrativeArea ?? '';
        final String country = place.country ?? '';
        final String subLocality =
            place.subLocality ?? place.thoroughfare ?? place.name ?? '';

        if (city.isNotEmpty && country.isNotEmpty) {
          title = '$city, $country';
        } else if (country.isNotEmpty) {
          title = country;
        }

        if (subLocality.isNotEmpty && subLocality != city) {
          subtitle = '$subLocality, $city';
        } else if (city.isNotEmpty) {
          subtitle = city;
        }
      }
    } catch (e) {
      log('Reverse geocoding error: $e');
    }

    return LocationOptionModel(
      id: 'current_location',
      title: title,
      subtitle: subtitle,
      latitude: position.latitude,
      longitude: position.longitude,
      isCurrentLocation: true,
    );
  }
}
