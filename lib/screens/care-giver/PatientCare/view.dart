
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../global_controllers/main_app_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/custom_widgets/custom_app_bar.dart';
import '../scanPatient/controller.dart';
import 'model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;

class PatientLocationTrackingScreen extends StatefulWidget {
  const PatientLocationTrackingScreen({super.key});

  @override
  State<PatientLocationTrackingScreen> createState() =>
      _PatientLocationTrackingScreenState();
}

class PatientMarker {
  final latlong.LatLng position;
  final String name;
  final Timestamp timestamp;

  PatientMarker({
    required this.position,
    required this.name,
    required this.timestamp,
  });
}

class _PatientLocationTrackingScreenState
    extends State<PatientLocationTrackingScreen> {
  final MapController _mapController = MapController();
  final DateFormat _dateFormatter = DateFormat('dd MMM yyyy HH:mm');
  List<PatientMarker> _patientMarkers = [];
  PatientMarker? _selectedMarker;
  bool _initialBoundsCalculated = false;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CareGiverScanPatientController>();

    return AppScreen(
      appBar: customAppBar(context, backgroundColor: AppColors.white),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.pairedPatients,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return  Center(child: MainAppController.showLoading());
          }

          if (snap.hasError || !snap.hasData) {
            return Center(child: Text('Error loading patients'.tr));
          }
          EasyLoading.dismiss();
          final patientIds = snap.data!.docs
              .map((d) => d['patientId'] as String)
              .toList();

          return patientIds.isEmpty
              ? _buildEmptyState()
              : _buildMapContent(controller, patientIds);
        },
      ),
    );
  }

  Widget _buildMapContent(CareGiverScanPatientController controller,
      List<String> patientIds) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.firestore
          .collection('patients')
          .where(FieldPath.documentId, whereIn: patientIds)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          MainAppController.showLoading();
          return Center(child: CircularProgressIndicator());
        }

        EasyLoading.dismiss();

        if (snapshot.hasError) {
          return Center(
            child: AppText(
              'Error: ${snapshot.error}',color: Colors.red,
            ),
          );
        }
        _updateMarkers(snapshot.data!.docs);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_initialBoundsCalculated) {
            _fitToBounds();
            _initialBoundsCalculated = true;
          }
        });

        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _patientMarkers.isNotEmpty
                    ? _patientMarkers.first.position
                    : const latlong.LatLng(0, 0),
                initialZoom: 20,
                onMapReady: () => _fitToBounds(),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.alzheimersmartcare',
                ),
                MarkerLayer(
                  markers: _patientMarkers.map((marker) => Marker(
                    width: 40,
                    height: 40,
                    point: marker.position,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedMarker = marker),
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
            if (_selectedMarker != null)
              _buildLocationInfoBox(),
          ],
        );
      },
    );
  }

  void _updateMarkers(List<QueryDocumentSnapshot> patients) {
    _patientMarkers = patients.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final geoPoint = data['location'] as GeoPoint? ?? const GeoPoint(0, 0);
      final lat = geoPoint.latitude;
      final lng = geoPoint.longitude;

      if (lat.isNaN || lng.isNaN || lat.isInfinite || lng.isInfinite) {
        return null;
      }

      return PatientMarker(
        position: latlong.LatLng(lat, lng),
        name: data['name'] ?? 'Unknown Patient',
        timestamp: data['lastUpdated'] ?? Timestamp.now(),
      );
    }).where((marker) =>
    marker != null &&
        marker.position != const latlong.LatLng(0, 0))
        .toList()
        .cast<PatientMarker>();
  }

  void _fitToBounds() {
    if (_patientMarkers.isEmpty) return;

    final positions = _patientMarkers.map((m) => m.position).toList();
    final bounds = LatLngBounds.fromPoints(positions);

    try {
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(50),
          maxZoom: 18,
          minZoom: 12,
        ),
      );
    } catch (e) {
      _mapController.move(
        bounds.center,
        15,
      );
    }
  }

  Widget _buildLocationInfoBox() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                _selectedMarker?.name ?? 'Unknown Patient',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,

              ),
              const SizedBox(height: 8),
              AppText(
                'Last updated: ${_dateFormatter.format(
                    _selectedMarker?.timestamp.toDate() ?? DateTime.now())}',

              ),
              const SizedBox(height: 4),
              AppText(
                'Latitude: ${_selectedMarker?.position.latitude.toStringAsFixed(4)}',
              ),
              AppText(
                'Longitude: ${_selectedMarker?.position.longitude.toStringAsFixed(4)}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          AppText(
            'No patients paired yet'.tr,
            fontSize: 16, color: Colors.grey,
          ),
        ],
      ),
    );
  }
}