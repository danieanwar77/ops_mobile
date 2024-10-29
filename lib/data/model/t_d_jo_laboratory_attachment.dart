/// id : 1
/// t_d_jo_laboratory_id : 1
/// m_statuslaboratoryprogres_id : 6
/// path_name : "12"
/// file_name : "123"
/// code : "123"
/// is_active : 0
/// is_upload : 0
/// created_by : 1624
/// updated_by : null
/// created_at : null
/// updated_at : null

class TDJoLaboratoryAttachment {
  TDJoLaboratoryAttachment({
      num? id, 
      num? tDJoLaboratoryId, 
      num? mStatuslaboratoryprogresId, 
      String? pathName,
      String? fileName,
      String? code,
      num? isActive, 
      num? isUpload, 
      num? createdBy, 
      dynamic updatedBy, 
      dynamic createdAt, 
      dynamic updatedAt,}){
    _id = id;
    _tDJoLaboratoryId = tDJoLaboratoryId;
    _mStatuslaboratoryprogresId = mStatuslaboratoryprogresId;
    _pathName = pathName;
    _fileName = fileName;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  TDJoLaboratoryAttachment.fromJson(dynamic json) {
    _id = json['id'];
    _tDJoLaboratoryId = json['t_d_jo_laboratory_id'];
    _mStatuslaboratoryprogresId = json['m_statuslaboratoryprogres_id'];
    _pathName = json['path_name'];
    _fileName = json['file_name'];
    _code = json['code'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _updatedBy = json['updated_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _tDJoLaboratoryId;
  num? _mStatuslaboratoryprogresId;
  String? _pathName;
  String? _fileName;
  String? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  dynamic _updatedBy;
  dynamic _createdAt;
  dynamic _updatedAt;
TDJoLaboratoryAttachment copyWith({  num? id,
  num? tDJoLaboratoryId,
  num? mStatuslaboratoryprogresId,
  String? pathName,
  String? fileName,
  String? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  dynamic updatedBy,
  dynamic createdAt,
  dynamic updatedAt,
}) => TDJoLaboratoryAttachment(  id: id ?? _id,
  tDJoLaboratoryId: tDJoLaboratoryId ?? _tDJoLaboratoryId,
  mStatuslaboratoryprogresId: mStatuslaboratoryprogresId ?? _mStatuslaboratoryprogresId,
  pathName: pathName ?? _pathName,
  fileName: fileName ?? _fileName,
  code: code ?? _code,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdBy: createdBy ?? _createdBy,
  updatedBy: updatedBy ?? _updatedBy,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get tDJoLaboratoryId => _tDJoLaboratoryId;
  num? get mStatuslaboratoryprogresId => _mStatuslaboratoryprogresId;
  String? get pathName => _pathName;
  String? get fileName => _fileName;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  dynamic get updatedBy => _updatedBy;
  dynamic get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_d_jo_laboratory_id'] = _tDJoLaboratoryId;
    map['m_statuslaboratoryprogres_id'] = _mStatuslaboratoryprogresId;
    map['path_name'] = _pathName;
    map['file_name'] = _fileName;
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