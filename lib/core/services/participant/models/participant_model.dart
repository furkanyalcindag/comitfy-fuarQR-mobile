class ParticipantModel {
  String? uuid;
  String? firstName;
  String? lastName;
  String? email;
  String? companyName;
  String? mobilePhone;
  String? city;

  ParticipantModel({
    this.uuid,
    this.lastName,
    this.firstName,
    this.email,
    this.companyName,
    this.mobilePhone,
    this.city,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      uuid: json["uuid"] ?? " ",
      firstName: json["firstName"] ?? " ",
      lastName: json["lastName"] ?? " ",
      email: json["email"] ?? " ",
      companyName: json["companyName"] ?? " ",
      mobilePhone: json["mobilePhone"] ?? " ",
      city: json["city"] ?? " ",
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['companyName'] = companyName;
    data['mobilePhone'] = mobilePhone;
    data['city'] = city;
    
    return data;
  }
}
