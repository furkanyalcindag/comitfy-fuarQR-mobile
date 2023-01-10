import 'dart:convert';

import 'package:fuar_qr/core/services/participant/models/participant_model.dart';
import 'package:fuar_qr/core/services/participant/models/participant_validate_model.dart';
import 'package:fuar_qr/core/utility/api_interceptor.dart';
import 'package:http_interceptor/http/intercepted_http.dart';

class ParticipantService {
  static Future<ParticipantValidateModel?> fetchValidateParticipantByID(
      {required String path, required String uuid}) async {
    
    final http = InterceptedHttp.build(interceptors: [
      ApiInterceptor(),
    ]);

    final response = await http.get(
      Uri.parse(path + uuid),
      headers: {
        "accept": "application/json",
      },
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      if(responseJson != null){
        return ParticipantValidateModel.fromJson(responseJson);
      }
      return null;
    } else {
      return null;
    }
  }
}
