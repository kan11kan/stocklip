import 'package:get/get.dart';
import 'package:one_app_everyday921/domain/daily_class.dart';

class DailyDataController extends GetxController {
  final RxList<Daily> dailyRecords = <Daily>[].obs;
  // final todayMemos = <String>[];
  var dailyRecord = Daily().obs;
}
