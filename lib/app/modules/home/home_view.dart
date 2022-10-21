import 'dart:io';

import 'package:akhiri_merokok/app/modules/home/statistic.dart';
import 'package:akhiri_merokok/core/utils/keys.dart';
import 'package:akhiri_merokok/firestore/bucket_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../data/models/event_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

final FirebaseFirestore chartDb = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;
final uid = user.uid;

DateTime selectedDay = DateTime.now();
String? bulan = selectedDay.month.toString();
String? tahun = selectedDay.year.toString();
String datetime = "0";

class _HomeViewState extends State<HomeView> {
  DateTime _focusedDay = DateTime.now();

  final user = FirebaseAuth.instance.currentUser!;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();
  TextEditingController _rokokController = TextEditingController();
  TextEditingController _banyakController = TextEditingController();
  final _formkey = GlobalKey<FormBuilderState>();

  Map<DateTime, List<EventModel>>? selectedEvents;

  num rekorSekarang = 0;
  num rekorTerlama = 0;

  void updateRekor(updateRekorSekarang, updateRekorTerlama) {
    setState(() {
      rekorSekarang = updateRekorSekarang;
      rekorTerlama = updateRekorTerlama;
    });
  }

  @override
  void initState() {
    selectedEvents = {};
    super.initState();

    // For make sign for day been input
    FirebaseFirestore.instance
        .collection(FirestoreBucket.users)
        .doc(user.uid)
        .collection(FirestoreBucket.jadwal)
        .doc(tahun)
        .collection(conveterbulan(bulan!)!)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        DateTime getSelectedDay = DateTime.parse(
            "${element['tahun']}-${conveterbulan2(element['bulan'])}-${element['tanggal']} 00:00:00.000Z");
        selectedEvents?[getSelectedDay] = [
          EventModel(
            tanggal: getSelectedDay,
          ),
        ];
      });
    });

    // For update rekor value
    var listRokok = [];
    FirebaseFirestore.instance
        .collection(FirestoreBucket.users)
        .doc(user?.uid)
        .get()
        .then((value) {
      datetime = value.data()!['timestamp'];
      datetime = datetime.toString();
      var registrationDate = datetime.split(" ")[0].split("-");
      var tahunAwal = int.parse(registrationDate[0]);
      var bulanAwal = int.parse(registrationDate[1]);
      if (int.parse(registrationDate[0]) == focusedDay.year) {
        if (int.parse(registrationDate[1]) == focusedDay.month) {
          FirebaseFirestore.instance
              .collection(FirestoreBucket.users)
              .doc(user.uid)
              .collection(FirestoreBucket.jadwal)
              .doc(registrationDate[0])
              .collection(
                  conveterbulan(int.parse(registrationDate[1]).toString())!)
              .get()
              .then((value) {
            value.docs.forEach((element) {
              listRokok.add(element.data());
            });
            List<num> rekors = [];
            num rekor = 0;
            num updateRekorSekarang = 0;
            num updateRekorTerlama = 0;

            listRokok.forEach((element) {
              if (element['jumlah'] == 0) {
                rekor++;
              } else {
                rekors.add(rekor);
                rekor = 0;
              }
            });
            rekors.add(rekor);
            updateRekorTerlama = rekors.max;
            updateRekorSekarang = rekors.last;
            updateRekor(updateRekorSekarang, updateRekorTerlama);
          });
        } else {
          FirebaseFirestore.instance
              .collection(FirestoreBucket.users)
              .doc(user.uid)
              .collection(FirestoreBucket.jadwal)
              .doc(registrationDate[0])
              .collection(conveterbulan(bulanAwal.toString())!)
              .get()
              .then((value) {
            value.docs.forEach((element) {
              listRokok.add(element.data());
            });
            bulanAwal++;
            for (bulanAwal; bulanAwal <= focusedDay.month; bulanAwal++) {
              FirebaseFirestore.instance
                  .collection(FirestoreBucket.users)
                  .doc(user.uid)
                  .collection(FirestoreBucket.jadwal)
                  .doc(registrationDate[0])
                  .collection(conveterbulan(bulanAwal.toString())!)
                  .get()
                  .then((value) {
                value.docs.forEach((element) {
                  listRokok.add(element.data());
                });
                List<num> rekors = [];
                num rekor = 0;
                num updateRekorSekarang = 0;
                num updateRekorTerlama = 0;

                listRokok.forEach((element) {
                  if (element['jumlah'] == 0) {
                    rekor++;
                  } else {
                    rekors.add(rekor);
                    rekor = 0;
                  }
                });
                rekors.add(rekor);
                updateRekorTerlama = rekors.max;
                updateRekorSekarang = rekors.last;
                updateRekor(updateRekorSekarang, updateRekorTerlama);
              });
            }
          });
        }
      } else {
        FirebaseFirestore.instance
            .collection(FirestoreBucket.users)
            .doc(user.uid)
            .collection(FirestoreBucket.jadwal)
            .doc(tahunAwal.toString())
            .collection(conveterbulan(bulanAwal.toString())!)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            listRokok.add(element.data());
          });
          for (bulanAwal; bulanAwal <= 12; bulanAwal++) {
            FirebaseFirestore.instance
                .collection(FirestoreBucket.users)
                .doc(user.uid)
                .collection(FirestoreBucket.jadwal)
                .doc(tahunAwal.toString())
                .collection(conveterbulan(bulanAwal.toString())!)
                .get()
                .then((value) {
              value.docs.forEach((element) {
                listRokok.add(element.data());
              });
              tahunAwal++;
              for (tahunAwal; tahunAwal <= focusedDay.year; tahunAwal++) {
                bulanAwal = 1;
                FirebaseFirestore.instance
                    .collection(FirestoreBucket.users)
                    .doc(user.uid)
                    .collection(FirestoreBucket.jadwal)
                    .doc(tahunAwal.toString())
                    .collection(conveterbulan(bulanAwal.toString())!)
                    .get()
                    .then((value) {
                  value.docs.forEach((element) {
                    listRokok.add(element.data());
                  });
                  bulanAwal++;
                  for (bulanAwal; bulanAwal <= focusedDay.month; bulanAwal++) {
                    FirebaseFirestore.instance
                        .collection(FirestoreBucket.users)
                        .doc(user.uid)
                        .collection(FirestoreBucket.jadwal)
                        .doc(registrationDate[0])
                        .collection(conveterbulan(bulanAwal.toString())!)
                        .get()
                        .then((value) {
                      value.docs.forEach((element) {
                        listRokok.add(element.data());
                      });
                      List<num> rekors = [];
                      num rekor = 0;
                      num updateRekorSekarang = 0;
                      num updateRekorTerlama = 0;

                      listRokok.forEach((element) {
                        if (element['jumlah'] == 0) {
                          rekor++;
                        } else {
                          rekors.add(rekor);
                          rekor = 0;
                        }
                      });
                      rekors.add(rekor);
                      updateRekorTerlama = rekors.max;
                      updateRekorSekarang = rekors.last;
                      updateRekor(updateRekorSekarang, updateRekorTerlama);
                    });
                  }
                });
              }
            });
          }
        });
      }
      if (int.parse(registrationDate[0]) == focusedDay.year) {
        if (int.parse(registrationDate[1]) == focusedDay.month) {
          FirebaseFirestore.instance
              .collection(FirestoreBucket.users)
              .doc(user.uid)
              .collection(FirestoreBucket.jadwal)
              .doc(registrationDate[0])
              .collection(
                  conveterbulan(int.parse(registrationDate[1]).toString())!)
              .get()
              .then((value) {
            value.docs.forEach((element) {
              listRokok.add(element.data());
            });
            List<num> rekors = [];
            num rekor = 0;
            num updateRekorSekarang = 0;
            num updateRekorTerlama = 0;

            listRokok.forEach((element) {
              if (element['jumlah'] == 0) {
                rekor++;
              } else {
                rekors.add(rekor);
                rekor = 0;
              }
            });
            rekors.add(rekor);
            updateRekorTerlama = rekors.max;
            updateRekorSekarang = rekors.last;
            updateRekor(updateRekorSekarang, updateRekorTerlama);
          });
        } else {
          var bulanAwal = int.parse(registrationDate[1]);
          FirebaseFirestore.instance
              .collection(FirestoreBucket.users)
              .doc(user.uid)
              .collection(FirestoreBucket.jadwal)
              .doc(registrationDate[0])
              .collection(conveterbulan(bulanAwal.toString())!)
              .get()
              .then((value) {
            value.docs.forEach((element) {
              listRokok.add(element.data());
            });
            bulanAwal++;
            for (bulanAwal; bulanAwal <= focusedDay.month; bulanAwal++) {
              FirebaseFirestore.instance
                  .collection(FirestoreBucket.users)
                  .doc(user.uid)
                  .collection(FirestoreBucket.jadwal)
                  .doc(registrationDate[0])
                  .collection(conveterbulan(bulanAwal.toString())!)
                  .get()
                  .then((value) {
                value.docs.forEach((element) {
                  listRokok.add(element.data());
                });
                List<num> rekors = [];
                num rekor = 0;
                num updateRekorSekarang = 0;
                num updateRekorTerlama = 0;

                listRokok.forEach((element) {
                  if (element['jumlah'] == 0) {
                    rekor++;
                  } else {
                    rekors.add(rekor);
                    rekor = 0;
                  }
                });
                rekors.add(rekor);
                updateRekorTerlama = rekors.max;
                updateRekorSekarang = rekors.last;
                updateRekor(updateRekorSekarang, updateRekorTerlama);
              });
            }
          });
        }
      } else {
        FirebaseFirestore.instance
            .collection(FirestoreBucket.users)
            .doc(user.uid)
            .collection(FirestoreBucket.jadwal)
            .doc(tahunAwal.toString())
            .collection(conveterbulan(bulanAwal.toString())!)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            listRokok.add(element.data());
          });
          for (bulanAwal; bulanAwal <= 12; bulanAwal++) {
            FirebaseFirestore.instance
                .collection(FirestoreBucket.users)
                .doc(user.uid)
                .collection(FirestoreBucket.jadwal)
                .doc(tahunAwal.toString())
                .collection(conveterbulan(bulanAwal.toString())!)
                .get()
                .then((value) {
              value.docs.forEach((element) {
                listRokok.add(element.data());
              });
              tahunAwal++;
              for (tahunAwal; tahunAwal <= focusedDay.year; tahunAwal++) {
                bulanAwal = 1;
                FirebaseFirestore.instance
                    .collection(FirestoreBucket.users)
                    .doc(user.uid)
                    .collection(FirestoreBucket.jadwal)
                    .doc(tahunAwal.toString())
                    .collection(conveterbulan(bulanAwal.toString())!)
                    .get()
                    .then((value) {
                  value.docs.forEach((element) {
                    listRokok.add(element.data());
                  });
                  bulanAwal++;
                  for (bulanAwal; bulanAwal <= focusedDay.month; bulanAwal++) {
                    FirebaseFirestore.instance
                        .collection(FirestoreBucket.users)
                        .doc(user.uid)
                        .collection(FirestoreBucket.jadwal)
                        .doc(registrationDate[0])
                        .collection(conveterbulan(bulanAwal.toString())!)
                        .get()
                        .then((value) {
                      value.docs.forEach((element) {
                        listRokok.add(element.data());
                      });
                      List<num> rekors = [];
                      num rekor = 0;
                      num updateRekorSekarang = 0;
                      num updateRekorTerlama = 0;

                      listRokok.forEach((element) {
                        if (element['jumlah'] == 0) {
                          rekor++;
                        } else {
                          rekors.add(rekor);
                          rekor = 0;
                        }
                      });
                      rekors.add(rekor);
                      updateRekorTerlama = rekors.max;
                      updateRekorSekarang = rekors.last;
                      updateRekor(updateRekorSekarang, updateRekorTerlama);
                    });
                  }
                });
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  List<EventModel> _getEventsfromDay(DateTime date) {
    return selectedEvents?[date] ?? [];
  }

  int? banyak;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Object>(
          stream: FirebaseFirestore.instance
              .collection(FirestoreBucket.users)
              .doc(user.uid)
              .collection(FirestoreBucket.jadwal)
              .snapshots(),
          builder: (context, snapshot) {
            // print(snapshot.data);
            return SafeArea(
                child: ListView(
              children: [
                Card(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TableCalendar(
                    eventLoader: _getEventsfromDay,
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2022),
                    lastDay: DateTime(2099),
                    calendarFormat: format,
                    calendarBuilders: CalendarBuilders(),
                    onFormatChanged: (CalendarFormat _format) {
                      setState(() {
                        format = _format;
                      });
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,

                    //Day Changed
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                      // For make sign for day been input
                      FirebaseFirestore.instance
                          .collection(FirestoreBucket.users)
                          .doc(user.uid)
                          .collection(FirestoreBucket.jadwal)
                          .doc(focusedDay.year.toString())
                          .collection(
                              conveterbulan(focusedDay.month.toString())!)
                          .get()
                          .then((value) {
                        value.docs.forEach((element) {
                          DateTime getSelectedDay = DateTime.parse(
                              "${element['tahun']}-${conveterbulan2(element['bulan'])}-${element['tanggal']} 00:00:00.000Z");
                          selectedEvents?[getSelectedDay] = [
                            EventModel(
                              tanggal: getSelectedDay,
                            ),
                          ];
                        });
                      });
                    },
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            "Atur Tanggal Merokok",
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Tanggal",
                                  style: Get.theme.textTheme.headline2,
                                ),
                              ),
                              SizedBox(
                                height: 24.h,
                              ),
                              FormBuilder(
                                key: _formkey,
                                child: FormBuilderDateTimePicker(
                                  name: "Tanggal",
                                  decoration: const InputDecoration(
                                      hintText: "Atur Tanggal",
                                      prefixIcon: Icon(Icons.calendar_today)),
                                  initialValue: selectDay,
                                  inputType: InputType.date,
                                  format: DateFormat('EEEE, dd MMMM, yyyy'),
                                  controller: _eventController,
                                ),
                              ),
                              SizedBox(
                                height: 24.h,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Jumlah Rokok",
                                  style: Get.theme.textTheme.headline2,
                                ),
                              ),
                              SizedBox(
                                height: 24.h,
                              ),
                              FormBuilderTextField(
                                controller: _rokokController,
                                decoration:
                                    const InputDecoration(hintText: "0"),
                                name: 'jumlah',
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              child: Text("Ok"),
                              onPressed: () {
                                submitDaily();
                                Navigator.pop(context);
                                _eventController.clear();
                                setState(() {});
                                return;
                              },
                            ),
                          ],
                        ),
                      );
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                      });
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectedDay, date);
                    },
                    //To style the Calendar
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      selectedDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      selectedTextStyle: TextStyle(color: Colors.white),
                      todayDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      weekendDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: true,
                      titleCentered: true,
                      formatButtonShowsNext: false,
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      formatButtonTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Column(
                  children: [
                    Text('Capaian Anda',
                        style: TextStyle(
                            color: Color.fromARGB(255, 238, 191, 20),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0, left: 20.0),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    padding: const EdgeInsets.only(
                                        right: 15.0,
                                        top: 15,
                                        bottom: 15,
                                        left: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(color: Colors.grey)),
                                    child: Text(
                                        'Selamat, anda sudah tidak merokok selama ${rekorSekarang} hari',
                                        style: Get.theme.textTheme.headline2,
                                        textAlign: TextAlign.center),
                                  ),
                                  // SizedBox(height: 20),
                                  // Text(
                                  //   "${rekorSekarang} Hari",
                                  //   style: Get.theme.textTheme.headline1,
                                  // )
                                ],
                              ),
                            );
                          }),
                    ),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, left: 20.0),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  padding: const EdgeInsets.only(
                                      right: 15.0,
                                      top: 15,
                                      bottom: 15,
                                      left: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(color: Colors.grey)),
                                  child: Text(
                                      'Selamat, rekor terlama anda tidak merokok adalah ${rekorTerlama} hari',
                                      style: Get.theme.textTheme.headline2,
                                      textAlign: TextAlign.center),
                                ),
                                // SizedBox(height: 20),
                                // Text(
                                //   "${rekorTerlama} Hari",
                                //   style: Get.theme.textTheme.headline1,
                                // )
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ],
            ));
          }),
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

  String? conveterbulan2(String mt) {
    var month = {
      'January': '01',
      'February': '02',
      'March': '03',
      'April': '04',
      'May': '05',
      'June': '06',
      'July': '07',
      'August': '08',
      'September': '09',
      'October': '10',
      'November': '11',
      'December': '12',
    };
    return month[mt];
  }

  Future<void> submitDaily() async {
    CollectionReference answer = firebaseFirestore.collection("users");
    FirebaseAuth auth = FirebaseAuth.instance;

    String uid = auth.currentUser!.uid.toString();

    banyak = int.parse(_rokokController.text);
    var tanggal = _eventController.text;
    tanggal = tanggal.replaceAll(",", "");
    var splitTanggal = tanggal.split(" ");

    final daily = {
      "jumlah": banyak,
      "hari": splitTanggal[0],
      "tanggal": splitTanggal[1],
      "bulan": splitTanggal[2],
      "tahun": splitTanggal[3],
    };

    answer
        .doc(uid)
        .collection('jadwal')
        .doc(splitTanggal[3])
        .collection(splitTanggal[2])
        .doc(splitTanggal[1])
        .set(daily);
  }
}
