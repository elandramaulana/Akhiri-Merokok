import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../firestore/bucket_firestore.dart';
import '../../../firestore/field_firestore.dart';
import '../home/navbar.dart';
import '../question/form.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser!;

  final bool circular = false;
  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  final _globalkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Profile",
            style: Get.theme.textTheme.headline1,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(FirestoreBucket.users)
                  .doc(user.uid)
                  .collection(FirestoreBucket.form)
                  .snapshots(),
              builder: (_,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshots) {
                if (snapshots.hasData && snapshots.data != null) {
                  if (snapshots.data!.docs.isNotEmpty) {
                    return ListView.separated(
                        itemBuilder: (____, int index) {
                          Map<String, dynamic> docData =
                              snapshots.data!.docs[index].data();

                          if (docData.isEmpty) {
                            return const Text(
                              'Document is Empty',
                              textAlign: TextAlign.center,
                            );
                          }

                          String nama = docData[FirestoreField.nama];
                          String gender = docData[FirestoreField.gender];
                          String usia = docData[FirestoreField.usia];
                          int nilai1 = docData[FirestoreField.nilai1];
                          int nilai2 = docData[FirestoreField.nilai2];
                          int nilai3 = docData[FirestoreField.nilai3];
                          int nilai4 = docData[FirestoreField.nilai4];
                          int nilai5 = docData[FirestoreField.nilai5];
                          int nilai6 = docData[FirestoreField.nilai6];
                          var a = docData[FirestoreField.lamaMerokok];
                          var b = docData[FirestoreField.jumlahKonsumsi];

                          int level = nilai1 +
                              nilai2 +
                              nilai3 +
                              nilai4 +
                              nilai5 +
                              nilai6;

                          String addict1 = "";

                          if (level < 2) {
                            String addict = "Ketergantungan rendah";
                            addict1 = addict;
                          } else if (level < 4) {
                            String addict =
                                "Ketergantungan rendah hingga sedang";
                            addict1 = addict;
                          } else if (level < 7) {
                            String addict = "Ketergantungan sedang";
                            addict1 = addict;
                          } else {
                            String addict = "Ketergantungan tinggi";
                            addict1 = addict;
                          }

                          var lamaMerokok = int.parse(a);
                          var jumlahKonsumsi = int.parse(b);

                          int durasi = lamaMerokok * jumlahKonsumsi;

                          String interval1 = "";

                          if (durasi < 200) {
                            String interval = "Perokok Ringan";
                            interval1 = interval;
                          } else if (durasi < 600) {
                            String interval = "Perokok Sedang";
                            interval1 = interval;
                          } else {
                            String interval = "Perokok Berat";
                            interval1 = interval;
                          }

                          return Container(
                            padding: EdgeInsets.all(30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                imageProfile(),
                                SizedBox(
                                  height: 40.h,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Nama Pengguna",
                                    style: Get.theme.textTheme.headline1,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      nama,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Usia",
                                    style: Get.theme.textTheme.headline1,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${usia} Tahun",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40.h,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Tingkatan Perokok",
                                    style: Get.theme.textTheme.headline2,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      interval1,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Ketergantungan",
                                    style: Get.theme.textTheme.headline2,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      addict1,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (__, ___) {
                          return const Divider();
                        },
                        itemCount: snapshots.data!.docs.length);
                  } else {
                    return Column(
                      children: [
                        SizedBox(height: 100.h),
                        Text(
                          "Document aren't available",
                          style: Get.theme.textTheme.headline2,
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Get.offAll(() => FormRokok());
                              },
                              child: Text('Lengkapi Data'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange,
                                onPrimary: Colors.white,
                              )),
                        ),
                      ],
                    );
                  }
                } else {
                  return const Center(
                    child: Text('Getting Error'),
                  );
                }
              }),
        ));
  }
}

Widget imageProfile() {
  return Center(
    child: Stack(children: const <Widget>[
      CircleAvatar(
        radius: 60.0,
        backgroundImage: AssetImage('assets/images/profile.png'),
        backgroundColor: Colors.white,
      ),
    ]),
  );
}
