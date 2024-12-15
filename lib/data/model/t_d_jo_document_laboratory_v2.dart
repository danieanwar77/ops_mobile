import 'package:ops_mobile/data/sqlite.dart';

/// id : 1
/// t_d_jo_finalize_laboratory_id : 1
/// path_file : "1"
/// file_name : "1"
/// code : "1"
/// is_active : 0
/// is_upload : 0
/// created_by : 1
/// updated_by : null
/// created_at : null
/// updated_at : null

class TDJoDocumentLaboratoryV2 {
  TDJoDocumentLaboratoryV2({
      num? id,
      num? tDJoFinalizeLaboratoryId,
      String? pathFile,
      String? fileName,
      String? code,
      num? isActive,
      num? isUpload,
      num? createdBy,
      dynamic updatedBy, 
      dynamic createdAt, 
      dynamic updatedAt,}){
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

  TDJoDocumentLaboratoryV2.fromJson(dynamic json) {
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
  String? _fileName;
  String? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  dynamic _updatedBy;
  dynamic _createdAt;
  dynamic _updatedAt;
TDJoDocumentLaboratoryV2 copyWith({  num? id,
  num? tDJoFinalizeLaboratoryId,
  String? pathFile,
  String? fileName,
  String? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  dynamic updatedBy,
  dynamic createdAt,
  dynamic updatedAt,
}) => TDJoDocumentLaboratoryV2(  id: id ?? _id,
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
  String? get fileName => _fileName;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  dynamic get updatedBy => _updatedBy;
  dynamic get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;

  set pathFile(String? value) => _pathFile = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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

  static Future<int> updateUploaded(String code) async {
    final db = await SqlHelper.db();
    return await db.update("t_d_jo_document_laboratory", {"is_upload": 1},where: "code=?",whereArgs: [code]);
  }

  static Future<List<Map<String,dynamic>>> getDataSend(int tDJoFinalizeInspectionId)async{
    final db = await SqlHelper.db();
    final sql = '''SELECT * from t_d_jo_document_laboratory where t_d_jo_finalize_laboratory_id = ? and is_upload  = 0''';

    var result = await db.rawQuery(sql,[tDJoFinalizeInspectionId]);
    var finalResult = result.map(Map<String,dynamic>.from).toList();
    return finalResult;
  }

}