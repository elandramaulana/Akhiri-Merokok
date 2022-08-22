import 'dart:math';

import 'package:akhiri_merokok/app/modules/question/question2.dart';
import 'package:akhiri_merokok/core/utils/keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/models/answer.dart';
import '../../data/models/users.dart';

class QuizScreen1 extends StatefulWidget {
  const QuizScreen1({Key? key}) : super(key: key);

  @override
  State<QuizScreen1> createState() => _QuizScreen1State();
}

class _QuizScreen1State extends State<QuizScreen1> {
  int selected = 0;
  String? answerText;
  int? point;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _questionWidget(),
                _answerButton("Dalam 5 Menit", 1, 3),
                _answerButton("6 - 30 Menit", 2, 2),
                _answerButton("30 - 60 Menit", 3, 1),
                _answerButton("Setelah 60 Menit", 4, 0),
                Container(
                  width: 200,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 80,
                  child: ElevatedButton(
                      onPressed: () {
                        addAnswer();
                        print(answerText);
                        Get.to(const QuizScreen2());
                      },
                      child: Icon(Icons.keyboard_double_arrow_right),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                      )),
                ),
              ]),
        ),
      ),
    );
  }

  _questionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: const Text(
            "1/6",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "Seberapa cepat anda setelah bangun tidur Merokok?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  Widget _answerButton(String text, int index, int nilai) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 80,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: (selected == index) ? Colors.black : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(
                  color: (selected == index) ? Colors.black : Colors.grey),
            )),
        onPressed: () {
          answerText = text;
          point = nilai;
          setState(() {
            selected = index;
          });
        },
        child: Text(
          text,
          style: TextStyle(
              color: (selected == index) ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Future<void> addAnswer() async {
    CollectionReference answer = firebaseFirestore.collection("users");
    FirebaseAuth auth = FirebaseAuth.instance;

    String uid = auth.currentUser!.uid.toString();

    answer.doc(uid).collection('form').doc('dataUser').update({
      "Answer1": answerText,
      "nilai1": point,
    });
  }
}
