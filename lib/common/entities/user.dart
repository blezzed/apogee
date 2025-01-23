import 'package:apogee/common/entities/profile.dart';

class UserData {
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  UserProfile? profile;

  UserData({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.profile,
  });

  // Convert a JSON to a User instance
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profile: UserProfile.fromJson(json['profile']),
    );
  }

  // Convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile': profile!.toJson(),
    };
  }
}
