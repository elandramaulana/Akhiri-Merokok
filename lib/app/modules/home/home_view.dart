import 'dart:io';

import 'package:akhiri_merokok/core/utils/keys.dart';
import 'package:akhiri_merokok/firestore/bucket_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

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

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  int? banyak;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Card(
            margin: EdgeInsets.only(bottom: 20),
            child: TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(1902),
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
                          decoration: const InputDecoration(hintText: "0"),
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
                          setState(() {
                            defaultDecoration:
                            BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.orange);
                          });
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
          Row(
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
                                'Rekor Sekarang',
                                style: Get.theme.textTheme.headline4,
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Call data Here",
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
                                'Rekor terlama',
                                style: Get.theme.textTheme.headline4,
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Call Data Here",
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
        ],
      )),
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

  Future<void> submitDaily() async {
    CollectionReference answer = firebaseFirestore.collection("users");
    FirebaseAuth auth = FirebaseAuth.instance;

    String uid = auth.currentUser!.uid.toString();

    banyak = int.parse(_rokokController.text);
    var tanggal = _eventController.text;
    tanggal = tanggal.replaceAll(",", "");
    var split_tanggal = tanggal.split(" ");

    final daily = {
      "jumlah": banyak,
      "hari": split_tanggal[0],
      "tanggal": split_tanggal[1],
      "bulan": split_tanggal[2],
      "tahun": split_tanggal[3],
    };

    answer
        .doc(uid)
        .collection('jadwal')
        .doc(split_tanggal[3])
        .collection(split_tanggal[2])
        .doc(split_tanggal[1])
        .set(daily);
  }
}
