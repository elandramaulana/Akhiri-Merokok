import 'package:akhiri_merokok/app/modules/home/navbar.dart';
import 'package:akhiri_merokok/app/modules/question/question1.dart';
import 'package:akhiri_merokok/app/modules/widgets/auth_btn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../../../core/utils/keys.dart';
import '../home/home_view.dart';
import '../widgets/text_input_field.dart';

class FormRokok extends StatefulWidget {
  FormRokok({Key? key}) : super(key: key);

  @override
  State<FormRokok> createState() => _FormRokokState();
}

class _FormRokokState extends State<FormRokok> {
  final List<String> _gender = ['pria', 'wanita'];
  final List<String> _jenisRokok = ['kretek', 'putih', 'campuran', 'elektrik'];
  final _formKey = GlobalKey<FormState>();

  String? _currentGender;
  String? _currentJenis;

  final TextEditingController namaController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tahunMulaiController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController usiaController = TextEditingController();
  final TextEditingController durasiMerokokController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(right: 32.h, left: 32.h),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 32.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Riwayat Perokok',
                    style: Get.theme.textTheme.headline1,
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nama',
                    style: Get.theme.textTheme.headline2,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextInputField(
                  iD: 1,
                  textEditingController: namaController,
                  hintText: 'Masukkan Nama Lengkapmu',
                  obscureText: false,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Jenis Kelamin',
                    style: Get.theme.textTheme.headline2,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                DropdownButtonFormField(
                    value: _gender[0],
                    items: _gender.map((gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text('$gender'),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _currentGender = val.toString())),
                SizedBox(
                  height: 24.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tanggal Lahir",
                    style: Get.theme.textTheme.headline2,
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                TextField(
                  decoration: const InputDecoration(
                      hintText: "Tanggal", icon: Icon(Icons.calendar_today)),
                  controller: birthController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1800),
                        lastDate: DateTime(2099));

                    if (pickedDate != null) {
                      setState(() {
                        birthController.text =
                            DateFormat.yMMMd().format(pickedDate);
                        var userSelectedDate = pickedDate;
                        var days =
                            DateTime.now().difference(userSelectedDate).inDays;
                        var age = days ~/ 360;
                        usiaController.text = age.toString();
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 24.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pekerjaan',
                    style: Get.theme.textTheme.headline2,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextInputField(
                  iD: 2,
                  textEditingController: jobController,
                  hintText: 'Masukkan Pekerjaan',
                  obscureText: false,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Alamat',
                    style: Get.theme.textTheme.headline2,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextInputField(
                  iD: 3,
                  textEditingController: alamatController,
                  hintText: 'Masukkan Alamat',
                  obscureText: false,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tahun Mulai Merokok',
                    style: Get.theme.textTheme.headline2,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextField(
                  decoration: const InputDecoration(
                      hintText: "Tanggal", icon: Icon(Icons.calendar_today)),
                  controller: tahunMulaiController,
                  onTap: () async {
                    DateTime? pickedDateStart = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1800),
                        lastDate: DateTime(2099));

                    if (pickedDateStart != null) {
                      setState(() {
                        tahunMulaiController.text =
                            DateFormat.yMMMd().format(pickedDateStart);
                        var startSelectedDate = pickedDateStart.year;
                        var days = DateTime.now().year;
                        var start = days - startSelectedDate;
                        durasiMerokokController.text = start.toString();
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 24.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Jenis Rokok',
                    style: Get.theme.textTheme.headline2,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                DropdownButtonFormField(
                    value: _jenisRokok[0],
                    items: _jenisRokok.map((jenisRokok) {
                      return DropdownMenuItem(
                        value: jenisRokok,
                        child: Text('$jenisRokok'),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _currentJenis = val.toString())),
                SizedBox(
                  height: 16.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Jumlah Batang Yang Dikonsumsi Perhari',
                    style: Get.theme.textTheme.headline2,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextInputField(
                  textEditingController: jumlahController,
                  hintText: '0',
                  iD: 6,
                  obscureText: false,
                ),
                SizedBox(
                  height: 24.h,
                ),
                AuthButton("Next ->", () {
                  submitForm();
                  Get.offAll(() => const QuizScreen1());
                }),
                SizedBox(
                  height: 24.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitForm() async {
    CollectionReference answer = firebaseFirestore.collection("users");
    FirebaseAuth auth = FirebaseAuth.instance;

    String uid = auth.currentUser!.uid.toString();

    answer.doc(uid).collection('form').doc('dataUser').set({
      "nama": namaController.text,
      "tanggal_lahir": birthController.text,
      "jenis_kelamin": _currentGender,
      "pekerjaan": jobController.text,
      "alamat": alamatController.text,
      "tahun_mulai_merokok": tahunMulaiController.text,
      "jenis_rokok": _currentJenis,
      "jumlah_konsumsi_harian": jumlahController.text,
      "usia": usiaController.text,
      "lama_merokok": durasiMerokokController.text,
    });
  }
}
