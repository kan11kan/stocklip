import 'package:get/get.dart';
import 'package:one_app_everyday921/domain/daily_data.dart';

class DailyDataController extends GetxController {
  final RxList<Daily> tmp = <Daily>[].obs;
  final todayMemos = <String>[];
  var records = Daily().obs;
}
