import 'package:akhiri_merokok/app/data/models/chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../firestore/bucket_firestore.dart';
import '../../data/providers/char_controller.dart';
import 'package:akhiri_merokok/firestore/bucket_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Statistic extends StatefulWidget {
  Statistic({Key? key}) : super(key: key);

  @override
  State<Statistic> createState() => _StatisticState();
}

final FirebaseFirestore chartDb = FirebaseFirestore.instance;

Future<List<RokokChart>> getRokokStats() {
  FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;
  String uid = auth.currentUser!.uid.toString();
  return chartDb
      .collection(FirestoreBucket.users)
      .doc(user.uid)
      .collection(FirestoreBucket.jadwal)
      .doc('2022')
      .collection('September')
      .orderBy('tanggal')
      .get()
      .then((querySnapshot) => querySnapshot.docs
          .asMap()
          .entries
          .map((entry) => RokokChart.fromSnapshot(entry.value, entry.key))
          .toList());
}

DateTime selectedDay = DateTime.now();
String? tanggal = selectedDay.day.toString();
String? bulan = selectedDay.month.toString();
String? tahun = selectedDay.year.toString();
Future<List<RokokChart>> data = getRokokStats();

class _StatisticState extends State<Statistic> {
  CalendarFormat format = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  num rata_perhari = 0;
  num total_rokok = 0;
  num rokok_terbanyak = 0;
  num rokok_terdikit = 0;
  String strRata = "0";
  FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;

  var chartController = ChartController(data);

  void updateChart(
    updateTanggal,
    updateBulan,
    updateTahun,
  ) {
    setState(() {
      tanggal = updateTanggal;
      bulan = updateBulan;
      tahun = updateTahun;
    });
  }

  void updateData(
    updateTotalRokok,
    updateRataPerhari,
    updateTerbanyak,
    updateTerdikit,
  ) {
    setState(() {
      rata_perhari = updateRataPerhari;
      total_rokok = updateTotalRokok;
      rokok_terbanyak = updateTerbanyak;
      rokok_terdikit = updateTerdikit;
      strRata = updateRataPerhari.toString() + ".0";
      strRata = strRata.substring(0, 3);
    });
  }

  List<String> page = ['Per Minggu', 'Per 2 Minggu', 'Per Bulan'];
  String? selectedPage = 'Per Minggu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Tampilkan Statistik Berdasarkan",
                    style: Get.theme.textTheme.headline4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: DropdownButtonFormField<String>(
                      dropdownColor: Colors.orange[50],
                      value: selectedPage,
                      items: page
                          .map((page) => DropdownMenuItem<String>(
                                value: page,
                                child: Text(page),
                              ))
                          .toList(),
                      onChanged: (page) {
                        _focusedDay = focusedDay;
                        String updateTanggal = focusedDay.day.toString();
                        String updateBulan = focusedDay.month.toString();
                        String updateTahun = focusedDay.year.toString();
                        var conveterbulan2 =
                            conveterbulan(focusedDay.month.toString());
                        updateChart(updateTanggal, updateBulan, updateTahun);

                        FirebaseFirestore chartDb = FirebaseFirestore.instance;
                        String uid = auth.currentUser!.uid.toString();

                        var data = FirebaseFirestore.instance
                            .collection(FirestoreBucket.users)
                            .doc(user.uid)
                            .collection(FirestoreBucket.jadwal)
                            .doc(focusedDay.year.toString())
                            .collection(conveterbulan2!);
                        data.snapshots().listen(
                          (event) {
                            num updateTotalRokok = 0;
                            num updateRataPerhari = 0;
                            num updateTerbanyak = 0;
                            num updateTerdikit = 0;
                            num m1 = 0;
                            num m2 = 0;
                            num m3 = 0;
                            num m4 = 0;
                            for (var doc in event.docs) {
                              updateTotalRokok =
                                  updateTotalRokok + doc.data()['jumlah'];
                              if (int.parse(doc.data()['tanggal']) < 8) {
                                m1 = m1 + doc.data()['jumlah'];
                              } else if (int.parse(doc.data()['tanggal']) <
                                  15) {
                                m2 = m2 + doc.data()['jumlah'];
                              } else if (int.parse(doc.data()['tanggal']) <
                                  22) {
                                m3 = m3 + doc.data()['jumlah'];
                              } else if (int.parse(doc.data()['tanggal']) <
                                  29) {
                                m4 = m4 + doc.data()['jumlah'];
                              }
                            }
                            var minggu = [m1, m2, m3, m4];
                            minggu.sort();
                            updateTerdikit = minggu[0];
                            updateTerbanyak = minggu[3];
                            updateRataPerhari = updateTotalRokok / 28;
                            updateData(updateTotalRokok, updateRataPerhari,
                                updateTerbanyak, updateTerdikit);
                          },
                        );

                        chartController.stats.value = chartDb
                            .collection(FirestoreBucket.users)
                            .doc(user.uid)
                            .collection(FirestoreBucket.jadwal)
                            .doc(tahun)
                            .collection(conveterbulan(bulan!)!)
                            .orderBy('tanggal')
                            .get()
                            .then((querySnapshot) => querySnapshot.docs
                                .asMap()
                                .entries
                                .map((entry) => RokokChart.fromSnapshot(
                                    entry.value, entry.key))
                                .toList());
                        // var ss = getRokokStats();
                        // chartController = ChartController(ss);
                        setState(() => selectedPage = page);
                      }),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Rata-Rata/Bulan',
                                      style: Get.theme.textTheme.headline4,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      strRata,
                                      style: Get.theme.textTheme.headline1,
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Total Rokok',
                                      style: Get.theme.textTheme.headline4,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      total_rokok.toString(),
                                      style: Get.theme.textTheme.headline1,
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Terbanyak/Bulan',
                                      style: Get.theme.textTheme.headline4,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      rokok_terbanyak.toString(),
                                      style: Get.theme.textTheme.headline1,
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Terdikit/Bulan',
                                      style: Get.theme.textTheme.headline4,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      rokok_terdikit.toString(),
                                      style: Get.theme.textTheme.headline1,
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                child: FutureBuilder(
                  future: chartController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<RokokChart>> snapshots) {
                    if (snapshots.hasData) {
                      return Container(
                        height: 250,
                        padding: const EdgeInsets.all(10),
                        child: CustomBarChart(rokokStats: snapshots.data!),
                      );
                    } else if (snapshots.hasError) {
                      return Text('${snapshots.error}');
                    }
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              Card(
                child: FutureBuilder(
                  future: chartController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<RokokChart>> snapshots) {
                    if (snapshots.hasData) {
                      return Container(
                        height: 250,
                        padding: const EdgeInsets.all(10),
                        child: CustomPieChart(rokokStats: snapshots.data!),
                      );
                    } else if (snapshots.hasError) {
                      return Text('${snapshots.error}');
                    }
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? conveterbulan(String mt) {
    var month = {
      '1': 'January',
      '2': 'February',
      '3': 'March',
      '4': 'April',
      '5': 'May',
      '6': 'June',
      '7': 'July',
      '8': 'August',
      '9': 'September',
      '10': 'October',
      '11': 'November',
      '12': 'December',
    };
    return month[mt];
  }
}

class CustomBarChart extends StatelessWidget {
  const CustomBarChart({
    Key? key,
    required this.rokokStats,
  }) : super(key: key);

  final List<RokokChart> rokokStats;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<RokokChart, String>> series = [
      charts.Series(
        id: 'jumlah',
        data: rokokStats,
        domainFn: (series, _) => series.tanggal.toString(),
        measureFn: (series, _) => series.jumlah,
        colorFn: (series, _) => series.barColor!,
      )
    ];

    return charts.BarChart(
      series,
      animate: true,
    );
  }
}

class CustomPieChart extends StatelessWidget {
  const CustomPieChart({
    Key? key,
    required this.rokokStats,
  }) : super(key: key);

  final List<RokokChart> rokokStats;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<RokokChart, String>> series = [
      charts.Series(
        id: 'jumlah',
        data: rokokStats,
        domainFn: (series, _) => series.tanggal.toString(),
        measureFn: (series, _) => series.jumlah,
        colorFn: (series, _) => series.barColor!,
      )
    ];

    return charts.PieChart(
      series,
      animate: true,
    );
  }
}
