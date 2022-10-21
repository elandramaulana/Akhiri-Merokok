import 'package:flutter/material.dart';
import 'package:get/get.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      )),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Akhiri Merokok App",
                  style: TextStyle(
                      color: Color.fromARGB(255, 8, 143, 253),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bagian Pulmonologi dan Kedokteran Respirasi FK Univeristas Andalas, bekerja sama dengan Perhimpunan Dokter Paru Indonesia cabangSumatra Barat, dan Fakultas Teknologi Informasi Universitas Andalas akan meluncurkan 'Mobile App' yang bertujuan untuk memfasilitasi pengguna untuk berhenti merokok",
                    style: Get.theme.textTheme.headline6,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Padang, 2022",
                    style: TextStyle(
                        color: Color.fromARGB(255, 8, 143, 253),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
