class ResetPassword {
  String ClientID, Message;
  String IsExisting;

  ResetPassword.fromJson(Map<String, dynamic> json)
      : ClientID = json['ValidateClient']['ClientID'],
        IsExisting = json['ValidateClient']['IsExisting'],
        Message = json['ValidateClient']['Message'];

  Map<String, dynamic> toJson() => {
        'ClientID': ClientID,
        'IsExisting': IsExisting,
        'Message': Message,
      };
}
