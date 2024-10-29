/// id : 3
/// t_h_jo_id : 6
/// t_d_jo_inspection_activity_stages_id : 37
/// path_name : "images/inspection/attach/66d6033c478cf.jpg"
/// file_name : "66d6033c478cf.jpg"
/// description : ""
/// code : ""
/// is_active : 0
/// is_upload : 0
/// created_by : 0
/// updated_by : null
/// created_at : "2024-09-03 01:26:04.0"
/// updated_at : "2024-09-03 01:35:20.0"

class TDJoInspectionAttachment {
  TDJoInspectionAttachment({
      num? id,
      num? tHJoId,
      num? tDJoInspectionActivityStagesId,
      String? pathName,
      String? fileName,
      String? description,
      String? code,
      num? isActive,
      num? isUpload,
      num? createdBy,
      num? updatedBy,
      String? createdAt,
      String? updatedAt,
  }){
    _id = id;
    _tHJoId = tHJoId;
    _tDJoInspectionActivityStagesId = tDJoInspectionActivityStagesId;
    _pathName = pathName;
    _fileName = fileName;
    _description = description;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  TDJoInspectionAttachment.fromJson(dynamic json) {
    _id = json['id'];
    _tHJoId = json['t_h_jo_id'];
    _tDJoInspectionActivityStagesId = json['t_d_jo_inspection_activity_stages_id'];
    _pathName = json['path_name'];
    _fileName = json['file_name'];
    _description = json['description'];
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
  String? _pathName;
  String? _fileName;
  String? _description;
  String? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  num? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
TDJoInspectionAttachment copyWith({
  num? id,
  num? tHJoId,
  num? tDJoInspectionActivityStagesId,
  String? pathName,
  String? fileName,
  String? description,
  String? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  num? updatedBy,
  String? createdAt,
  String? updatedAt,
}) => TDJoInspectionAttachment(  id: id ?? _id,
  tHJoId: tHJoId ?? _tHJoId,
  tDJoInspectionActivityStagesId: tDJoInspectionActivityStagesId ?? _tDJoInspectionActivityStagesId,
  pathName: pathName ?? _pathName,
  fileName: fileName ?? _fileName,
  description: description ?? _description,
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
  String? get pathName => _pathName;
  String? get fileName => _fileName;
  String? get description => _description;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  num? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_h_jo_id'] = _tHJoId;
    map['t_d_jo_inspection_activity_stages_id'] = _tDJoInspectionActivityStagesId;
    map['path_name'] = _pathName;
    map['file_name'] = _fileName;
    map['description'] = _description;
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
    map['path_name'] = _pathName;
    map['file_name'] = _fileName;
    map['description'] = _description;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}