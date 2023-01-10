import 'package:fuar_qr/core/services/participant/models/participant_model.dart';

class ParticipantValidateModel {
  ParticipantModel? fairParticipantDTO;
  bool valid;

  ParticipantValidateModel({
    this.fairParticipantDTO,
    this.valid = false,
  });

  factory ParticipantValidateModel.fromJson(Map<String, dynamic> json) {
    return ParticipantValidateModel(
      fairParticipantDTO: json["fairParticipantDTO"],
      valid: json["valid"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fairParticipantDTO'] = fairParticipantDTO;
    data['valid'] = valid;
    
    return data;
  }
}
