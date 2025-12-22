import 'dart:async';
import 'dart:convert';

import 'package:alzheimer_smartcare/screens/patient/Schedule/model.dart';
import 'package:alzheimer_smartcare/utils/constants/alerts.dart';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_image.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_button.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';

import '../../../global_controllers/main_app_controller.dart';
import '../../../global_controllers/notifications_controller.dart';
import '../../../utils/custom_helpers/cache_helper.dart';
import '../../../utils/custom_helpers/db_helper.dart';
import '../AddReminders/addTask.dart';

enum SortType { category, dateTime, az }

enum SortOrder { ascending, descending }

class PatientScheduleController extends GetxController {
  final searchController = TextEditingController();
  final RxString searchQuery = RxString('');
  var reminders = <Reminder>[].obs;
  final Rx<SortType?> selectedSortType = Rx<SortType?>(null);
  final Rx<SortOrder?> selectedSortOrder = Rx<SortOrder?>(null);
  final RxList<String> selectedFilters = <String>[].obs;
  Timer? _autoUpdateTimer;
  final RxBool isLoading = true.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String userEmail; // To store current user email
  StreamSubscription<QuerySnapshot>? _remindersSubscription;
  bool _isProcessingExpired = false;
  @override
  void onInit() {
    super.onInit();
    final loginModel = CacheHelper().getUserInfo();
    userEmail = loginModel?.email ?? "";
    print(userEmail);
    _setupRemindersStream();
    _autoUpdateTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _deleteExpiredReminders();
    });
    _isProcessingExpired = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deleteExpiredReminders();
    });
  }


  @override
  void onClose() {
    _remindersSubscription?.cancel();
    _autoUpdateTimer?.cancel();
    for (var reminder in reminders) {
      reminder.dispose();
    }
    super.onClose();
  }
  DateTime _addOneMonth(DateTime date) {
    int year = date.year;
    int month = date.month + 1;
    int day = date.day;

    if (month > 12) {
      year++;
      month = 1;
    }

    int lastDay = DateTime(year, month + 1, 0).day;
    if (day > lastDay) {
      day = lastDay;
    }

    return DateTime(year, month, day, date.hour, date.minute, date.second);
  }

  Future<void> _deleteExpiredReminders() async {
    if (_isProcessingExpired || userEmail.isEmpty) return;
    _isProcessingExpired = true;

    try {
      final now = DateTime.now();
      final expiredReminders = await _firestore
          .collection('patients')
          .doc(userEmail)
          .collection('reminders')
          .where('endTime', isLessThan: Timestamp.fromDate(now))
          .get();

      if (expiredReminders.docs.isEmpty) {
        _isProcessingExpired = false;
        return;
      }

      final batch = _firestore.batch();
      List<Reminder> remindersToReschedule = [];
      bool hasOperations = false;

      for (var doc in expiredReminders.docs) {
        final data = doc.data();
        final repeat = data['repeat'] ?? 'None';

        if (repeat == 'None') {
          // Delete non-repeating
          batch.delete(doc.reference);
          hasOperations = true;
        } else {

          final currentStart = (data['startTime'] as Timestamp).toDate();
          final currentEnd = (data['endTime'] as Timestamp).toDate();

          DateTime nextStart;
          DateTime nextEnd;

          switch (repeat) {
            case 'Daily':
              nextStart = currentStart.add(const Duration(days: 1));
              nextEnd = currentEnd.add(const Duration(days: 1));
              break;
            case 'Weekly':
              nextStart = currentStart.add(const Duration(days: 7));
              nextEnd = currentEnd.add(const Duration(days: 7));
              break;
            case 'Monthly':
              nextStart = _addOneMonth(currentStart);
              nextEnd = _addOneMonth(currentEnd);
              break;
            default:
              continue;
          }

          batch.update(doc.reference, {
            'startTime': Timestamp.fromDate(nextStart),
            'endTime': Timestamp.fromDate(nextEnd),
            'isCompleted': false,
            'date': Timestamp.fromDate(DateTime(nextStart.year, nextStart.month, nextStart.day)),
          });
          hasOperations = true;

          remindersToReschedule.add(Reminder(
            id: doc.id,
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            isCompleted: false,
            date: DateTime(nextStart.year, nextStart.month, nextStart.day),
            startTime: nextStart,
            endTime: nextEnd,
            repeat: repeat,
            imageBase64: data['imageBase64'],
            type: data['type'] ?? 'Medicine',
          ));
        }
      }

      if (hasOperations) {
        await batch.commit();
      }
      print('Processed ${expiredReminders.docs.length} expired reminders');
    } catch (e) {
      print('Error processing expired reminders: $e');
    } finally {
      _isProcessingExpired = false;
    }
  }
  void _setupRemindersStream() {
    if (userEmail.isEmpty) {
      print("User email not available for reminders");
      return;
    }

    try {
      _remindersSubscription = _firestore
          .collection('patients')
          .doc(userEmail)
          .collection('reminders')
          .orderBy('startTime', descending: false)
          .snapshots()
          .listen(
              (snapshot) => _processSnapshot(snapshot),
          onError: (error) {
            print("Firestore error: $error");
            showAppSnackBar(
                alertType: AlertType.fail,
                message: "Failed to load reminders"
            );
          }
      );
    } catch (e) {
      print("Error setting up reminders stream: $e");
    }
  }
  void _processSnapshot(QuerySnapshot snapshot) {

      final newReminders = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
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
      }).toList();

    // Start timers for new reminders
    for (final reminder in newReminders) {
      reminder.startTimer();
    }

    reminders.assignAll(newReminders);
    isLoading.value = false;
  }
  void SearchChanged(String value) {
    searchQuery.value = value;
    update();
  }

  void Clear() {
    searchController.clear();
    searchQuery.value = '';

    selectedFilters.clear();

    selectedSortType.value = null;
    selectedSortOrder.value = null;



    update();
  }

  void SearchSubmitted(String value) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void EditReminder(Reminder reminder) async {
    final result = await Get.to(()=>AddTaskPage(editReminder: reminder));
    if (result == true) {
      try {
        MainAppController.showLoading();

      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  void sortReminders() {
    if (selectedSortType.value == null || selectedSortOrder.value == null)
      return;

    reminders.sort((a, b) {
      int comparison = 0;
      switch (selectedSortType.value!) {
        case SortType.category:
          comparison = a.type.compareTo(b.type);
          break;
        case SortType.dateTime:
          comparison = _parseDateTime(a).compareTo(_parseDateTime(b));
          break;
        case SortType.az:
          comparison = a.title.compareTo(b.title);
          break;
      }
      return selectedSortOrder.value == SortOrder.ascending
          ? comparison
          : -comparison;
    });
    update();
  }

  DateTime _parseDateTime(Reminder reminder) {
    return reminder.startTime;
  }

  Widget buildListItem(Reminder item) {
    // Convert UTC times to local time
    final localDate = item.date.toLocal();
    final localStartTime = item.startTime.toLocal();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      height: 150.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: Container(
          width: double.infinity,
          child: Row(
            children: [
              // Image container
              Container(
                width: 130.w,
                height: 150.h,
                child: AppImage(
                  memoryImageBytes: item.imageBase64 != null && item.imageBase64!.isNotEmpty
                      ? base64Decode(item.imageBase64!)
                      : null,
                  width: 130.w,
                  height: 150.h,
                  placeHolder: Container(
                    color: AppColors.lightGrey,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            IconsaxPlusBold.image,
                            size: 30,
                            color: AppColors.homeGreyText,
                          ),
                          SizedBox(height: 8.h),
                          AppText(
                            "No Image".tr,
                            fontSize: 12.sp,
                            color: AppColors.homeGreyText,
                          ),
                        ],
                      ),
                    ),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  item.title,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.sp,
                                  color: AppColors.black,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 4),
                                AppText(
                                  item.description,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                  color: AppColors.inActiveIconPatient,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          AppButton(
                            buttonType: ButtonType.icon,
                            onPressed: () => EditReminder(item),
                            child: Icon(
                              IconsaxPlusBold.edit_2,
                              color: AppColors.inActiveIconPatient
                                  .withValues(alpha: 0.33),
                              size: 16,
                            ),
                            bgColor: AppColors.white,
                          ),
                        ],
                      ),
                      Spacer(),
                      AppText(
                        "Time Left",
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                        color: AppColors.inActiveIconPatient
                            .withValues(alpha: 0.35),
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => AppText(
                                item.timeLeft.value,
                                fontWeight: FontWeight.w700,
                                fontSize: 19.sp,
                                color: AppColors.yellow,
                              )),
                              Row(
                                children: [
                                  // Display local date
                                  AppText(
                                    DateFormat.yMd().format(localDate),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11.sp,
                                    color: AppColors.inActiveIconPatient.withValues(alpha: 0.66),
                                  ),
                                  SizedBox(width: 36.w),
                                  // Display local time
                                  AppText(
                                    DateFormat.jm().format(localStartTime),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11.sp,
                                    color: AppColors.inActiveIconPatient.withValues(alpha: 0.66),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: AppButton(
                              buttonType: ButtonType.inkwell,
                              width: 18.w,
                              height: 18.h,
                              onPressed: () async => await deleteReminder(item),
                              iconData: Icons.delete,
                              iconColor: AppColors.deleteIcon,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteReminder(Reminder reminder) async {
    final confirm = await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.r),
        ),
        backgroundColor: AppColors.white, // Background color
        shadowColor: AppColors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                "Are you sure you want to delete this reminder?".tr,
                textAlign: TextAlign.center,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.homeGreyText,
              ),
              SizedBox(height: 10.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppButton(
                      buttonType: ButtonType.elevated,
                      onPressed: () {
                        Get.back();
                      },
                      bgColor: AppColors.cancelButton,
                      borderRadius: BorderRadius.circular(49.r),
                      child: Center(
                          child: AppText(
                        "No".tr,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.homeGreyText,
                      )),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: AppButton(
                      buttonType: ButtonType.elevated,
                      onPressed: () async {
                        MainAppController.showLoading();
                        try {
                          await FirebaseFirestore.instance
                              .collection('patients')
                              .doc(userEmail)
                              .collection('reminders')
                              .doc(reminder.id)
                              .delete();
                          await fetchReminders();
                          Get.back();
                          showAppSnackBar(
                              alertType: AlertType.success,
                              message: "Reminder deleted successfullyyy".tr,
                              borderRadius: 30.r);
                        } catch (e) {
                          showAppSnackBar(
                              alertType: AlertType.fail,
                              message: "Failed to delete reminder".tr,
                              borderRadius: 30.r);
                        } finally {
                          EasyLoading.dismiss();
                        }
                      },
                      bgColor: AppColors.secondary,
                      borderRadius: BorderRadius.circular(49.r),
                      child: Center(
                          child: AppText(
                        "Yes".tr,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirm == true) {
      try {
        MainAppController.showLoading();

        // Delete from Firestore
        await _firestore
            .collection('patients')
            .doc(userEmail) // Use your user email
            .collection('reminders')
            .doc(reminder.id)
            .delete();
        Get.back();
        showAppSnackBar(
            alertType: AlertType.success,
            message: "Reminder deleted successfully".tr,
            borderRadius: 30.r
        );
      } catch (e) {
        showAppSnackBar(alertType: AlertType.fail,message: "Delete Reminder Failed");
      }
    }
  }

  void navigateToAddTask() async {
    final result = await Get.to(AddTaskPage());
    if (result == true) {
      try {
        MainAppController.showLoading();
        await fetchReminders();
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  Widget buildSection(String type, List<Reminder> reminders,
      PatientScheduleController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          type.tr,
          fontWeight: FontWeight.w700,
          fontSize: 24.sp,
          color: AppColors.homeGreyText,
        ),
        SizedBox(height: 12.h),
        Column(
          children: reminders.map((reminder) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: controller.buildListItem(reminder),
            );
          }).toList(),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  void showSortDialog(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.r),
        ),
      ),
      context: context,
      builder: (context) {
        return Obx(
          () => Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: AppText(
                    "Sort By".tr,
                    fontSize: 25.sp,
                    color: AppColors.homeGreyText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                buildTypeRadio("Category".tr, SortType.category),
                buildTypeRadio("Date & Time".tr, SortType.dateTime),
                buildTypeRadio("A/Z".tr, SortType.az),
                Center(
                  child: AppText(
                    "Order".tr,
                    fontSize: 25.sp,
                    color: AppColors.homeGreyText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                buildOrderRadio("ascending".tr, SortOrder.ascending),
                buildOrderRadio("descending".tr, SortOrder.descending),
                SizedBox(height: 6.h),
                AppButton(
                  buttonType: ButtonType.elevated,
                  text: "Done".tr,
                  textColor: AppColors.white,
                  bgColor: AppColors.secondary,
                  width: double.infinity,
                  onPressed: () {
                    sortReminders();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTypeRadio(String text, SortType value) {
    bool isSelected = selectedSortType.value == value;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          width: 2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 10),
      child: RadioListTile<SortType>(
        title: AppText(
          text,
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
          color: isSelected
              ? AppColors.homeGreyText
              : Color(0xff393E4680).withValues(alpha: 0.5),
        ),
        value: value,
        groupValue: selectedSortType.value,
        dense: true,
        contentPadding: EdgeInsets.zero,
        activeColor: AppColors.secondary,
        selected: isSelected,
        onChanged: (SortType? value) {
          selectedSortType.value = value;
          update();
        },
      ),
    );
  }

  Future<void> fetchReminders() async {
    isLoading.value = true;
    if (_remindersSubscription == null) {
      _setupRemindersStream();
    }
    await Future.delayed(Duration(seconds: 1));
    isLoading.value = false;
  }

  Widget buildOrderRadio(String text, SortOrder value) {
    bool isSelected = selectedSortOrder.value == value;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          width: 2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 10),
      child: RadioListTile<SortOrder>(
        title: AppText(
          text,
          fontWeight: FontWeight.w700,
          fontSize: 18.sp,
          color: isSelected
              ? AppColors.homeGreyText
              : Color(0xff393E4680).withValues(alpha: 0.5),
        ),
        value: value,
        groupValue: selectedSortOrder.value,
        dense: true,
        contentPadding: EdgeInsets.zero,
        activeColor: AppColors.secondary,
        selected: isSelected,
        onChanged: (SortOrder? value) {
          selectedSortOrder.value = value;
          update();
        },
      ),
    );
  }

  List<Reminder> get filteredReminders {
    return reminders.where((reminder) {
      // Apply category filters
      final categoryMatch =
          selectedFilters.isEmpty || selectedFilters.contains(reminder.type);

      // Apply search query
      final searchLower = searchQuery.value.toLowerCase();
      final titleMatch = reminder.title.toLowerCase().contains(searchLower);
      final descMatch =
          reminder.description.toLowerCase().contains(searchLower);

      return categoryMatch && (titleMatch || descMatch);

    }).toList();
  }

  void toggleFilter(String category) {
    if (selectedFilters.contains(category)) {
      selectedFilters.remove(category);
    } else {
      selectedFilters.add(category);
    }
    update();
  }

  void showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      ),
      builder: (context) {
        return Obx(
          () => Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: AppText(
                    "Filter By Category".tr,
                    fontSize: 25.sp,
                    color: AppColors.homeGreyText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20.h),
                buildFilterChip("Medicine".tr),
                buildFilterChip("Event".tr),
                buildFilterChip("Birthday".tr),
                SizedBox(height: 25.h),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        buttonType: ButtonType.elevated,
                        text: "Clear All".tr,
                        bgColor: AppColors.lightGrey,
                        textColor: AppColors.homeGreyText,
                        onPressed: () {
                          selectedFilters.clear();
                          update();
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: AppButton(
                        buttonType: ButtonType.elevated,
                        text: "apply".tr,
                        bgColor: AppColors.secondary,
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String calculateTimeLeft(String date, String time) {
    try {
      DateFormat format = DateFormat("M/d/yyyy hh:mm a");
      DateTime targetDate = format.parse("$date $time");
      Duration difference = targetDate.difference(DateTime.now());

      if (difference.isNegative) {
        return "Expired";
      }

      int days = difference.inDays;
      int hours = difference.inHours % 24;
      int minutes = difference.inMinutes % 60;
      int seconds = difference.inSeconds % 60;

      return "${days}d ${hours}h ${minutes}m ${seconds}s";
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid Date";
    }
  }

  Widget buildFilterChip(String category) {
    bool isSelected = selectedFilters.contains(category);
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: ChoiceChip(
          label: AppText(category.tr),
          selected: isSelected,
          backgroundColor: AppColors.white,
          selectedColor: AppColors.secondary,
          labelStyle: TextStyle(
            fontSize: 20,
            color: isSelected ? AppColors.secondary : AppColors.homeGreyText,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
            side: BorderSide(color: AppColors.lightGrey),
          ),
          onSelected: (value) {
            toggleFilter(category);
            update();
          }),
    );
  }

}
