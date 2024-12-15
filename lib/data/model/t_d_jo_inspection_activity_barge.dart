/// id : 1
/// t_h_jo_id : 98
/// t_d_jo_inspection_activity_stages_id : 51
/// barge : "B chila 2"
/// code : ""
/// is_active : 0
/// is_upload : 0
/// created_by : 0
/// updated_by : null
/// created_at : null
/// updated_at : null

class TDJoInspectionActivityBarge {
  TDJoInspectionActivityBarge({
      num? id,
      num? tHJoId,
      num? tDJoInspectionActivityStagesId,
      String? barge,
      String? code,
      num? isActive = 1,
      num? isUpload = 0,
      num? createdBy,
      String? updatedBy,
      String? createdAt,
      String? updatedAt,}){
    _id = id;
    _tHJoId = tHJoId;
    _tDJoInspectionActivityStagesId = tDJoInspectionActivityStagesId;
    _barge = barge;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  TDJoInspectionActivityBarge.fromJson(dynamic json) {
    _id = json['id'];
    _tHJoId = json['t_h_jo_id'];
    _tDJoInspectionActivityStagesId = json['t_d_jo_inspection_activity_stages_id'];
    _barge = json['barge'];
    _code = json['code'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _updatedBy = json['updated_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _tHJoId;
  num? _tDJoInspectionActivityStagesId;
  String? _barge;
  String? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
TDJoInspectionActivityBarge copyWith({
  num? id,
  num?tHJoId,
  num? tDJoInspectionActivityStagesId,
  String? barge,
  String? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  String? updatedBy,
  String? createdAt,
  String? updatedAt,
}) => TDJoInspectionActivityBarge(  id: id ?? _id,
  tHJoId: tHJoId ?? _tHJoId,
  tDJoInspectionActivityStagesId: tDJoInspectionActivityStagesId ?? _tDJoInspectionActivityStagesId,
  barge: barge ?? _barge,
  code: code ?? _code,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdBy: createdBy ?? _createdBy,
  updatedBy: updatedBy ?? _updatedBy,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get tHJoId => _tHJoId;
  num? get tDJoInspectionActivityStagesId => _tDJoInspectionActivityStagesId;
  String? get barge => _barge;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_h_jo_id'] = _tHJoId;
    map['t_d_jo_inspection_activity_stages_id'] = _tDJoInspectionActivityStagesId;
    map['barge'] = _barge;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

  Map<String, dynamic> toInsert() {
    final map = <String, dynamic>{};
    //map['id'] = _id;
    map['t_h_jo_id'] = _tHJoId;
    map['t_d_jo_inspection_activity_stages_id'] = _tDJoInspectionActivityStagesId;
    map['barge'] = _barge;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    //map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    //map['updated_at'] = _updatedAt;
    return map;
  }

}