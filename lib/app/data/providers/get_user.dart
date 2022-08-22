// import 'package:akhiri_merokok/core/utils/keys.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class GetUser extends StatelessWidget {
//   final String documentId;

//   GetUser({required this.documentId});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser!;
//     var users = FirebaseFirestore.instance
//         .collection('users')
//         .doc('mhdbMWNs7jhTFMw4Y6ADGs6Qevl2')
//         .collection('form').snapshots();

//     return FutureBuilder<DocumentSnapshot>(
//         future: users.doc(documentId).get(),
//         builder: ((context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             Map<String, dynamic> data = snapshot?.data?.data() != null
//                 ? snapshot?.data!.data()! as Map<String, dynamic>
//                 : <String, dynamic>{};

//             return Text('Name: ${data['email']}');
//           }
//           return Text('Loading...');
//         }));
//   }
// }
