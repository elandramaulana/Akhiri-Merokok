import 'dart:math';

import 'package:akhiri_merokok/app/modules/question/question5.dart';
import 'package:akhiri_merokok/core/utils/keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../data/models/answer.dart';
import '../../data/models/users.dart';

class QuizScreen4 extends StatefulWidget {
  const QuizScreen4({Key? key}) : super(key: key);

  @override
  State<QuizScreen4> createState() => _QuizScreen4State();
}

class _QuizScreen4State extends State<QuizScreen4> {
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
                _answerButton("Kecil dari 10 Batang", 1, 0),
                _answerButton("11 - 20 batang", 2, 1),
                _answerButton("21 - 30 batang", 3, 2),
                _answerButton("Lebih dari batang", 4, 3),
                Container(
                  width: 200,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 80,
                  child: ElevatedButton(
                      onPressed: () {
                        addAnswer();
                        print(answerText);
                        Get.to(const QuizScreen5());
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
        const Align(
          alignment: Alignment.topCenter,
          child: Text(
            "4/6",
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
              "Berapa jumlah batang rokok yang dihisap setiap hari?",
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
      "Answer4": answerText,
      "nilai4": point,
    });
  }
}
