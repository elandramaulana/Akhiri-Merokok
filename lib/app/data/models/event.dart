// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class Event {
//   final String tanggal;
//   final String jumlah;
//   Event({
//     required this.tanggal,
//     required this.jumlah,
//   });

//   Event copyWith({
//     DateTime? tanggal,
//     String? jumlah,
//   }) {
//     return Event(
//       tanggal: tanggal ?? this.tanggal,
//       jumlah: jumlah ?? this.jumlah,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'tanggal': tanggal.millisecondsSinceEpoch,
//       'jumlah': jumlah,
//     };
//   }

//   factory Event.fromMap(Map<String, dynamic> map) {
//     return Event(
//       tanggal: DateTime.fromMillisecondsSinceEpoch(map['tanggal'] as int),
//       jumlah: map['jumlah'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Event.fromJson(String source) =>
//       Event.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() => 'Event(tanggal: $tanggal, jumlah: $jumlah)';

//   @override
//   bool operator ==(covariant Event other) {
//     if (identical(this, other)) return true;

//     return other.tanggal == tanggal && other.jumlah == jumlah;
//   }

//   @override
//   int get hashCode => tanggal.hashCode ^ jumlah.hashCode;
// }
