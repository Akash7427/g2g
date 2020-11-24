class TawkVisitor {
  /// Visitor's name.
  final String name;

  /// Visitor's email.
  final String email;

  final String clienId;

  /// [Secure mode](https://developer.tawk.to/jsapi/#SecureMode).
  final String hash;

  TawkVisitor({
    this.name,
    this.email,
    this.clienId,
    this.hash,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (name != null) {
      data['name'] = name;
    }

    if (email != null) {
      data['email'] = email;
    }
    if (clienId != null) {
      data['ClientID'] = clienId;
    }

    if (hash != null) {
      data['hash'] = hash;
    }

    return data;
  }
}