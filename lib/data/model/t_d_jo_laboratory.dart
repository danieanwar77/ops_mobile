/// id : 6
/// t_h_jo_id : 17
/// laboratorium_id : 6
/// prelim_date : null
/// TAT : null
/// code : null
/// is_active : 0
/// is_upload : 0
/// created_by : 46
/// updated_by : null
/// created_at : "2024-07-03 10:32:34.0"
/// updated_at : "2024-07-03 10:32:34.0"

class TDJoLaboratory {
  TDJoLaboratory({
      num? id,
      num? tHJoId,
      num? laboratoriumId,
      dynamic? laboratoriumName,
      dynamic? prelimDate,
      dynamic? tat,
      dynamic code, 
      num? isActive,
      num? isUpload,
      num? createdBy,
      dynamic? updatedBy,
      String? createdAt,
      String? updatedAt,}){
    _id = id;
    _tHJoId = tHJoId;
    _laboratoriumId = laboratoriumId;
    _prelimDate = prelimDate;
    _tat = tat;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  TDJoLaboratory.fromJson(dynamic json) {
    _id = json['id'];
    _tHJoId = json['t_h_jo_id'];
    _laboratoriumId = json['laboratorium_id'];
    _laboratoriumName = json['laboratorium_name'];
    _prelimDate = json['prelim_date'];
    _tat = json['TAT'];
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
  num? _laboratoriumId;
  String? _laboratoriumName;
  dynamic? _prelimDate;
  dynamic? _tat;
  dynamic? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  dynamic? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
TDJoLaboratory copyWith({  num? id,
  num? tHJoId,
  num? laboratoriumId,
  dynamic? prelimDate,
  dynamic? tat,
  dynamic? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  dynamic? updatedBy,
  String? createdAt,
  String? updatedAt,
}) => TDJoLaboratory(  id: id ?? _id,
  tHJoId: tHJoId ?? _tHJoId,
  laboratoriumId: laboratoriumId ?? _laboratoriumId,
  prelimDate: prelimDate ?? _prelimDate,
  tat: tat ?? _tat,
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
  num? get laboratoriumId => _laboratoriumId;
  String? get laboraoriumName => _laboratoriumName;
  dynamic? get prelimDate => _prelimDate;
  dynamic? get tat => _tat;
  dynamic? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  dynamic? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_h_jo_id'] = _tHJoId;
    map['laboratorium_id'] = _laboratoriumId;
    map['laboratorium_name'] = _laboratoriumName;
    map['prelim_date'] = _prelimDate;
    map['TAT'] = _tat;
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