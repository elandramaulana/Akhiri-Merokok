import 'package:akhiri_merokok/app/data/models/chart.dart';
import 'package:akhiri_merokok/firestore/bucket_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore chartDb = FirebaseFirestore.instance;

  Future<List<RokokChart>> getRokokStats() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = FirebaseAuth.instance.currentUser!;
    String uid = auth.currentUser!.uid.toString();
    return chartDb
        .collection(FirestoreBucket.users)
        .doc(user.uid)
        .collection(FirestoreBucket.jadwal)
        .doc('2022')
        .collection('September')
        .orderBy('tanggal')
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .asMap()
            .entries
            .map((entry) => RokokChart.fromSnapshot(entry.value, entry.key))
            .toList());
  }
}
