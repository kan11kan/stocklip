import 'package:get/get.dart';

class RecordController extends GetxController {}

///選択期間（開始日都終了日）の変更及びキーワードの変更を監視するコントローラーを作成
class SearchKeyController extends GetxController {
  var startDay = ''.obs;
  var endDay = ''.obs;
}
