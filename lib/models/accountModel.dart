class Account{
  String accountID,accountTypeDescription,status;
  double  balanceOverdue,balance;
  DateTime openedDate,maturityDate;
  Account.fromJson(Map<String, dynamic> json)
      : accountID = json['AccountId'],
        accountTypeDescription = json['AccountTypeDescription'],
        status=json['Status'],
        balance=json['Balance'],
        balanceOverdue=json['BalanceOverdue'],
        openedDate=DateTime.parse(json['DateOpened']),
        maturityDate=DateTime.parse(json['DateMaturity']);

  Map<String, dynamic> toJson() =>
    {
      'AccountId':accountID,
      'AccountTypeDescription': accountTypeDescription,
      'Status': status,
      'BalanceOverdue':balanceOverdue,
      'Balance':balance,
      'DateOpened':openedDate,
      'DateMaturity':maturityDate
    };
}