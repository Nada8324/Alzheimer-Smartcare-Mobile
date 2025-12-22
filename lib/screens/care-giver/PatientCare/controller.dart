import 'package:alzheimer_smartcare/global_controllers/main_app_controller.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/constants/endpoints.dart';
import 'package:alzheimer_smartcare/utils/custom_helpers/cache_helper.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// GetX Controller to manage patient location streams and GoogleMapController
class PatientLocationController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Use caregiver's email (documents in 'patients' are keyed by patient emails)
  final String ?currentCaregiverEmail = CacheHelper().getDataString(key: ApiKey.email);

  final RxSet<Marker> markers = <Marker>{}.obs;

  final Rx<CameraPosition> cameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 2,
  ).obs;

  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    firestore
        .collection('patients')
        .where('careGivers', arrayContains: currentCaregiverEmail)
        .snapshots()
        .listen((snapshot) {
      final ids = snapshot.docs.map((d) => d.id).toList();
      _subscribeToLocationUpdates(ids);
    });
  }

  void _subscribeToLocationUpdates(List<String> patientIds) {
    if (patientIds.isEmpty) {
      markers.clear();
      return;
    }
    rx.CombineLatestStream.list(
      patientIds.map((id) =>
          firestore.collection('patients').doc(id).snapshots()
      ),
    ).listen((snapshots) {
      final locations = snapshots
          .map((doc) => doc.data()?['location'] as GeoPoint?)
          .where((gp) => gp != null)
          .cast<GeoPoint>()
          .toList();

      if (locations.isNotEmpty) {
        cameraPosition.value = CameraPosition(
          target: LatLng(locations.first.latitude, locations.first.longitude),
          zoom: 12,
        );
        // Rebuild markers
        markers
          ..clear()
          ..addAll(locations.map((geo) => Marker(
            markerId: MarkerId(geo.hashCode.toString()),
            position: LatLng(geo.latitude, geo.longitude),
          )));

        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(cameraPosition.value),
          );
        }
      } else {
        markers.clear();
      }
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController!.moveCamera(
      CameraUpdate.newCameraPosition(cameraPosition.value),
    );
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
}


