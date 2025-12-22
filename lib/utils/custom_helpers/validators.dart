// import 'customMap/mapBloc.dart';

import 'package:get/get_utils/src/extensions/internacionalization.dart';

String? mobileValidate(v, {bool skipEmpty = false}) {
  if (!skipEmpty && (v == null || v.isEmpty)) {
    return "phone_validate1".tr;
  }
  // else if (v.length >= 2 && !v.toString().startsWith("05")) {
  //   return "phone_validate2".tr;
  // }
  else if (v != null && v.isNotEmpty && v.length < 10) {
    return "phone_validate3".tr;
  } else if (v != null && v.isNotEmpty && int.tryParse(v) == null) {
    return "phone_validate4".tr;
  } else {
    return null;
  }
}
String? fixedMobileValidate(v, {bool skipEmpty = false}) {
  if (!skipEmpty && (v == null || v.isEmpty)) {
    return "phone_validate1".tr;
  }
  else if (v != null && v.isNotEmpty && v.length != 8) {
    return "phone_validate5".tr;
  } else if (v != null && v.isNotEmpty && int.tryParse(v) == null) {
    return "phone_validate4".tr;
  } else {
    return null;
  }
}

bool mobileNumberValidate(String? mobile) {
  if ((mobile != null && mobile.isNotEmpty) &&
      (mobile.startsWith("00966") ||
          mobile.startsWith("+966") ||
          mobile.startsWith("966") ||
          mobile.startsWith("05"))) {
    return true;
  }
  return false;
}

String? taxValidate(v) {
  if (v.length > 0 && int.tryParse(v) == null) {
    return "tax_validate1".tr;
  } else if (v.length > 0 && v.length < 15) {
    return "tax_validate2".tr;
  } else {
    return null;
  }
}

String? emptyDropDownValidate(value) {
  if (value == null || value == "") {
    return "empty_validate".tr;
  } else {
    return null;
  }
}

String? emptyValidate(v) {
  if (v.isEmpty) {
    return "empty_validate".tr;
  } else {
    return null;
  }
}

String? priceValidate(v, {bool moreThanZero = false}) {
  if (v == null || v.isEmpty) {
    return "price_validate1".tr;
  } else if (double.tryParse(v) == null) {
    return "price_validate2".tr;
  } else if (double.parse(v) < 0) {
    return "price_validate3".tr;
  } else if (moreThanZero && double.parse(v) == 0) {
    return "price_validate4".tr;
  } else {
    return null;
  }
}

String? percentatgeValidate(v) {
  if (v.isEmpty) {
    return "empty_validate".tr;
  } else if ((double.tryParse(v) ?? 101) > 100 ||
      (double.tryParse(v) ?? -1) < 0) {
    return "wrong_percent".tr;
  } else {
    return null;
  }
}

String? numberValidate(v) {
  if (v.isNotEmpty && double.tryParse(v) == null) {
    return "wrong_number".tr;
  } else {
    return null;
  }
}

String? positiveIntValidate(v) {
  if (v.isNotEmpty && int.tryParse(v) == null || (int.tryParse(v) ?? 0) < 0) {
    return "wrong_number".tr;
  } else {
    return null;
  }
}

String? requiredNumberValidate(v) {
  if (v.isEmpty) {
    return "empty_validate".tr;
  }
  if (v.isNotEmpty && double.tryParse(v) == null) {
    return "wrong_number".tr;
  } else {
    return null;
  }
}

String? quantityValidate(v, {bool allowEmpty = false}) {
  if (v == null || v.isEmpty) {
    return "empty_validate".tr;
  } else if (double.tryParse(v) == null) {
    return "wrong_number".tr;
  } else if (double.parse(v) <= 0) {
    return "quantity_validate3".tr;
  } else {
    return null;
  }
}

String? discountValidate(v) {
  if (v?.isNotEmpty == true &&
      (double.tryParse(v) == null || double.parse(v) < 0)) {
    return "wrong_number".tr;
  } else {
    return null;
  }
}

String? entityNumberValidate(
  v,
  {bool allowEmpty=false}
) {
  if (!allowEmpty&& v.isEmpty) {
    return "transaction_required".tr;
  } else if (v.isNotEmpty && double.tryParse(v) == null) {
    return "wrong_number".tr;
  } else {
    return null;
  }
}

String? nameValidate(v) {
  if (v.isEmpty) {
    return "name_validate".tr;
  } else {
    return null;
  }
}

String? nullVaildate(String? v) {
  return null;
}

String? emailValidate(v) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern.toString());
  if (v.length > 0 && !regex.hasMatch(v)) {
    return "email_validate".tr;
  } else {
    return null;
  }
}

String? passwordValidate(v) {
  if (v == null || v.isEmpty) {
    return "password_validate1".tr;
  } else if (v.length < 8) {
    return "password_validate2".tr;
  } else {
    return null;
  }
}

String? doublePasswordValidate(v1, v2) {
  if (v1 == null || v1.isEmpty) {
    return "password_validate1".tr;
  } else if (v1.length < 8) {
    return "password_validate2".tr;
  } else if (v1 != v2) {
    return "double_password_validate".tr;
  } else {
    return null;
  }
}

String? onlyStringValidate(v) {
  if (v != null && v != "") {
    final hasSpecialCharacters = v.contains(RegExp(
        r'[!∆××÷π√•|`~£¢%€^¥°=}{\✓™®©٪@#$-/\:%^&*(),ـ<>,،؟|+؛=.?":{}|<>]'));
    if (hasSpecialCharacters ||
        v.contains("_") ||
        v.contains("]") ||
        v.contains("[") ||
        v.contains("\"") ||
        v.contains("\\")) {
      return "this_field_cannot_contain_special_characters".tr;
    }
  }
  return null;
}

replaceHindiNumsIntoArabicNums(String v) {
  String v2 = v
      .replaceAll("٠", "0")
      .replaceAll("١", "1")
      .replaceAll("٢", "2")
      .replaceAll("٣", "3")
      .replaceAll("٤", "4")
      .replaceAll("٥", "5")
      .replaceAll("٦", "6")
      .replaceAll("٧", "7")
      .replaceAll("٨", "8")
      .replaceAll("٩", "9");
  return v2;
}
