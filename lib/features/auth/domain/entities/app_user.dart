class AppUser {
  final String uid;
  final String email;
  final String name;

  AppUser({required this.uid, required this.email, required this.name});

  AppUser copyWith({
    String? uid,
    String? name,
    String? email,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  //convert appuser to json

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

  //convert json to appuser

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(uid: json['uid'], email: json['email'], name: json['name']);
  }
}
