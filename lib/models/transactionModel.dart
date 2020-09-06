class Transaction{
  DateTime transactionDate;
  String reference;
  double balance;
  Transaction.fromJson(Map<String, dynamic> json):
  transactionDate=DateTime.parse(json['Date']),
  reference=json['ElementType'],
  balance=json['Balance'];
  Map<String, dynamic> toJson() =>{
    'Date':transactionDate,
    'ElementType':reference,
    'Balance':balance
  };
}