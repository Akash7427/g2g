// To parse this JSON data, do
//
//     final updatePassword = updatePasswordFromJson(jsonString);

import 'dart:convert';

UpdatePassword updatePasswordFromJson(String str) => UpdatePassword.fromJson(json.decode(str));

String updatePasswordToJson(UpdatePassword data) => json.encode(data.toJson());

class UpdatePassword {
  UpdatePassword({
    this.clientId,
    this.passwordResetSuccess,
    this.message,
  });

  String clientId;
  String passwordResetSuccess;
  String message;

  factory UpdatePassword.fromJson(Map<String, dynamic> json) => UpdatePassword(
    clientId: json["ClientID"],
    passwordResetSuccess: json["PasswordResetSuccess"],
    message: json["Message"],
  );

  Map<String, dynamic> toJson() => {
    "ClientID": clientId,
    "PasswordResetSuccess": passwordResetSuccess,
    "Message": message,
  };
}
