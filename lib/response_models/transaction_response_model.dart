// To parse this JSON data, do
//
//     final transactionResponseModel = transactionResponseModelFromJson(jsonString);

import 'dart:convert';

List<TransactionResponseModel> transactionResponseModelFromJson(String str) => List<TransactionResponseModel>.from(json.decode(str).map((x) => TransactionResponseModel.fromJson(x)));

String transactionResponseModelToJson(List<TransactionResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionResponseModel {
  TransactionResponseModel({
    this.balance,
    this.date,
    this.elementId,
    this.elementType,
    this.notes,
    this.pk,
    this.reference,
    this.value,
    this.canReverse,
    this.canSwitchInvestment,
  });

  double balance;
  String date;
  String elementId;
  String elementType;
  String notes;
  int pk;
  String reference;
  double value;
  bool canReverse;
  bool canSwitchInvestment;

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) => TransactionResponseModel(
    balance: json["Balance"].toDouble(),
    date: json["Date"],
    elementId: json["ElementId"],
    elementType: json["ElementType"],
    notes: json["Notes"],
    pk: json["Pk"],
    reference: json["Reference"],
    value: json["Value"].toDouble(),
    canReverse: json["CanReverse"],
    canSwitchInvestment: json["CanSwitchInvestment"],
  );

  Map<String, dynamic> toJson() => {
    "Balance": balance,
    "Date": date,
    "ElementId": elementId,
    "ElementType": elementType,
    "Notes": notes,
    "Pk": pk,
    "Reference": reference,
    "Value": value,
    "CanReverse": canReverse,
    "CanSwitchInvestment": canSwitchInvestment,
  };

  factory TransactionResponseModel.fromMap(Map<String, dynamic> json) => TransactionResponseModel(
    balance: json["Balance"].toDouble(),
    date: json["Date"],
    elementId: json["ElementId"],
    elementType: json["ElementType"],
    notes: json["Notes"],
    pk: json["Pk"],
    reference: json["Reference"],
    value: json["Value"].toDouble(),
    canReverse: json["CanReverse"],
    canSwitchInvestment: json["CanSwitchInvestment"],
  );

  Map<String, dynamic> toMap() => {
    "Balance": balance,
    "Date": date,
    "ElementId": elementId,
    "ElementType": elementType,
    "Notes": notes,
    "Pk": pk,
    "Reference": reference,
    "Value": value,
    "CanReverse": canReverse,
    "CanSwitchInvestment": canSwitchInvestment,
  };
}






