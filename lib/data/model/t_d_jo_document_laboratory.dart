/// id : 1
/// t_d_jo_finalize_inspection_id : 1
/// path_file : "/document/inspection/2024/05/15/lNdnB3z.pdf"
/// file_name : null
/// code : null
/// is_active : 0
/// is_upload : 0
/// created_by : 1
/// updated_by : ""
/// created_at : "2024-05-15 12:44:07"
/// updated_at : "2024-05-15 12:44:07"

class TDJoDocumentLaboratory {
  TDJoDocumentLaboratory({
    num? id,
    num? tDJoFinalizeLaboratoryId,
    String? pathFile,
    dynamic fileName,
    dynamic code,
    num? isActive,
    num? isUpload,
    num? createdBy,
    String? updatedBy,
    String? createdAt,
    String? updatedAt,}){
    _id = id;
    _tDJoFinalizeLaboratoryId = tDJoFinalizeLaboratoryId;
    _pathFile = pathFile;
    _fileName = fileName;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  TDJoDocumentLaboratory.fromJson(dynamic json) {
    _id = json['id'];
    _tDJoFinalizeLaboratoryId = json['t_d_jo_finalize_laboratory_id'];
    _pathFile = json['path_file'];
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
  num? _tDJoFinalizeLaboratoryId;
  String? _pathFile;
  dynamic _fileName;
  dynamic _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
  TDJoDocumentLaboratory copyWith({  num? id,
    num? tDJoFinalizeLaboratoryId,
    String? pathFile,
    dynamic fileName,
    dynamic code,
    num? isActive,
    num? isUpload,
    num? createdBy,
    String? updatedBy,
    String? createdAt,
    String? updatedAt,
  }) => TDJoDocumentLaboratory(  id: id ?? _id,
    tDJoFinalizeLaboratoryId: tDJoFinalizeLaboratoryId ?? _tDJoFinalizeLaboratoryId,
    pathFile: pathFile ?? _pathFile,
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
  num? get tDJoFinalizeLaboratoryId => _tDJoFinalizeLaboratoryId;
  String? get pathFile => _pathFile;
  dynamic get fileName => _fileName;
  dynamic get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String?, dynamic> toJson() {
    final map = <String?, dynamic>{};
    map['id'] = _id;
    map['t_d_jo_finalize_laboratory_id'] = _tDJoFinalizeLaboratoryId;
    map['path_file'] = _pathFile;
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