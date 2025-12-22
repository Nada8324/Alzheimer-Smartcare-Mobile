import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:alzheimer_smartcare/utils/constants/colors.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_app_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_button.dart';
import 'package:alzheimer_smartcare/utils/custom_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/constants/alerts.dart';
import '../../../../utils/custom_widgets/custom_app_bar.dart';
import '../../../utils/custom_widgets/custom_app_image.dart';
import '../Schedule/model.dart';
import 'controller.dart';
import 'inputField.dart';

class AddTaskPage extends StatefulWidget {
  final Reminder? editReminder;

  const AddTaskPage({super.key, this.editReminder});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController taskController = Get.put(TaskController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedType = "Medicine";
  List<String> typeList = ["Medicine", "Event", "Birthday"];
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  int selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  Uint8List? imageBytes;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.editReminder != null) {
      // Fill from existing reminder
      titleController.text = widget.editReminder!.title;
      descriptionController.text = widget.editReminder!.description ?? '';
      selectedType = widget.editReminder!.type;
      selectedDate = widget.editReminder!.date;
      startTime = TimeOfDay.fromDateTime(widget.editReminder!.startTime);
      endTime = TimeOfDay.fromDateTime(widget.editReminder!.endTime);
      selectedRepeat = widget.editReminder!.repeat;

      // Handle image
      if (widget.editReminder!.imageBase64 != null &&
          widget.editReminder!.imageBase64!.isNotEmpty) {
        try {
          imageBytes = base64Decode(widget.editReminder!.imageBase64!);
        } catch (e) {
          print("Error decoding image: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      bgColor: AppColors.white,
      appBar: customAppBar(
        context,
        backgroundColor: AppColors.white,
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                widget.editReminder != null
                    ? "Edit Reminder".tr
                    : "Add Reminder".tr,
                color: AppColors.homeGreyText,
                fontSize: 24,
              ),
              SizedBox(height: 10.h),
              if (selectedImage != null || imageBytes != null)
                Center(
                  child: AppImage(
                    memoryImageBytes: imageBytes,
                    width: 130.w,
                    fit: BoxFit.cover,
                  ),
                ),
              Column(
                children: [
                  AppButton(
                    buttonType: ButtonType.elevated,
                    borderRadius: BorderRadius.circular(15),
                    bgColor: AppColors.secondary,
                    onPressed: pickImageFromCamera,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          "Take Photo".tr,
                          fontSize: 17.sp,
                          color: AppColors.white,
                        ),
                        SizedBox(width: 3.w),
                        Icon(Icons.camera),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  AppButton(
                    buttonType: ButtonType.elevated,
                    bgColor: AppColors.secondary,
                    borderRadius: BorderRadius.circular(15),
                    onPressed: pickImageFromGallery,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          "Select Image".tr,
                          fontSize: 17.sp,
                          color: AppColors.white,
                        ),
                        SizedBox(width: 3.w),
                        Icon(Icons.upload),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              MyInputField(
                title: "Title".tr,
                hint: "Enter your title".tr,
                controller: titleController,
              ),
              MyInputField(
                title: "Description".tr,
                hint: "Enter your description".tr,
                controller: descriptionController,
              ),
              MyInputField(
                title: "Type".tr,
                hint: selectedType.tr,
                widget: DropdownButton<String>(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue!;
                    });
                  },
                  items: typeList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: AppText(value.tr, color: AppColors.homeGreyText),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: "Date".tr,
                hint: DateFormat.yMd().format(selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                  onPressed: getDateFromUser,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time".tr,
                      hint: startTime.format(context),
                      widget: IconButton(
                        onPressed: () => getTimeFromUser(isStartTime: true),
                        icon:
                        Icon(Icons.access_time_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: MyInputField(
                      title: "End Time".tr,
                      hint: endTime.format(context),
                      widget: IconButton(
                        onPressed: () => getTimeFromUser(isStartTime: false),
                        icon:
                        Icon(Icons.access_time_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: "Repeat".tr,
                hint: selectedRepeat.tr,
                widget: DropdownButton<String>(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRepeat = newValue!;
                    });
                  },
                  items:
                  repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: AppText(value.tr, color: AppColors.homeGreyText),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 18.h),
              AppButton(
                buttonType: ButtonType.elevated,
                borderRadius: BorderRadius.circular(15),
                bgColor: AppColors.secondary,
                text: widget.editReminder != null
                    ? "Update Reminder".tr
                    : "Create Reminder".tr,
                textSize: 20,
                onPressed: validateData,
              ),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> validateData() async {
    if (titleController.text.isNotEmpty) {
      // Create DateTime objects from selected date and times
      final startDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        startTime.hour,
        startTime.minute,
      );

      final endDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        endTime.hour,
        endTime.minute,
      );

      // Validation checks
      if (startDateTime.isBefore(DateTime.now())) {
        showAppSnackBar(
          alertType: AlertType.warning,
          message: "Start time must be in the future!".tr,
          borderRadius: 30.r,
        );
        return;
      }

      if (endDateTime.isBefore(startDateTime)) {
        showAppSnackBar(
          alertType: AlertType.warning,
          message: "End time must be after start time!".tr,
          borderRadius: 30.r,
        );
        return;
      }

      await addTaskToDb(startDateTime, endDateTime);
    } else {
      showAppSnackBar(
        alertType: AlertType.warning,
        message: "Title is required!".tr,
        borderRadius: 30.r,
      );
    }
  }

  Future<void> addTaskToDb(DateTime startTimeObj, DateTime endTimeObj) async {
    try {
      String imageBase64 = await convertImageToBase64();

      final reminder = Reminder(
        id: widget.editReminder?.id ?? '',
        title: titleController.text,
        description: descriptionController.text,
        date: startTimeObj,
        startTime: startTimeObj,
        endTime: endTimeObj,
        repeat: selectedRepeat,
        type: selectedType,
        isCompleted: widget.editReminder?.isCompleted ?? false,
        imageBase64: imageBase64,
      );

      // Save or update the reminder
      if (widget.editReminder != null) {
        await taskController.updateReminder(reminder);
      } else {
        await taskController.addTask(task: reminder);
      }

      Get.back(result: true);
      showAppSnackBar(
        alertType: AlertType.success,
        message: widget.editReminder != null
            ? "Reminder Updated Successfully".tr
            : "Reminder Added Successfully".tr,
        borderRadius: 30,
      );
    } catch (e) {
      showAppSnackBar(
        alertType: AlertType.fail,
        message: "Error: ${e.toString()}",
        borderRadius: 30,
      );
    }
  }

  Future<void> getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2500),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.secondary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.secondary,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickerDate != null) {
      setState(() {
        selectedDate = pickerDate;
      });
    }
  }

  Future<void> getTimeFromUser({required bool isStartTime}) async {
    final now = DateTime.now();
    final currentTime = TimeOfDay.now();
    final bufferTime = TimeOfDay(
      hour: currentTime.hour + ((currentTime.minute + 10) ~/ 60),
      minute: (currentTime.minute + 10) % 60,
    );

    TimeOfDay initialTime;
    if (isStartTime) {
      initialTime = startTime;
    } else {
      initialTime = endTime;
    }

    final adjustedTime = initialTime.hour < bufferTime.hour ||
        (initialTime.hour == bufferTime.hour &&
            initialTime.minute < bufferTime.minute)
        ? bufferTime
        : initialTime;

    var pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: adjustedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.secondary,
              onPrimary: AppColors.white,
              onSurface: AppColors.secondary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.white,
                backgroundColor: AppColors.secondary,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = pickedTime;
        } else {
          endTime = pickedTime;
        }
      });
    }
  }

  Future<void> pickImageFromGallery() async {
    final returnedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);

    if (returnedImage != null) {
      setState(() {
        selectedImage = File(returnedImage.path);
      });
      final bytes = await selectedImage!.readAsBytes();
      setState(() {
        imageBytes = bytes;
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    final returnedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 25);

    if (returnedImage != null) {
      setState(() {
        selectedImage = File(returnedImage.path);
        //imageBytes = null;
      });
      final bytes = await selectedImage!.readAsBytes();
      setState(() {
        imageBytes = bytes;
      });
    }
  }

  Future<String> convertImageToBase64() async {
    if (selectedImage != null) {
      final bytes = await selectedImage!.readAsBytes();
      return base64Encode(bytes);
    }
    if (imageBytes != null) {
      return base64Encode(imageBytes!);
    }
    return '';
  }
}