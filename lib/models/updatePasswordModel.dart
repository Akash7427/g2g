class UpdatePassword {
  String ClientID, Message;
  String PasswordResetSuccess;

  UpdatePassword.fromJson(Map<String, dynamic> json)
      : ClientID = json['ValidateClient']['ClientID'],
        PasswordResetSuccess = json['ValidateClient']['PasswordResetSuccess'],
        Message = json['ValidateClient']['Message'];

  Map<String, dynamic> toJson() => {
        'ClientID': ClientID,
        'PasswordResetSuccess': PasswordResetSuccess,
        'Message': Message,
      };
}
