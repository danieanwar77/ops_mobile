import 'package:ops_mobile/data/model/jo_inspection_send_manual_model.dart';
import 'package:ops_mobile/data/model/jo_laboratory_send_manual_model.dart';

/// jo : 0
/// status : ""
/// trans_date : ""
/// inspection : {"inspection_activity":"","finalize_inspection":""}
/// laboratory : {"laboratory_activity":"","finalize_laboratory":""}

class SendManualModel {
  SendManualModel({
      num? jo,
      num? status,
      String? transDate,
      JoInspectionSendManualModel? inspection,
      JoLaboratorySendManualModel? laboratory,}){
    _jo = jo;
    _status = status;
    _transDate = transDate;
    _inspection = inspection;
    _laboratory = laboratory;
}

  SendManualModel.fromJson(dynamic json) {
    _jo = json['jo'];
    _status = json['status'];
    _transDate = json['trans_date'];
    _inspection = json['inspection'] != null ? JoInspectionSendManualModel.fromJson(json['inspection']) : null;
    _laboratory = json['laboratory'] != null ? JoLaboratorySendManualModel.fromJson(json['laboratory']) : null;
  }
  num? _jo;
  num? _status;
  String? _transDate;
  JoInspectionSendManualModel? _inspection;
  JoLaboratorySendManualModel? _laboratory;
SendManualModel copyWith({  num? jo,
  num? status,
  String? transDate,
  JoInspectionSendManualModel? inspection,
  JoLaboratorySendManualModel? laboratory,
}) => SendManualModel(  jo: jo ?? _jo,
  status: status ?? _status,
  transDate: transDate ?? _transDate,
  inspection: inspection ?? _inspection,
  laboratory: laboratory ?? _laboratory,
);
  num? get jo => _jo;
  num? get status => _status;
  String? get transDate => _transDate;
  JoInspectionSendManualModel? get inspection => _inspection;
  JoLaboratorySendManualModel? get laboratory => _laboratory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['jo'] = _jo;
    map['status'] = _status;
    map['trans_date'] = _transDate;
    if (_inspection != null) {
      map['inspection'] = _inspection?.toJson();
    }
    if (_laboratory != null) {
      map['laboratory'] = _laboratory?.toJson();
    }
    return map;
  }

}