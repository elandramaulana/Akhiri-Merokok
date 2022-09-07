import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/utils/keys.dart';
import '../widgets/auth_btn.dart';
import '../widgets/text_input_field.dart';

class Konsultasi extends StatefulWidget {
  const Konsultasi({Key? key}) : super(key: key);

  @override
  State<Konsultasi> createState() => _KonsultasiState();
}

class _KonsultasiState extends State<Konsultasi> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController _viaController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  final _formkey = GlobalKey<FormBuilderState>();

  List<String> via = ['Whatsapp'];
  String? selectedVia = 'Whatsapp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tanggal Konsultasi",
                style: Get.theme.textTheme.headline2,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 30),
              child: Text(
                  "Tanggal ${selectedDay.day}, Bulan ${selectedDay.month}, Tahun ${selectedDay.year}",
                  style: TextStyle(
                    fontSize: 15.0,
                  )),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Konsultasi Melalui",
                style: Get.theme.textTheme.headline2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: DropdownButtonFormField<String>(
                dropdownColor: Colors.orange[50],
                value: selectedVia,
                items: via
                    .map((via) => DropdownMenuItem<String>(
                          value: via,
                          child: Text(via),
                        ))
                    .toList(),
                onChanged: (via) {
                  setState(() => selectedVia = via);
                }),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Masukkan Nomor",
                style: Get.theme.textTheme.headline2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: TextInputField(
              iD: 1,
              textEditingController: _contactController,
              hintText: '08...',
              obscureText: false,
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: AuthButton("Submit", () {
              submitKonsultasi();
              try {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                            "Data Berhasl Dikirim",
                          ),
                          content: Text(
                            'Harap tunggu konfirmasi terkait jadwal konsultasi yang anda ajukan',
                            style: Get.theme.textTheme.headline2,
                          ),
                          actions: [
                            TextButton(
                              child: Text("Ok"),
                              onPressed: () {
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
                        ));
              } catch (error) {}
            }),
          ),
        ]),
      ),
    ));
  }

  Future<void> submitKonsultasi() async {
    CollectionReference konsultasi = firebaseFirestore.collection("users");
    FirebaseAuth auth = FirebaseAuth.instance;

    String uid = auth.currentUser!.uid.toString();

    konsultasi.doc(uid).collection('konsultasi').add({
      "tanggal_konsultasi": selectedDay,
      "via": selectedVia,
      "contact": _contactController.text
    });
  }
}
