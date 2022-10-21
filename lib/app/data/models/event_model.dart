class EventModel {
  final DateTime tanggal;

  EventModel({
    required this.tanggal,
  });

  factory EventModel.fromMap(Map data) {
    return EventModel(
      tanggal: data['tanggal'],
    );
  }

  factory EventModel.fromDS(String id, Map<String, dynamic> data) {
    return EventModel(
      tanggal: data['tanggal'].toDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "tanggal": tanggal,
    };
  }
}
