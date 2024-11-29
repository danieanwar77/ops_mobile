/// id : 60
/// t_d_jo_laboratory_activity_stages_id : 88
/// t_d_jo_laboratory_id : 0
/// start_activity_time : "13:18:01"
/// end_activity_time : "14:19:05"
/// activity : "act 1"
/// code : ""
/// is_active : 0
/// is_upload : 0
/// created_by : 1624
/// updated_by : null
/// created_at : "2024-10-08 13:19:13.0"
/// updated_at : "2024-10-08 13:19:13.0"

class TDJoLaboratoryActivity {
  TDJoLaboratoryActivity({
      num? id, 
      num? tDJoLaboratoryActivityStagesId, 
      num? tDJoLaboratoryId, 
      String? startActivityTime,
      String? endActivityTime,
      String? activity,
      String? code,
      num? isActive, 
      num? isUpload, 
      num? createdBy, 
      dynamic updatedBy, 
      String? createdAt,
      String? updatedAt,}){
    _id = id;
    _tDJoLaboratoryActivityStagesId = tDJoLaboratoryActivityStagesId;
    _tDJoLaboratoryId = tDJoLaboratoryId;
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

  TDJoLaboratoryActivity.fromJson(dynamic json) {
    _id = json['id'];
    _tDJoLaboratoryActivityStagesId = json['t_d_jo_laboratory_activity_stages_id'];
    _tDJoLaboratoryId = json['t_d_jo_laboratory_id'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _activity = json['activity'];
    _code = json['code'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _updatedBy = json['updated_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _tDJoLaboratoryActivityStagesId;
  num? _tDJoLaboratoryId;
  String? _startActivityTime;
  String? _endActivityTime;
  String? _activity;
  String? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  dynamic _updatedBy;
  String? _createdAt;
  String? _updatedAt;
TDJoLaboratoryActivity copyWith({  num? id,
  num? tDJoLaboratoryActivityStagesId,
  num? tDJoLaboratoryId,
  String? startActivityTime,
  String? endActivityTime,
  String? activity,
  String? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  dynamic updatedBy,
  String? createdAt,
  String? updatedAt,
}) => TDJoLaboratoryActivity(  id: id ?? _id,
  tDJoLaboratoryActivityStagesId: tDJoLaboratoryActivityStagesId ?? _tDJoLaboratoryActivityStagesId,
  tDJoLaboratoryId: tDJoLaboratoryId ?? _tDJoLaboratoryId,
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
  num? get tDJoLaboratoryActivityStagesId => _tDJoLaboratoryActivityStagesId;
  num? get tDJoLaboratoryId => _tDJoLaboratoryId;
  String? get startActivityTime => _startActivityTime;
  String? get endActivityTime => _endActivityTime;
  String? get activity => _activity;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  dynamic get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  set startActivityTime(String? value) => _startActivityTime = value;
  set endActivityTime(String? value) => _endActivityTime = value;
  set activity(String? value) => _activity = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_d_jo_laboratory_activity_stages_id'] = _tDJoLaboratoryActivityStagesId;
    map['t_d_jo_laboratory_id'] = _tDJoLaboratoryId;
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
    map['t_d_jo_laboratory_activity_stages_id'] = _tDJoLaboratoryActivityStagesId;
    map['t_d_jo_laboratory_id'] = _tDJoLaboratoryId;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    return map;
  }


  Map<String, dynamic> toEdit() {
    final map = <String, dynamic>{};
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    return map;
  }

}