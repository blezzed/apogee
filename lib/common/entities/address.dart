
class AddressModel {
  final String? street;
  final String? country;
  final String? province;
  final String? district;
  final String? latitude;
  final String? longitude;

  AddressModel({
    this.street,
    this.country,
    this.province,
    this.district,
    this.latitude,
    this.longitude,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json){
    return AddressModel(
      street: json["street"],
      country: json["country"],
      province: json["province"],
      district: json["district"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "street": street,
      "country": country,
      "province": province,
      "district": district,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}