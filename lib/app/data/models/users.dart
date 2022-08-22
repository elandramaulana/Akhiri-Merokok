//User Model
class UserModel {
  final String uid;
  final String email;
  // final String noHp;
  // final String name;
  // final String photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    // required this.name,
    // required this.photoUrl,
  });

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'] ?? '',
      // noHp: data['noHp'] ?? '',
      // name: data['name'] ?? '',
      // photoUrl: data['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        // "noHp": noHp,
        // "name": name,
        // "photoUrl": photoUrl,
      };
}
