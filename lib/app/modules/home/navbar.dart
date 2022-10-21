import 'package:akhiri_merokok/app/modules/home/about.dart';
import 'package:akhiri_merokok/app/modules/home/home_view.dart';
import 'package:akhiri_merokok/app/modules/home/konsultasi.dart';
import 'package:akhiri_merokok/app/modules/home/statistic.dart';
import 'package:akhiri_merokok/app/modules/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:akhiri_merokok/app/data/providers/auth_controller.dart';
import 'package:get/get.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _Navbar();
}

class _Navbar extends State<Navbar> {
  int tabIndex = 0;
  final List<Widget> _children = [
    const HomeView(),
    Statistic(),
    const Konsultasi(),
  ];

  void onTapBar(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Image.asset('assets/images/title.png', width: 160, height: 160),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Get.to(const Profile());
              },
              icon: const Icon(Icons.person),
            )
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.red,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(padding: EdgeInsets.all(40)),
                const ListTile(
                  title: Text(
                    "Menu",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.admin_panel_settings_sharp,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Bantuan",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(const About());
                  },
                  leading: const Icon(
                    Icons.question_mark_rounded,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Tentang Kami",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                ListTile(
                  onTap: () {
                    AuthController.to.signOut();
                  },
                  leading: const Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Keluar",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                )
              ],
            ),
          ),
        ),
        body: _children[tabIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.red,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
          onTap: onTapBar,
          currentIndex: tabIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart), label: 'Statistik'),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), label: 'Konsultasi'),
          ],
        ));
  }
}
