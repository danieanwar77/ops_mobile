/// id : 1
/// code : "LAB1"
/// m_branch_id : 6
/// name : "Lab UNISPA"
/// preparation_capacity : 157
/// analysis_capacity : 190
/// status : 1
/// created_by : 46
/// updated_by : 15
/// created_at : "2024-05-15 12:44:04.0"
/// updated_at : "2024-06-18 21:57:34.0"
/// lab_type_id : 1

class MLaboratorium {
  MLaboratorium({
      num? id, 
      String? code, 
      num? mBranchId, 
      String? name, 
      num? preparationCapacity, 
      num? analysisCapacity, 
      num? status, 
      num? createdBy, 
      num? updatedBy, 
      String? createdAt, 
      String? updatedAt, 
      num? labTypeId,}){
    _id = id;
    _code = code;
    _mBranchId = mBranchId;
    _name = name;
    _preparationCapacity = preparationCapacity;
    _analysisCapacity = analysisCapacity;
    _status = status;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _labTypeId = labTypeId;
}

  MLaboratorium.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _mBranchId = json['m_branch_id'];
    _name = json['name'];
    _preparationCapacity = json['preparation_capacity'];
    _analysisCapacity = json['analysis_capacity'];
    _status = json['status'];
    _createdBy = json['created_by'];
    _updatedBy = json['updated_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _labTypeId = json['lab_type_id'];
  }
  num? _id;
  String? _code;
  num? _mBranchId;
  String? _name;
  num? _preparationCapacity;
  num? _analysisCapacity;
  num? _status;
  num? _createdBy;
  num? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
  num? _labTypeId;
MLaboratorium copyWith({  num? id,
  String? code,
  num? mBranchId,
  String? name,
  num? preparationCapacity,
  num? analysisCapacity,
  num? status,
  num? createdBy,
  num? updatedBy,
  String? createdAt,
  String? updatedAt,
  num? labTypeId,
}) => MLaboratorium(  id: id ?? _id,
  code: code ?? _code,
  mBranchId: mBranchId ?? _mBranchId,
  name: name ?? _name,
  preparationCapacity: preparationCapacity ?? _preparationCapacity,
  analysisCapacity: analysisCapacity ?? _analysisCapacity,
  status: status ?? _status,
  createdBy: createdBy ?? _createdBy,
  updatedBy: updatedBy ?? _updatedBy,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  labTypeId: labTypeId ?? _labTypeId,
);
  num? get id => _id;
  String? get code => _code;
  num? get mBranchId => _mBranchId;
  String? get name => _name;
  num? get preparationCapacity => _preparationCapacity;
  num? get analysisCapacity => _analysisCapacity;
  num? get status => _status;
  num? get createdBy => _createdBy;
  num? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get labTypeId => _labTypeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['m_branch_id'] = _mBranchId;
    map['name'] = _name;
    map['preparation_capacity'] = _preparationCapacity;
    map['analysis_capacity'] = _analysisCapacity;
    map['status'] = _status;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['lab_type_id'] = _labTypeId;
    return map;
  }

}