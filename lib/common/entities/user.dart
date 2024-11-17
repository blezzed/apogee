
import 'address.dart';

enum Authority {employ, employee, customer}

class UserData {
  String? id;
  String? access_token;
  String? name;
  String? surname;
  String? email;
  String? phone;
  AddressModel? address;
  String? avatar;
  Authority authority = Authority.customer;
  DateTime? created_at;

  UserData({
    this.id,
    this.access_token,
    this.name,
    this.surname,
    this.email,
    this.phone,
    this.address,
    this.avatar,
    this.authority = Authority.customer,
    this.created_at,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "access_token": access_token,
      "name": name,
      "surname": surname,
      "email": email,
      "phone": phone,
      "address": (address==null)? null :address!.toJson(),
      "avatar": avatar,
      "authority": authority.index,
      "created_at": created_at,
    };
  }

}




