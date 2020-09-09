class AccountDTO {
  final String uid, name;
  // balance. point;

  AccountDTO({this.uid, this.name});

  factory AccountDTO.fromJson(dynamic json) => AccountDTO(
        uid: json["userId"] as String,
        name: json['mail'] as String,
      );

  Map<String, dynamic> toJson() {
    return {
      "userId": uid,
      "name": name,
    };
  }
}
