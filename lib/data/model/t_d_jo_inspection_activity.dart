/// id : 105
/// t_h_jo_id : 107
/// t_d_jo_inspection_activity_stages_id : 80
/// start_activity_time : "18:03:24"
/// end_activity_time : "19:03:26"
/// activity : "act 1"
/// code : null
/// is_active : 0
/// is_upload : 0
/// created_by : 0
/// updated_by : ""
/// created_at : "2024-10-10 18:03:33"
/// updated_at : "2024-10-10 18:03:33"

class TDJoInspectionActivity {
  TDJoInspectionActivity({
      num? id,
      num? tHJoId,
      num? tDJoInspectionActivityStagesId,
      String? startActivityTime,
      String? endActivityTime,
      String? activity,
      String? code,
      num? isActive,
      num? isUpload,
      num? createdBy,
      String? updatedBy,
      String? createdAt,
      String? updatedAt,
  }){
    _id = id;
    _tHJoId = tHJoId;
    _tDJoInspectionActivityStagesId = tDJoInspectionActivityStagesId;
    _startActivityTime = startActivityTime;
    _endActivityTime = endActivityTime;
    _activity = activity;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  TDJoInspectionActivity.fromJson(dynamic json) {
    _id = json['id'];
    _tHJoId = json['t_h_jo_id'];
    _tDJoInspectionActivityStagesId = json['t_d_jo_inspection_activity_stages_id'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _activity = json['activity'];
    _code = json['code'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _updatedBy = json['updated_by'].toString();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _tHJoId;
  num? _tDJoInspectionActivityStagesId;
  String? _startActivityTime;
  String? _endActivityTime;
  String? _activity;
  String? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
TDJoInspectionActivity copyWith({  num? id,
  num? tHJoId,
  num? tDJoInspectionActivityStagesId,
  String? startActivityTime,
  String? endActivityTime,
  String? activity,
  String? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  String? updatedBy,
  String? createdAt,
  String?updatedAt,
}) => TDJoInspectionActivity(  id: id ?? _id,
  tHJoId: tHJoId ?? _tHJoId,
  tDJoInspectionActivityStagesId: tDJoInspectionActivityStagesId ?? _tDJoInspectionActivityStagesId,
  startActivityTime: startActivityTime ?? _startActivityTime,
  endActivityTime: endActivityTime ?? _endActivityTime,
  activity: activity ?? _activity,
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
  String? get startActivityTime => _startActivityTime;
  String? get endActivityTime => _endActivityTime;
  String? get activity => _activity;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  set startActivityTime(String? value) => _startActivityTime = value;
  set endActivityTime(String? value) => _endActivityTime = value;
  set activity(String? value) => _activity = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_h_jo_id'] = _tHJoId;
    map['t_d_jo_inspection_activity_stages_id'] = _tDJoInspectionActivityStagesId;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
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
    map['id'] = _id;
    map['t_h_jo_id'] = _tHJoId;
    map['t_d_jo_inspection_activity_stages_id'] = _tDJoInspectionActivityStagesId;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

  Map<String, dynamic> toEdit() {
    final map = <String, dynamic>{};
    //map['id'] = _id;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    //map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    //map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}