import 'package:unidelivery_mobile/Model/DTO/index.dart';

class TransactionDTO {
  int id;
  String name;
  DateTime date;
  String currency;
  int type;
  int status;
  double amount;
  bool isIncrease;

  TransactionDTO(
      {this.id,
      this.name,
      this.date,
      this.currency,
      this.type,
      this.status,
      this.amount,
      this.isIncrease});

  factory TransactionDTO.fromJson(dynamic json) {
    return TransactionDTO(
        id: json['id'],
        amount: json['amount'],
        currency: json['currency_code'],
        isIncrease: json['is_increase_transaction'],
        type: json['transaction_type'],
        status: json['status'],
        date: DateTime.parse(json['create_at']));
  }
}
