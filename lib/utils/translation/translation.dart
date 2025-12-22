import 'package:alzheimer_smartcare/utils/translation/arabic.dart';
import 'package:alzheimer_smartcare/utils/translation/english.dart';
import 'package:get/get.dart';

enum Lang { en, ar }

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': en , 'ar_SA': ar};
}
