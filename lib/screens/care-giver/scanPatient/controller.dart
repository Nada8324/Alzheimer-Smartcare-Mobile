import 'package:alzheimer_smartcare/utils/constants/alerts.dart';
import 'package:alzheimer_smartcare/utils/constants/endpoints.dart';
import 'package:alzheimer_smartcare/utils/custom_helpers/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../utils/constants/secrets.dart';

class CareGiverScanPatientController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();
  MobileScannerController? scannerController;
  final RxBool isLoading = false.obs;
  String caregiverEmail = '';
  final RxSet<String> processedRequests = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    scannerController = MobileScannerController();
    _loadEmail();
  }

  void _loadEmail() {
    final email = CacheHelper().getDataString(key: ApiKey.email);
    if (email != null) {
      caregiverEmail = email;
    }
  }

  Future<void> sendPairingRequest(String patientId) async {
    try {
      // Validate before processing
      if (patientId.isEmpty) throw 'Patient ID cannot be empty'.tr;
      if (caregiverEmail.isEmpty) throw 'User not logged in'.tr;

      // Check if this request is already processed
      final requestKey = '${caregiverEmail}_$patientId';
      if (processedRequests.contains(requestKey)) {
        showAppSnackBar(
          alertType: AlertType.fail,
          message: 'Request already sent'.tr,
        );
        return;
      }

      isLoading.value = true;

      final existingRequest = await firestore
          .collection('pairing_requests')
          .where('apiToken', isEqualTo: AppSecrets.firestoreToken)
          .where('caregiverEmail', isEqualTo: caregiverEmail)
          .where('patientId', isEqualTo: patientId)
          .where('status', whereIn: ['pending', 'approved'])
          .limit(1)
          .get();

      if (existingRequest.docs.isNotEmpty) {
        showAppSnackBar(
          alertType: AlertType.fail,
          message: 'Request already exists'.tr,
        );
        return;
      }

      await firestore.collection('pairing_requests').add({
        'apiToken': AppSecrets.firestoreToken,
        'caregiverEmail': caregiverEmail,
        'createdAt': FieldValue.serverTimestamp(),
        'patientId': patientId,
        'status': 'pending',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      processedRequests.add(requestKey);

      showAppSnackBar(
        alertType: AlertType.success,
        message: 'Request sent successfully'.tr,
      );
    } catch (e) {
      showAppSnackBar(
        alertType: AlertType.fail,
        message: "${'Error'.tr}: ${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Stream<QuerySnapshot> get pairedPatients {
    if (caregiverEmail.isEmpty) {
      return const Stream<QuerySnapshot>.empty();
    }

    return firestore
        .collection('pairing_requests')
        .where('apiToken', isEqualTo: AppSecrets.firestoreToken)
        .where('caregiverEmail', isEqualTo: caregiverEmail)
        .where('status', isEqualTo: 'approved')
        .snapshots();
  }

  Future<void> scanFromGallery() async {
    try {
      isLoading.value = true;
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return;

      final controller = scannerController ?? MobileScannerController();
      final result = await controller.analyzeImage(image.path);
      final scannedData = result?.barcodes.firstOrNull?.rawValue;

      if (scannedData == null) throw 'No QR code detected'.tr;
      if (scannedData.isEmpty) throw 'Invalid empty QR code'.tr;

      await sendPairingRequest(scannedData);
    } catch (e) {
      showAppSnackBar(
        alertType: AlertType.fail,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    scannerController?.dispose();
    super.onClose();
  }
}