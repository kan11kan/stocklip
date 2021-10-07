import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:one_app_everyday921/domain/record_class.dart';

class WebController extends GetxController {
  final RxList<Record> records = <Record>[].obs;
  final todayUrls = <String>[];
  var record = Record().obs;

  @override
  void onInit() {
    // widgetにメモリが割り当てられ次第実行される
    super.onInit();
  }

  @override
  void onReady() {
    // widgetが描画され次第実行される
    super.onReady();
  }

  void onClose() {
    // controllerがメモリから削除される直前に実行される
    var endTime = DateTime.now();
    records.last.endTime = endTime;
    super.onClose();
  }
}
