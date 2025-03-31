class ProfileModel {
  final String userId;
  final String userName;
  final String name;
  final String Gender;
  final String Specialisation;

  ProfileModel({
    required this.userId,
    required this.userName,
    required this.name,
    required this.Gender,
    required this.Specialisation,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'name': name,
      'Gender': Gender,
      'Specialisation': Specialisation,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
        userId: json['userId'],
        userName: json['userName'],
        name: json['name'],
        Gender: json['Gender'],
        Specialisation: json['Specialisation']);
  }
}
