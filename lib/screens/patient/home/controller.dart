import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:alzheimer_smartcare/global_models/login_model.dart';
import 'package:alzheimer_smartcare/screens/patient/games/controller.dart';
import 'package:alzheimer_smartcare/utils/constants/assets.dart';
import 'package:alzheimer_smartcare/utils/custom_helpers/db_helper.dart';
import 'package:alzheimer_smartcare/utils/custom_helpers/dio_consumer.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import '../../../global_controllers/main_app_controller.dart';
import '../../../utils/constants/alerts.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/endpoints.dart';
import '../../../utils/custom_helpers/cache_helper.dart';
import '../../../utils/custom_widgets/custom_button.dart';
import '../../../utils/custom_widgets/custom_text.dart';
import '../AddReminders/addTask.dart';
import '../AddReminders/controller.dart';
import '../Schedule/model.dart';
import 'memoriesModel.dart';
import 'model.dart';

class PatientHomeController extends GetxController {
  final RxInt currentIndex = 0.obs;
  var user = Rxn<LogInModel>();
  var allReminders = <ReminderCardData>[].obs;


  Timer? _timer;


  List<Face> faces = [];
  final Rxn<Face> randomFace = Rxn<Face>();
  Timer? _rotationTimer;
  final _rnd = Random();
  final RxBool isLoading = true.obs;

  late RxString timeLeft;
  final TaskController taskController = Get.find<TaskController>();
  final PatientGameController patientGameController = Get.put(PatientGameController());
  DioConsumer dioConsumer = DioConsumer(dio: Dio(), baseUrl: Endpoints.baseUrl);

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }
  Future<void> loadInitialData() async {
    try {
      loadUserData();

      await getFacesList();

      startFaceRotation();
    } catch (e) {
      print("Error loading initial data: $e");
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onClose() {
    _timer?.cancel();
    _rotationTimer?.cancel();
    super.onClose();
  }

  void startCountdownTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    });
  }

  void loadUserData() {
    var userData = CacheHelper().getUserInfo();
    if (userData != null) {
      user.value = userData;
    }
  }

  Widget buildDotsIndicator(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Container(
          width: 6.w,
          height: 6.h,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.bgImageColor),
            color: currentIndex.value == index
                ? AppColors.bgImageColor
                : AppColors.transparent,
          ),
        );
      }),
    );
  }

  Widget BuildCard(ReminderCardData data) {
    return  Row(
      children: [
        Container(
          height: 47.h,
          width: 56.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                bottomLeft: Radius.circular(15.r)),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: AppText(
                data.backgroundLabels[0].tr,
                color: AppColors.inActiveIconPatient,
                fontWeight: FontWeight.w700,
                fontSize: 10.sp,
              ),
            ),
          ),
        ),
        Container(
          width: 230.w,
          padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(29.r),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                data.title.tr,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                height: (24.2 / 20).sp,
                maxLines: 2,
              ),
              AppText(
                data.description.tr,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.inActiveIconPatient,
                height: (14.52 / 12).sp,
                maxLines: 2,
              ),
              SizedBox(height: 17.h),
              Center(
                child: AppText(
                  "Time Left ".tr,
                  fontSize: 11.sp,
                  color: AppColors.inActiveIconPatient.withValues(alpha: 0.35),
                  height: (13.31 / 11).sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Center(
                child: Obx(() => AppText(
                  data.timeLeft.value,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.yellow,
                )),
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage(
                      svgAsset: AssetsPaths.bellSVG,
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    Column(
                      children: [
                        AppText("${data.date}",
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            height: (20.51 / 20).sp,
                            color: AppColors.inActiveIconPatient
                                .withValues(alpha: 0.66)),
                        AppText("${data.time}",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            height: (15.38 / 15).sp,
                            color: AppColors.inActiveIconPatient
                                .withValues(alpha: 0.66)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 47.h,
          width: 56.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.r),
                bottomRight: Radius.circular(15.r)),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AppText(
                data.backgroundLabels[1].tr,
                color: AppColors.inActiveIconPatient,
                fontWeight: FontWeight.w700,
                fontSize: 10.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String calculateTimeLeft(DateTime targetTime) {
    final now = DateTime.now();
    final difference = targetTime.difference(now);

    if (difference.isNegative) {
      return "Expired";
    }

    int days = difference.inDays;
    int hours = difference.inHours.remainder(24);
    int minutes = difference.inMinutes.remainder(60);
    int seconds = difference.inSeconds.remainder(60);

    return "${days}d ${hours}h ${minutes}m ${seconds}s";
  }

  Future<Reminder?> _getNearestReminderByType(String type) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(user.value?.email)
          .collection('reminders')
          .where('type', isEqualTo: type)
          .where('startTime', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('startTime', descending: false)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data(); // Cast to Map
        return Reminder(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          isCompleted: data['isCompleted'] ?? false,
          date: (data['date'] as Timestamp).toDate(),
          startTime: (data['startTime'] as Timestamp).toDate(),
          endTime: (data['endTime'] as Timestamp).toDate(),
          repeat: data['repeat'] ?? 'None',
          imageBase64: data['imageBase64'],
          type: data['type'] ?? 'Medicine',
        );
      }
      return null;
    } catch (e) {
      print('Error getting nearest $type reminder: $e');
      return null;
    }
  }

  Future<Widget> BuildSliderSection() async {

    // Get nearest reminders from Firestore
    Reminder? nearestMedicine = await _getNearestReminderByType("Medicine");
    Reminder? nearestEvent = await _getNearestReminderByType("Event");
    Reminder? nearestBirthday = await _getNearestReminderByType("Birthday");

    final List<ReminderCardData> items = [];

    void addTaskIfValid(Reminder? task, List<String> backgroundLabels) {
      if (task != null) {
        String initialTimeLeft = calculateTimeLeft(task.startTime);

        var reminder = ReminderCardData(
          id: task.id,
          title: task.title,
          description: task.description,
          date: DateFormat.yMd().format(task.date),
          time: DateFormat.jm().format(task.startTime),
          backgroundLabels: backgroundLabels,
          initialTimeLeft: initialTimeLeft,
        );

        items.add(reminder);

        // Timer for updating time left
        Timer.periodic(const Duration(seconds: 1), (timer) {
          String updatedTime = calculateTimeLeft(task.startTime);
          reminder.timeLeft.value = updatedTime;

          // if (updatedTime == "Expired") {
          //   timer.cancel();
          //   // Auto-delete expired task
          //   deleteReminder(task);
          // }
        });
      }
    }

    addTaskIfValid(nearestBirthday, ['Event', 'Medicine']);
    addTaskIfValid(nearestMedicine, ['Birthday', 'Event']);
    addTaskIfValid(nearestEvent, ['Medicine', 'Birthday']);

    int middleIndex = items.isEmpty ? 0 : (items.length / 2).floor();
    currentIndex.value = middleIndex;

    return Stack(
      children: [
        Column(
          children: [
            if (items.isEmpty)
              Center(
                child: Container(
                  height: 150.h,
                  width: 250.w,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Center(
                    child: AppText(
                      "No upcoming reminders".tr,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inActiveIconPatient,
                    ),
                  ),
                ),
              )
            else
              Column(
                children: [
                  CarouselSlider(

                    items: items.map((data) => BuildCard(data)).toList(),
                    options: CarouselOptions(

                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: true,
                      autoPlay: false,
                      padEnds: false,
                      initialPage: middleIndex,
                      onPageChanged: (index, reason) {
                        currentIndex.value = index;
                      },
                    ),
                  ),
                  Obx(() => buildDotsIndicator(items.length)),
                ],
              ),
          ],
        ),
        Positioned(
          bottom: 0.h,
          right: 0.w,
          child: AppButton(
              buttonType: ButtonType.floating,
              width: 60.w,
              height: 60.h,
              iconData: Icons.add,
              bgColor: AppColors.white,
              iconColor: AppColors.secondary,
              iconSize: 30,
              onPressed: () async {
                final result = await Get.to(AddTaskPage());
                if (result == true) {
                  await deleteExpiredTasks();
                  update();
                }
              }
          ),
        ),
      ],
    );
  }

  Future<void> deleteExpiredTasks() async {
    try {
      final now = Timestamp.now();
      final snapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(user.value?.email)
          .collection('reminders')
          .where('startTime', isLessThan: now)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting expired tasks: $e');
    }
  }

  Future<List<Face>> getFacesList() async {

    String? token =CacheHelper().getDataString(key: ApiKey.token);
    try {

      await dioConsumer.getData(
        Endpoints.storedFaces,

        queryParameters: {
          'token': token,
        },
        onSuccess: (data) {
          List<dynamic> rawList;
          if (data is List) {
            rawList = data;
          }
          else if (data is String) {
            rawList = json.decode(data) as List<dynamic>;
          } else {
            rawList = [];
          }
          faces = rawList
              .whereType<Map<String, dynamic>>()
              .where((m) =>
          m['name'] is String && m['base64Image'] is String)
              .map((m) => Face.fromJson(m))
              .toList();

          update();
        },
        onError: (error) {
          faces = [];
          update();
        },
      );
    } catch (error) {
      faces = [];
      update();
    }
    return faces;
  }

  void startFaceRotation() {
    _pickNewRandomFace();
    _rotationTimer?.cancel();
    _rotationTimer = Timer.periodic(
      const Duration(minutes: 5),
          (_) => _pickNewRandomFace(),
    );
  }

  void _pickNewRandomFace() {
    if (faces.isEmpty) {
      randomFace.value = null;
    } else {
      randomFace.value = faces[_rnd.nextInt(faces.length)];
    }
    update();
  }
}
