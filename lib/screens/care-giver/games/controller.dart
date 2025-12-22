import 'package:get/get.dart';

class CareGiverGameController extends GetxController {
  var highScore = RxInt(99999);

  void updateHighScore(int currentScore) {
    if (currentScore < highScore.value) {
      highScore.value = currentScore;
      update();
    }
  }
}
