import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RokokChart {
  final int jumlah;
  final String tanggal;
  final String index;
  charts.Color? barColor;

  RokokChart(
      {required this.jumlah,
      required this.tanggal,
      this.barColor,
      required this.index}) {
    barColor = charts.ColorUtil.fromDartColor(Colors.orange);
  }

  factory RokokChart.fromSnapshot(DocumentSnapshot snap, int index) {
    return RokokChart(
        jumlah: snap['jumlah'],
        index: index.toString(),
        tanggal: snap['tanggal']);
  }
}
