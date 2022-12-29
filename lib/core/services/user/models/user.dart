class User {
  String? uuid;
  String? firstName;
  String? lastName;
  String? email;
  String? companyName;
  String? fairName;

  User({
    this.uuid,
    this.lastName,
    this.firstName,
    this.email,
    this.companyName,
    this.fairName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json["uuid"] ?? " ",
      firstName: json["firstName"] ?? " ",
      lastName: json["lastName"] ?? " ",
      email: json["email"] ?? " ",
      companyName: json["companyName"] ?? " ",
      fairName: json["fairName"] ?? " ",
    );
  }

  factory User.toJson(Map<String, dynamic> json) {
    return User(
      uuid: json["uuid"] ?? " ",
      firstName: json["firstName"] ?? " ",
      lastName: json["lastName"] ?? " ",
      email: json["email"] ?? " ",
      companyName: json["companyName"] ?? " ",
      fairName: json["fairName"] ?? " ",
    );
  }
}
