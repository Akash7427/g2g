class Client{
  String sessionToken,fullName,userID;
  bool userPasswordForceChange;
  Client.fromJson(Map<String, dynamic> json)
      : fullName = json['FullName'],
        sessionToken = json['SessionToken'],
        userID=json['UserId'],
        userPasswordForceChange=json['UserPasswordForceChange'];
  Map<String, dynamic> toJson() =>
    {
      'UserId':userID,
      'FullName': fullName,
      'SessionToken': sessionToken,
      'UserPasswordForceChange':userPasswordForceChange
    };
}