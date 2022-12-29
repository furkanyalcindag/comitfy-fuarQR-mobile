class ExceptionModel {
  String? errorMessage;
  int? statusCode;

  ExceptionModel({this.errorMessage});

  ExceptionModel.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['errorMessage'] = errorMessage;
    data['statusCode'] = statusCode;
    return data;
  }
}
