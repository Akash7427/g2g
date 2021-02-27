

import 'dart:convert';

Transaction transactionFromJson(String str) => Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

class Transaction {
  Transaction({
    this.balance,
    this.date,
    this.elementId,
    this.elementType,
    this.notes,
    this.pk,
    this.reference,
    this.value,
    this.canReverse,
  });

  double balance;
  DateTime date;
  String elementId;
  String elementType;
  String notes;
  int pk;
  String reference;
  double value;
  bool canReverse;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
    balance: json["Balance"],
    date: DateTime.parse(json['Date']),
    elementId: json["ElementId"],
    elementType: json["ElementType"],
    notes: json["Notes"],
    pk: json["Pk"],
    reference: json["Reference"],
    value: json["Value"],
    canReverse: json["CanReverse"],
  );
  }

  Map<String, dynamic> toJson() => {
    "Balance": balance,
    "Date": date.toIso8601String(),
    "ElementId": elementId,
    "ElementType": elementType,
    "Notes": notes,
    "Pk": pk,
    "Reference": reference,
    "Value": value,
    "CanReverse": canReverse,
  };
}