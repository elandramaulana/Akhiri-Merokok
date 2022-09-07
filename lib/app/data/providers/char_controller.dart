import 'package:akhiri_merokok/app/data/providers/database_service.dart';
import 'package:get/get.dart';

import '../models/chart.dart';

class ChartController extends GetxController {
  final DatabaseService database = DatabaseService();

  var stats = Future.value(<RokokChart>[]).obs;

  ChartController(Future<List<RokokChart>> ss);

  @override
  void onInit() {
    stats.value = database.getRokokStats();
    super.onInit();
  }
}
