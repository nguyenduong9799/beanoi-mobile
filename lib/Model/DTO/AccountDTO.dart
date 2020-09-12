import 'package:intl/intl.dart';

class AccountDTO {
  final String uid, name, phone, gender, email;
  final DateTime birthdate;
  // balance. point;

  AccountDTO({
    this.uid,
    this.name,
    this.phone,
    this.gender,
    this.email,
    this.birthdate,
  });

  factory AccountDTO.fromJson(dynamic json) => AccountDTO(
        uid: json["userId"] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        gender: json['gender'] as String,
        birthdate: json['birthdate'] as String != null
            ? DateTime.parse(json['birthdate'] as String)
            : null,
      );

  Map<String, dynamic> toJson() {
    return {
      "userId": uid,
      "name": name,
      "email": email,
      "phone": phone,
      "gender": gender,
      "birthdate": DateFormat('dd/MM/yyyy').format(birthdate),
    };
  }
}
