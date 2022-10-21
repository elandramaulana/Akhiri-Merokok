import 'dart:developer';
import 'dart:async';
import 'dart:ffi';

import 'package:collection/collection.dart';
import 'package:akhiri_merokok/app/data/models/chart.dart';
import 'package:akhiri_merokok/app/data/models/users.dart';
import 'package:akhiri_merokok/core/utils/keys.dart';
import 'package:akhiri_merokok/firestore/field_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

Stream<UserModel> readUser() {
  FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;
  return firebaseFirestore
      .collection(FirestoreBucket.users)
      .doc(user.uid)
      .snapshots()
      .map((event) => UserModel.fromMap(event.data()!));
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
  String datetime = "0";
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
    updateRatarata,
    updateTerbanyak,
    updateTerdikit,
  ) {
    setState(() {
      rata_perhari = updateRatarata;
      total_rokok = updateTotalRokok;
      rokok_terbanyak = updateTerbanyak;
      rokok_terdikit = updateTerdikit;
      strRata = updateRatarata.toString() + ".0";
      strRata = strRata.substring(0, 3);
    });
  }

  @override
  void initState() {
    super.initState();
    // apalah
    int hitungan = 7;
    List<num> list_rokok = [];
    num updateTotalRokok = 0;
    num updateRatarata = 0;
    num updateTerbanyak = 0;
    num updateTerdikit = 0;

    FirebaseFirestore chartDb = FirebaseFirestore.instance;
    chartDb.collection(FirestoreBucket.users).doc(user.uid).get().then((value) {
      datetime = value.data()?['timestamp'];
      datetime = datetime.toString();
      var registration_date = datetime.split(" ")[0].split("-");
      int awal;

      if (int.parse(registration_date[0]) == focusedDay.year) {
        if (int.parse(registration_date[1]) == focusedDay.month) {
          // Ketika belum 1 bulan
          chartController.stats.value = chartDb
              .collection(FirestoreBucket.users)
              .doc(user.uid)
              .collection(FirestoreBucket.jadwal)
              .doc(registration_date[0])
              .collection(
                  conveterbulan(int.parse(registration_date[1]).toString())!)
              .get()
              .then((value) {
            if (value.docs.length <= hitungan) {
              awal = 0;
            } else {
              awal = value.docs.length - hitungan;
            }
            var data = value.docs.getRange(awal, value.docs.length);
            data.toList().forEach((element) {
              list_rokok.add(element.data()['jumlah']);
            });
            updateTotalRokok = list_rokok.sum;
            updateTerdikit = list_rokok.min;
            updateTerbanyak = list_rokok.max;
            updateRatarata = list_rokok.average;
            updateData(updateTotalRokok, updateRatarata, updateTerbanyak,
                updateTerdikit);
            return value.docs
                .asMap()
                .entries
                .map((entry) => RokokChart.fromSnapshot(entry.value, entry.key))
                .toList()
                .getRange(awal, value.docs.length)
                .toList();
          });
        } else {
          // Ketika sudah 2 bulan
          chartController.stats.value = chartDb
              .collection(FirestoreBucket.users)
              .doc(user.uid)
              .collection(FirestoreBucket.jadwal)
              .doc(registration_date[0])
              .collection(conveterbulan(focusedDay.month.toString())!)
              .get()
              .then((value) {
            if (value.docs.length <= hitungan) {
              awal = 0;
            } else {
              awal = value.docs.length - hitungan;
            }
            var data = value.docs.getRange(awal, value.docs.length);
            var forChart = value.docs
                .asMap()
                .entries
                .map((entry) => RokokChart.fromSnapshot(entry.value, entry.key))
                .toList()
                .getRange(awal, value.docs.length)
                .toList();
            data.toList().forEach((element) {
              list_rokok.add(element.data()['jumlah']);
            });
            if (list_rokok.length < hitungan) {
              chartDb
                  .collection(FirestoreBucket.users)
                  .doc(user.uid)
                  .collection(FirestoreBucket.jadwal)
                  .doc(registration_date[0])
                  .collection(conveterbulan((focusedDay.month - 1).toString())!)
                  .get()
                  .then((value) {
                if (value.docs.length <= (hitungan - list_rokok.length)) {
                  awal = 0;
                } else {
                  awal = value.docs.length - (hitungan - list_rokok.length);
                }
                var data = value.docs.getRange(awal, value.docs.length);
                forChart += value.docs
                    .asMap()
                    .entries
                    .map((entry) =>
                        RokokChart.fromSnapshot(entry.value, entry.key))
                    .toList()
                    .getRange(awal, value.docs.length)
                    .toList();
                data.toList().forEach((element) {
                  list_rokok.add(element.data()['jumlah']);
                });
                data.toList().forEach((element) {
                  list_rokok.add(element.data()['jumlah']);
                });
                updateTotalRokok = list_rokok.sum;
                updateTerdikit = list_rokok.min;
                updateTerbanyak = list_rokok.max;
                updateRatarata = list_rokok.average;
                updateData(updateTotalRokok, updateRatarata, updateTerbanyak,
                    updateTerdikit);
                return forChart;
              });
            } else {
              updateTotalRokok = list_rokok.sum;
              updateTerdikit = list_rokok.min;
              updateTerbanyak = list_rokok.max;
              updateRatarata = list_rokok.average;
              updateData(updateTotalRokok, updateRatarata, updateTerbanyak,
                  updateTerdikit);
              return forChart;
            }
            return forChart;
          });
        }
      } else {
        // Ketika beda tahun
        if (focusedDay.month == 1) {
          // Ketika masih dibulan january
          chartController.stats.value = chartDb
              .collection(FirestoreBucket.users)
              .doc(user.uid)
              .collection(FirestoreBucket.jadwal)
              .doc(focusedDay.year.toString())
              .collection(conveterbulan(focusedDay.month.toString())!)
              .get()
              .then((value) {
            if (value.docs.length <= hitungan) {
              awal = 0;
            } else {
              awal = value.docs.length - hitungan;
            }
            var data = value.docs.getRange(awal, value.docs.length);
            var forChart = value.docs
                .asMap()
                .entries
                .map((entry) => RokokChart.fromSnapshot(entry.value, entry.key))
                .toList()
                .getRange(awal, value.docs.length)
                .toList();
            data.toList().forEach((element) {
              list_rokok.add(element.data()['jumlah']);
            });
            if (list_rokok.length < hitungan) {
              chartDb
                  .collection(FirestoreBucket.users)
                  .doc(user.uid)
                  .collection(FirestoreBucket.jadwal)
                  .doc((focusedDay.year - 1).toString())
                  .collection(conveterbulan("12")!)
                  .get()
                  .then((value) {
                if (value.docs.length <= (hitungan - list_rokok.length)) {
                  awal = 0;
                } else {
                  awal = value.docs.length - (hitungan - list_rokok.length);
                }
                var data = value.docs.getRange(awal, value.docs.length);
                forChart += value.docs
                    .asMap()
                    .entries
                    .map((entry) =>
                        RokokChart.fromSnapshot(entry.value, entry.key))
                    .toList()
                    .getRange(awal, value.docs.length)
                    .toList();
                data.toList().forEach((element) {
                  list_rokok.add(element.data()['jumlah']);
                });
                updateTotalRokok = list_rokok.sum;
                updateTerdikit = list_rokok.min;
                updateTerbanyak = list_rokok.max;
                updateRatarata = list_rokok.average;
                updateData(updateTotalRokok, updateRatarata, updateTerbanyak,
                    updateTerdikit);
                return forChart;
              });
            }
            updateTotalRokok = list_rokok.sum;
            updateTerdikit = list_rokok.min;
            updateTerbanyak = list_rokok.max;
            updateRatarata = list_rokok.average;
            updateData(updateTotalRokok, updateRatarata, updateTerbanyak,
                updateTerdikit);
            return forChart;
          });
        } else {
          chartController.stats.value = chartDb
              .collection(FirestoreBucket.users)
              .doc(user.uid)
              .collection(FirestoreBucket.jadwal)
              .doc(focusedDay.year.toString())
              .collection(conveterbulan(focusedDay.month.toString())!)
              .get()
              .then((value) {
            if (value.docs.length <= hitungan) {
              awal = 0;
            } else {
              awal = value.docs.length - hitungan;
            }
            var data = value.docs.getRange(awal, value.docs.length);
            var forChart = value.docs
                .asMap()
                .entries
                .map((entry) => RokokChart.fromSnapshot(entry.value, entry.key))
                .toList()
                .getRange(awal, value.docs.length)
                .toList();
            data.toList().forEach((element) {
              list_rokok.add(element.data()['jumlah']);
            });
            if (list_rokok.length < hitungan) {
              chartDb
                  .collection(FirestoreBucket.users)
                  .doc(user.uid)
                  .collection(FirestoreBucket.jadwal)
                  .doc(focusedDay.year.toString())
                  .collection(conveterbulan((focusedDay.month - 1).toString())!)
                  .get()
                  .then((value) {
                if (value.docs.length <= (hitungan - list_rokok.length)) {
                  awal = 0;
                } else {
                  awal = value.docs.length - (hitungan - list_rokok.length);
                }
                var data = value.docs.getRange(awal, value.docs.length);
                forChart += value.docs
                    .asMap()
                    .entries
                    .map((entry) =>
                        RokokChart.fromSnapshot(entry.value, entry.key))
                    .toList()
                    .getRange(awal, value.docs.length)
                    .toList();
                data.toList().forEach((element) {
                  list_rokok.add(element.data()['jumlah']);
                });
                updateTotalRokok = list_rokok.sum;
                updateTerdikit = list_rokok.min;
                updateTerbanyak = list_rokok.max;
                updateRatarata = list_rokok.average;
                updateData(updateTotalRokok, updateRatarata, updateTerbanyak,
                    updateTerdikit);
                return forChart;
              });
            }
            updateTotalRokok = list_rokok.sum;
            updateTerdikit = list_rokok.min;
            updateTerbanyak = list_rokok.max;
            updateRatarata = list_rokok.average;
            updateData(updateTotalRokok, updateRatarata, updateTerbanyak,
                updateTerdikit);
            return forChart;
          });
        }
      }
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
                      // trigger statistik per waktu
                      onChanged: (page) async {
                        _focusedDay = focusedDay;
                        String updateTanggal = focusedDay.day.toString();
                        String updateBulan = focusedDay.month.toString();
                        String updateTahun = focusedDay.year.toString();

                        updateChart(updateTanggal, updateBulan, updateTahun);

                        // apalah
                        int hitungan = 7;
                        switch (page) {
                          case "Per Minggu":
                            {
                              hitungan = 7;
                            }
                            break;

                          case "Per 2 Minggu":
                            {
                              hitungan = 14;
                            }
                            break;

                          default:
                            {
                              hitungan = 30;
                            }
                            break;
                        }

                        List<num> list_rokok = [];
                        num updateTotalRokok = 0;
                        num updateRatarata = 0;
                        num updateTerbanyak = 0;
                        num updateTerdikit = 0;

                        FirebaseFirestore chartDb = FirebaseFirestore.instance;
                        chartDb
                            .collection(FirestoreBucket.users)
                            .doc(user.uid)
                            .get()
                            .then((value) {
                          datetime = value.data()?['timestamp'];
                          datetime = datetime.toString();
                          var registration_date =
                              datetime.split(" ")[0].split("-");
                          int awal;
                          if (int.parse(registration_date[0]) ==
                              focusedDay.year) {
                            if (int.parse(registration_date[1]) ==
                                focusedDay.month) {
                              // Ketika belum 1 bulan
                              chartController.stats.value = chartDb
                                  .collection(FirestoreBucket.users)
                                  .doc(user.uid)
                                  .collection(FirestoreBucket.jadwal)
                                  .doc(registration_date[0])
                                  .collection(conveterbulan(
                                      int.parse(registration_date[1])
                                          .toString())!)
                                  .get()
                                  .then((value) {
                                if (value.docs.length <= hitungan) {
                                  awal = 0;
                                } else {
                                  awal = value.docs.length - hitungan;
                                }
                                var data = value.docs
                                    .getRange(awal, value.docs.length);
                                data.toList().forEach((element) {
                                  list_rokok.add(element.data()['jumlah']);
                                });
                                updateTotalRokok = list_rokok.sum;
                                updateTerdikit = list_rokok.min;
                                updateTerbanyak = list_rokok.max;
                                updateRatarata = list_rokok.average;
                                updateData(updateTotalRokok, updateRatarata,
                                    updateTerbanyak, updateTerdikit);
                                return value.docs
                                    .asMap()
                                    .entries
                                    .map((entry) => RokokChart.fromSnapshot(
                                        entry.value, entry.key))
                                    .toList()
                                    .getRange(awal, value.docs.length)
                                    .toList();
                              });
                            } else {
                              // Ketika sudah 2 bulan
                              chartController.stats.value = chartDb
                                  .collection(FirestoreBucket.users)
                                  .doc(user.uid)
                                  .collection(FirestoreBucket.jadwal)
                                  .doc(registration_date[0])
                                  .collection(conveterbulan(
                                      focusedDay.month.toString())!)
                                  .get()
                                  .then((value) {
                                if (value.docs.length <= hitungan) {
                                  awal = 0;
                                } else {
                                  awal = value.docs.length - hitungan;
                                }
                                var data = value.docs
                                    .getRange(awal, value.docs.length);
                                var forChart = value.docs
                                    .asMap()
                                    .entries
                                    .map((entry) => RokokChart.fromSnapshot(
                                        entry.value, entry.key))
                                    .toList()
                                    .getRange(awal, value.docs.length)
                                    .toList();
                                data.toList().forEach((element) {
                                  list_rokok.add(element.data()['jumlah']);
                                });
                                if (list_rokok.length < hitungan) {
                                  chartDb
                                      .collection(FirestoreBucket.users)
                                      .doc(user.uid)
                                      .collection(FirestoreBucket.jadwal)
                                      .doc(registration_date[0])
                                      .collection(conveterbulan(
                                          (focusedDay.month - 1).toString())!)
                                      .get()
                                      .then((value) {
                                    if (value.docs.length <=
                                        (hitungan - list_rokok.length)) {
                                      awal = 0;
                                    } else {
                                      awal = value.docs.length -
                                          (hitungan - list_rokok.length);
                                    }
                                    var data = value.docs
                                        .getRange(awal, value.docs.length);
                                    forChart += value.docs
                                        .asMap()
                                        .entries
                                        .map((entry) => RokokChart.fromSnapshot(
                                            entry.value, entry.key))
                                        .toList()
                                        .getRange(awal, value.docs.length)
                                        .toList();
                                    data.toList().forEach((element) {
                                      list_rokok.add(element.data()['jumlah']);
                                    });
                                    data.toList().forEach((element) {
                                      list_rokok.add(element.data()['jumlah']);
                                    });
                                    updateTotalRokok = list_rokok.sum;
                                    updateTerdikit = list_rokok.min;
                                    updateTerbanyak = list_rokok.max;
                                    updateRatarata = list_rokok.average;
                                    updateData(updateTotalRokok, updateRatarata,
                                        updateTerbanyak, updateTerdikit);
                                    return forChart;
                                  });
                                } else {
                                  updateTotalRokok = list_rokok.sum;
                                  updateTerdikit = list_rokok.min;
                                  updateTerbanyak = list_rokok.max;
                                  updateRatarata = list_rokok.average;
                                  updateData(updateTotalRokok, updateRatarata,
                                      updateTerbanyak, updateTerdikit);
                                  return forChart;
                                }
                                return forChart;
                              });
                            }
                          } else {
                            // Ketika beda tahun
                            if (focusedDay.month == 1) {
                              // Ketika masih dibulan january
                              chartController.stats.value = chartDb
                                  .collection(FirestoreBucket.users)
                                  .doc(user.uid)
                                  .collection(FirestoreBucket.jadwal)
                                  .doc(focusedDay.year.toString())
                                  .collection(conveterbulan(
                                      focusedDay.month.toString())!)
                                  .get()
                                  .then((value) {
                                if (value.docs.length <= hitungan) {
                                  awal = 0;
                                } else {
                                  awal = value.docs.length - hitungan;
                                }
                                var data = value.docs
                                    .getRange(awal, value.docs.length);
                                var forChart = value.docs
                                    .asMap()
                                    .entries
                                    .map((entry) => RokokChart.fromSnapshot(
                                        entry.value, entry.key))
                                    .toList()
                                    .getRange(awal, value.docs.length)
                                    .toList();
                                data.toList().forEach((element) {
                                  list_rokok.add(element.data()['jumlah']);
                                });
                                if (list_rokok.length < hitungan) {
                                  chartDb
                                      .collection(FirestoreBucket.users)
                                      .doc(user.uid)
                                      .collection(FirestoreBucket.jadwal)
                                      .doc((focusedDay.year - 1).toString())
                                      .collection(conveterbulan("12")!)
                                      .get()
                                      .then((value) {
                                    if (value.docs.length <=
                                        (hitungan - list_rokok.length)) {
                                      awal = 0;
                                    } else {
                                      awal = value.docs.length -
                                          (hitungan - list_rokok.length);
                                    }
                                    var data = value.docs
                                        .getRange(awal, value.docs.length);
                                    forChart += value.docs
                                        .asMap()
                                        .entries
                                        .map((entry) => RokokChart.fromSnapshot(
                                            entry.value, entry.key))
                                        .toList()
                                        .getRange(awal, value.docs.length)
                                        .toList();
                                    data.toList().forEach((element) {
                                      list_rokok.add(element.data()['jumlah']);
                                    });
                                    updateTotalRokok = list_rokok.sum;
                                    updateTerdikit = list_rokok.min;
                                    updateTerbanyak = list_rokok.max;
                                    updateRatarata = list_rokok.average;
                                    updateData(updateTotalRokok, updateRatarata,
                                        updateTerbanyak, updateTerdikit);
                                    return forChart;
                                  });
                                }
                                updateTotalRokok = list_rokok.sum;
                                updateTerdikit = list_rokok.min;
                                updateTerbanyak = list_rokok.max;
                                updateRatarata = list_rokok.average;
                                updateData(updateTotalRokok, updateRatarata,
                                    updateTerbanyak, updateTerdikit);
                                return forChart;
                              });
                            } else {
                              chartController.stats.value = chartDb
                                  .collection(FirestoreBucket.users)
                                  .doc(user.uid)
                                  .collection(FirestoreBucket.jadwal)
                                  .doc(focusedDay.year.toString())
                                  .collection(conveterbulan(
                                      focusedDay.month.toString())!)
                                  .get()
                                  .then((value) {
                                if (value.docs.length <= hitungan) {
                                  awal = 0;
                                } else {
                                  awal = value.docs.length - hitungan;
                                }
                                var data = value.docs
                                    .getRange(awal, value.docs.length);
                                var forChart = value.docs
                                    .asMap()
                                    .entries
                                    .map((entry) => RokokChart.fromSnapshot(
                                        entry.value, entry.key))
                                    .toList()
                                    .getRange(awal, value.docs.length)
                                    .toList();
                                data.toList().forEach((element) {
                                  list_rokok.add(element.data()['jumlah']);
                                });
                                if (list_rokok.length < hitungan) {
                                  chartDb
                                      .collection(FirestoreBucket.users)
                                      .doc(user.uid)
                                      .collection(FirestoreBucket.jadwal)
                                      .doc(focusedDay.year.toString())
                                      .collection(conveterbulan(
                                          (focusedDay.month - 1).toString())!)
                                      .get()
                                      .then((value) {
                                    if (value.docs.length <=
                                        (hitungan - list_rokok.length)) {
                                      awal = 0;
                                    } else {
                                      awal = value.docs.length -
                                          (hitungan - list_rokok.length);
                                    }
                                    var data = value.docs
                                        .getRange(awal, value.docs.length);
                                    forChart += value.docs
                                        .asMap()
                                        .entries
                                        .map((entry) => RokokChart.fromSnapshot(
                                            entry.value, entry.key))
                                        .toList()
                                        .getRange(awal, value.docs.length)
                                        .toList();
                                    data.toList().forEach((element) {
                                      list_rokok.add(element.data()['jumlah']);
                                    });
                                    updateTotalRokok = list_rokok.sum;
                                    updateTerdikit = list_rokok.min;
                                    updateTerbanyak = list_rokok.max;
                                    updateRatarata = list_rokok.average;
                                    updateData(updateTotalRokok, updateRatarata,
                                        updateTerbanyak, updateTerdikit);
                                    return forChart;
                                  });
                                }
                                updateTotalRokok = list_rokok.sum;
                                updateTerdikit = list_rokok.min;
                                updateTerbanyak = list_rokok.max;
                                updateRatarata = list_rokok.average;
                                updateData(updateTotalRokok, updateRatarata,
                                    updateTerbanyak, updateTerdikit);
                                return forChart;
                              });
                            }
                          }
                        });

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
                                      'Rata-Rata Konsumsi',
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
              Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 0, bottom: 0),
                                  padding: const EdgeInsets.only(
                                      right: 60.0,
                                      top: 15,
                                      bottom: 15,
                                      left: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(color: Colors.grey)),
                                  child: Text(
                                    'Jumlah Rokok Tertinggi Sebanyak ${rokok_terbanyak.toString()} Batang',
                                    style: Get.theme.textTheme.headline4,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 0, bottom: 0),
                                  padding: const EdgeInsets.only(
                                      right: 60.0,
                                      top: 15,
                                      bottom: 15,
                                      left: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(color: Colors.grey)),
                                  child: Text(
                                    'Jumlah Rokok Terendah Sebanyak ${rokok_terdikit.toString()} Batang',
                                    style: Get.theme.textTheme.headline4,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
              Card(
                child: FutureBuilder(
                  future: chartController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<RokokChart>> snapshots) {
                    if (snapshots.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Jumlah")),
                            Container(
                              height: 250,
                              padding: const EdgeInsets.all(10),
                              child:
                                  CustomBarChart(rokokStats: snapshots.data!),
                            ),
                            const Align(
                                alignment: Alignment.center,
                                child: Text("Tanggal"))
                          ],
                        ),
                      );
                    } else if (snapshots.hasError) {
                      return Text('data kosong');
                    } else {
                      return const Center(child: Text("data kosong"));
                    }
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
                        child: CustomLineChart(rokokStats: snapshots.data!),
                      );
                    } else if (snapshots.hasError) {
                      return Text('data kosong');
                    } else {
                      return const Center(child: Text("data kosong"));
                    }
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
    return month[mt].toString();
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

    if (series != null) {
      return charts.BarChart(
        series,
        animate: true,
      );
    } else {
      return Text('data kosong');
    }
  }
}

class CustomLineChart extends StatelessWidget {
  const CustomLineChart({
    Key? key,
    required this.rokokStats,
  }) : super(key: key);

  final List<RokokChart> rokokStats;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<RokokChart, int>> series = [
      charts.Series(
        id: 'jumlah',
        data: rokokStats,
        domainFn: (series, _) => int.parse(series.tanggal),
        measureFn: (series, _) => series.jumlah,
        colorFn: (series, _) => series.barColor!,
      )
    ];

    if (series != null) {
      return charts.LineChart(
        series,
        animate: true,
      );
    } else {
      return Text('data kosong');
    }
  }
}
