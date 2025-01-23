class UserProfile {
  String phoneNumber;
  String address;
  String country;
  String state;
  String city;
  String postalCode;
  String profileImage;

  UserProfile({
    required this.phoneNumber,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.postalCode,
    required this.profileImage,
  });

  // Convert a JSON to a UserProfile instance
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      phoneNumber: json['phone_number'],
      address: json['address'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      postalCode: json['postal_code'],
      profileImage: json['profile_image'],
    );
  }

  // Convert UserProfile instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'address': address,
      'country': country,
      'state': state,
      'city': city,
      'postal_code': postalCode,
      'profile_image': profileImage,
    };
  }
}
