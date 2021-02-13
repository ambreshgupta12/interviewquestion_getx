import 'package:get/get.dart';
import 'package:interviewquestion/controller/controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
