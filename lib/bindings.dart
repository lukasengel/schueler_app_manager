import 'package:get/get.dart';

import './controllers/authentication.dart';
import './controllers/web_data.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(Authentication());
    Get.put(WebData());
  }
}
