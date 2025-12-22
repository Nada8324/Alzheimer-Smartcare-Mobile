import 'package:cloud_firestore/cloud_firestore.dart';

class LocationData {
  final GeoPoint geoPoint;
  final String name;
  final Timestamp timestamp;

  LocationData({
    required this.geoPoint,
    required this.name,
    required this.timestamp,
  });
}