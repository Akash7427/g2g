// To parse this JSON data, do
//
//     final client = clientFromJson(jsonString);

import 'dart:convert';

Client clientFromJson(String str) => Client.fromJson(json.decode(str));

String clientToJson(Client data) => json.encode(data.toJson());

class Client {
  Client({
    this.clientId,
    this.loginSuccess,
    this.forcePasswordChange,
    this.sessionDetails,
  });

  String clientId;
  String loginSuccess;
  String forcePasswordChange;
  SessionDetails sessionDetails;

  factory Client.fromJson(Map<String, dynamic> json) => Client(
    clientId: json["ClientID"],
    loginSuccess: json["LoginSuccess"],
    forcePasswordChange: json["ForcePasswordChange"],
    sessionDetails: SessionDetails.fromJson(json["SessionDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "ClientID": clientId,
    "LoginSuccess": loginSuccess,
    "ForcePasswordChange": forcePasswordChange,
    "SessionDetails": sessionDetails.toJson(),
  };
}

class SessionDetails {
  SessionDetails({
    this.sessionToken,
    this.roleType,
    this.fullName,
    this.userLevel,
    this.clientId,
    this.clientLastLoginDate,
    this.clientBranchId,
    this.clientBranchName,
    this.clientBranchAddressPhysicalFormatted,
    this.clientBranchAddressPostalFormatted,
    this.clientBranchContactMethodPhone,
    this.clientBranchContactMethodEmail,
  });

  String sessionToken;
  String roleType;
  String fullName;
  String userLevel;
  String clientId;
  DateTime clientLastLoginDate;
  String clientBranchId;
  String clientBranchName;
  String clientBranchAddressPhysicalFormatted;
  String clientBranchAddressPostalFormatted;
  String clientBranchContactMethodPhone;
  String clientBranchContactMethodEmail;

  factory SessionDetails.fromJson(Map<String, dynamic> json) => SessionDetails(
    sessionToken: json["SessionToken"],
    roleType: json["RoleType"],
    fullName: json["FullName"],
    userLevel: json["UserLevel"],
    clientId: json["ClientId"],
    clientLastLoginDate: DateTime.parse(json["ClientLastLoginDate"]),
    clientBranchId: json["ClientBranchId"],
    clientBranchName: json["ClientBranchName"],
    clientBranchAddressPhysicalFormatted: json["ClientBranchAddressPhysicalFormatted"],
    clientBranchAddressPostalFormatted: json["ClientBranchAddressPostalFormatted"],
    clientBranchContactMethodPhone: json["ClientBranchContactMethodPhone"],
    clientBranchContactMethodEmail: json["ClientBranchContactMethodEmail"],
  );

  Map<String, dynamic> toJson() => {
    "SessionToken": sessionToken,
    "RoleType": roleType,
    "FullName": fullName,
    "UserLevel": userLevel,
    "ClientId": clientId,
    "ClientLastLoginDate": clientLastLoginDate.toIso8601String(),
    "ClientBranchId": clientBranchId,
    "ClientBranchName": clientBranchName,
    "ClientBranchAddressPhysicalFormatted": clientBranchAddressPhysicalFormatted,
    "ClientBranchAddressPostalFormatted": clientBranchAddressPostalFormatted,
    "ClientBranchContactMethodPhone": clientBranchContactMethodPhone,
    "ClientBranchContactMethodEmail": clientBranchContactMethodEmail,
  };
}
