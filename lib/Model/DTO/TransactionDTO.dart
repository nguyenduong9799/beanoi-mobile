class TransactionDTO{
  int id;
  String name;
  DateTime date;
  String code;
  String type;
  String status;
  double amount;
  bool isMinus;

  TransactionDTO({this.id, this.name, this.date, this.code, this.type, this.status, this.amount, this.isMinus});


}