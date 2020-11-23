/// Use [TawkVisitor] to set the visitor name and email.
class TawkVisitor {
  /// Visitor's name.
  final String name;

  /// Visitor's email.
  final String email;
  final String ClientID;

  /// [Secure mode](https://developer.tawk.to/jsapi/#SecureMode).
  final String hash;

  TawkVisitor({
    this.name,
    this.email,
    this.ClientID,
    this.hash,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    print('${data['Client-ID'].toString()}');

    if (name != null) {
      data['name'] = name;
    }

    if (email != null) {
      data['email'] = email;
    }

    if (ClientID != null) {
      data['Client-ID'] = ClientID;
    }

    if (hash != null) {
      data['hash'] = hash;
    }
    data.forEach((key, value) {
      print(key);
      print(value);
    });

    return data;
  }
}
