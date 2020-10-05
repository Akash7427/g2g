class UpdatePassword {
  String ClientID, Message;
  String PasswordResetSuccess;

  UpdatePassword.fromJson(Map<String, dynamic> json)
      : ClientID = json['PasswordReset']['ClientID'],
        PasswordResetSuccess = json['PasswordReset']['PasswordResetSuccess'],
        Message = json['PasswordReset']['Message'];

  Map<String, dynamic> toJson() => {
        'ClientID': ClientID,
        'PasswordResetSuccess': PasswordResetSuccess,
        'Message': Message,
      };
}
