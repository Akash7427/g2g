class Client {
  String sessionToken, fullName, userID;
  bool userPasswordForceChange;
  Client.fromJson(Map<String, dynamic> json)
      : fullName = json['FullName'],
        sessionToken = json['SessionToken'],
        userID = json['ClientId'],
        userPasswordForceChange = json['UserPasswordForceChange'];
  Map<String, dynamic> toJson() => {
        'ClientId': userID,
        'FullName': fullName,
        'SessionToken': sessionToken,
        'UserPasswordForceChange': userPasswordForceChange
      };
}
