// To parse this JSON data, do
//
//     final account = accountFromJson(jsonString);

import 'dart:convert';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
  Account({
    this.accountAppStatus,
    this.accountAppStatusText,
    this.accountClass,
    this.accountClassText,
    this.accountHidden,
    this.accountId,
    this.accountPk,
    this.accountRoleId,
    this.accountRoleDescription,
    this.accountRoleIcon,
    this.accountTypeIcon,
    this.accountTypeId,
    this.accountTypeDescription,
    this.balance,
    this.balanceOpening,
    this.balanceOverdue,
    this.balanceOverdueContractual,
    this.dateClosed,
    this.dateMaturity,
    this.dateOpened,
    this.dateQuoted,
    this.description,
    this.name,
    this.productTypeId,
    this.productTypeDescription,
    this.source,
    this.status,
    this.statusText,
    this.totalAdvances,
    this.totalCosts,
    this.totalDeposits,
    this.totalRefinance,
    this.isCurrent,
    this.isIncomplete,
  });

  String accountAppStatus;
  dynamic accountAppStatusText;
  String accountClass;
  String accountClassText;
  bool accountHidden;
  String accountId;
  int accountPk;
  String accountRoleId;
  String accountRoleDescription;
  String accountRoleIcon;
  String accountTypeIcon;
  String accountTypeId;
  String accountTypeDescription;
  double balance;
  double balanceOpening;
  double balanceOverdue;
  double balanceOverdueContractual;
  dynamic dateClosed;
  String dateMaturity;
  String dateOpened;
  String dateQuoted;
  String description;
  String name;
  String productTypeId;
  String productTypeDescription;
  String source;
  String status;
  String statusText;
  double totalAdvances;
  double totalCosts;
  double totalDeposits;
  double totalRefinance;
  bool isCurrent;
  bool isIncomplete;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    accountAppStatus: json["AccountAppStatus"],
    accountAppStatusText: json["AccountAppStatusText"],
    accountClass: json["AccountClass"],
    accountClassText: json["AccountClassText"],
    accountHidden: json["AccountHidden"],
    accountId: json["AccountId"],
    accountPk: json["AccountPk"],
    accountRoleId: json["AccountRoleId"],
    accountRoleDescription: json["AccountRoleDescription"],
    accountRoleIcon: json["AccountRoleIcon"],
    accountTypeIcon: json["AccountTypeIcon"],
    accountTypeId: json["AccountTypeId"],
    accountTypeDescription: json["AccountTypeDescription"],
    balance: json["Balance"].toDouble(),
    balanceOpening: json["BalanceOpening"],
    balanceOverdue: json["BalanceOverdue"],
    balanceOverdueContractual: json["BalanceOverdueContractual"] !=null?json["BalanceOverdueContractual"].toDouble():null,
    dateClosed: json["DateClosed"],
    dateMaturity: json["DateMaturity"],
    dateOpened: json["DateOpened"],
    dateQuoted: json["DateQuoted"],
    description: json["Description"],
    name: json["Name"],
    productTypeId: json["ProductTypeId"],
    productTypeDescription: json["ProductTypeDescription"],
    source: json["Source"],
    status: json["Status"],
    statusText: json["StatusText"],
    totalAdvances: json["TotalAdvances"],
    totalCosts: json["TotalCosts"],
    totalDeposits: json["TotalDeposits"],
    totalRefinance: json["TotalRefinance"].toDouble(),
    isCurrent: json["IsCurrent"],
    isIncomplete: json["IsIncomplete"],
  );

  Map<String, dynamic> toJson() => {
    "AccountAppStatus": accountAppStatus,
    "AccountAppStatusText": accountAppStatusText,
    "AccountClass": accountClass,
    "AccountClassText": accountClassText,
    "AccountHidden": accountHidden,
    "AccountId": accountId,
    "AccountPk": accountPk,
    "AccountRoleId": accountRoleId,
    "AccountRoleDescription": accountRoleDescription,
    "AccountRoleIcon": accountRoleIcon,
    "AccountTypeIcon": accountTypeIcon,
    "AccountTypeId": accountTypeId,
    "AccountTypeDescription": accountTypeDescription,
    "Balance": balance,
    "BalanceOpening": balanceOpening,
    "BalanceOverdue": balanceOverdue,
    "BalanceOverdueContractual": balanceOverdueContractual,
    "DateClosed": dateClosed,
    "DateMaturity": dateMaturity,
    "DateOpened": dateOpened,
    "DateQuoted": dateQuoted,
    "Description": description,
    "Name": name,
    "ProductTypeId": productTypeId,
    "ProductTypeDescription": productTypeDescription,
    "Source": source,
    "Status": status,
    "StatusText": statusText,
    "TotalAdvances": totalAdvances,
    "TotalCosts": totalCosts,
    "TotalDeposits": totalDeposits,
    "TotalRefinance": totalRefinance,
    "IsCurrent": isCurrent,
    "IsIncomplete": isIncomplete,
  };
}
