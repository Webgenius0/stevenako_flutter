import 'package:flutter/foundation.dart';

@immutable
class LocationOptionModel {
  final String id;
  final String title;
  final String subtitle;
  final double? latitude;
  final double? longitude;
  final bool isCurrentLocation;

  const LocationOptionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.latitude,
    this.longitude,
    this.isCurrentLocation = false,
  });

  LocationOptionModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    double? latitude,
    double? longitude,
    bool? isCurrentLocation,
  }) {
    return LocationOptionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isCurrentLocation: isCurrentLocation ?? this.isCurrentLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'latitude': latitude,
      'longitude': longitude,
      'isCurrentLocation': isCurrentLocation,
    };
  }

  factory LocationOptionModel.fromMap(Map<String, dynamic> map) {
    return LocationOptionModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString() ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      isCurrentLocation: map['isCurrentLocation'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationOptionModel &&
        other.id == id &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.isCurrentLocation == isCurrentLocation;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        isCurrentLocation.hashCode;
  }

  @override
  String toString() {
    return 'LocationOptionModel(id: $id, title: $title, subtitle: $subtitle, lat: $latitude, lng: $longitude, isCurrentLocation: $isCurrentLocation)';
  }
}
