class Client {
  String sessionToken, fullName, userID;
  bool userPasswordForceChange;

  Client.fromJson(Map<String, dynamic> json)
      : fullName = json['ClientAuthentication']['SessionDetails']['FullName'],
        sessionToken =
            json['ClientAuthentication']['SessionDetails']['SessionToken'],
        userID = json['ClientAuthentication']['ClientID'],
        userPasswordForceChange =
            json['ClientAuthentication']['UserPasswordForceChange'];

  Map<String, dynamic> toJson() => {
        'UserId': userID,
        'FullName': fullName,
        'SessionToken': sessionToken,
        'UserPasswordForceChange': userPasswordForceChange
      };
}
