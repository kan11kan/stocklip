import 'package:get/get.dart';
import 'package:one_app_everyday921/domain/daily_class.dart';

class DailyDataController extends GetxController {
  final RxList<Daily> dailyRecords = <Daily>[].obs;
  var dailyRecord = Daily().obs;
  RxString memoContent = ''.obs;
}
