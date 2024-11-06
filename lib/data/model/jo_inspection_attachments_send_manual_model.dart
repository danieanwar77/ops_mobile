/// inspection_attachments : [{"code":"","t_h_jo_id":0,"t_d_jo_inspection_activity_stages_id":0,"file":"","description":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}]

class JoInspectionAttachmentsSendManualModel {
  JoInspectionAttachmentsSendManualModel({
      List<InspectionAttachments>? inspectionAttachments,}){
    _inspectionAttachments = inspectionAttachments ?? [];
}

  JoInspectionAttachmentsSendManualModel.fromJson(dynamic json) {
    if (json['inspection_attachments'] != null) {
      _inspectionAttachments = [];
      json['inspection_attachments'].forEach((v) {
        _inspectionAttachments?.add(InspectionAttachments.fromJson(v));
      });
    }
  }
  List<InspectionAttachments>? _inspectionAttachments;
JoInspectionAttachmentsSendManualModel copyWith({  List<InspectionAttachments>? inspectionAttachments,
}) => JoInspectionAttachmentsSendManualModel(  inspectionAttachments: inspectionAttachments ?? _inspectionAttachments,
);
  List<InspectionAttachments> get inspectionAttachments => _inspectionAttachments ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_inspectionAttachments != null) {
      map['inspection_attachments'] = _inspectionAttachments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// code : ""
/// t_h_jo_id : 0
/// t_d_jo_inspection_activity_stages_id : 0
/// file : ""
/// description : ""
/// is_active : 0
/// is_upload : 0
/// created_by : 0
/// created_at : ""
/// updated_by : 0
/// updated_at : ""

class InspectionAttachments {
  InspectionAttachments({
      String? code,
      num? tHJoId,
      num? tDJoInspectionActivityStagesId,
      String? file,
      String? description,
      num? isActive,
      num? isUpload,
      num? createdBy,
      String? createdAt,
      num? updatedBy,
      String? updatedAt,}){
    _code = code;
    _tHJoId = tHJoId;
    _tDJoInspectionActivityStagesId = tDJoInspectionActivityStagesId;
    _file = file;
    _description = description;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
}

  InspectionAttachments.fromJson(dynamic json) {
    _code = json['code'];
    _tHJoId = json['t_h_jo_id'];
    _tDJoInspectionActivityStagesId = json['t_d_jo_inspection_activity_stages_id'];
    _file = json['file'];
    _description = json['description'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
  }
  String? _code;
  num? _tHJoId;
  num? _tDJoInspectionActivityStagesId;
  String? _file;
  String? _description;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
InspectionAttachments copyWith({  String? code,
  num? tHJoId,
  num? tDJoInspectionActivityStagesId,
  String? file,
  String? description,
  num? isActive,
  num? isUpload,
  num? createdBy,
  String? createdAt,
  num? updatedBy,
  String? updatedAt,
}) => InspectionAttachments(  code: code ?? _code,
  tHJoId: tHJoId ?? _tHJoId,
  tDJoInspectionActivityStagesId: tDJoInspectionActivityStagesId ?? _tDJoInspectionActivityStagesId,
  file: file ?? _file,
  description: description ?? _description,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get code => _code;
  num? get tHJoId => _tHJoId;
  num? get tDJoInspectionActivityStagesId => _tDJoInspectionActivityStagesId;
  String? get file => _file;
  String? get description => _description;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['t_h_jo_id'] = _tHJoId;
    map['t_d_jo_inspection_activity_stages_id'] = _tDJoInspectionActivityStagesId;
    map['file'] = _file;
    map['description'] = _description;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    return map;
  }

}