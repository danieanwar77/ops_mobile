import 'package:ops_mobile/data/sqlite.dart';

/// id : 1
/// t_d_jo_finalize_inspection_id : 1
/// path_file : "1"
/// file_name : "1"
/// code : "1"
/// is_active : 0
/// is_upload : 0
/// created_by : 1
/// updated_by : null
/// created_at : null
/// updated_at : null

class TDJoDocumentInspectionV2 {
  TDJoDocumentInspectionV2({
      num? id,
      num? tDJoFinalizeInspectionId,
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
    _tDJoFinalizeInspectionId = tDJoFinalizeInspectionId;
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

  TDJoDocumentInspectionV2.fromJson(dynamic json) {
    _id = json['id'];
    _tDJoFinalizeInspectionId = json['t_d_jo_finalize_inspection_id'];
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
  num? _tDJoFinalizeInspectionId;
  String? _pathFile;
  String? _fileName;
  String? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  dynamic _updatedBy;
  dynamic _createdAt;
  dynamic _updatedAt;
TDJoDocumentInspectionV2 copyWith({  num? id,
  num? tDJoFinalizeInspectionId,
  String? pathFile,
  String? fileName,
  String? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  dynamic updatedBy,
  dynamic createdAt,
  dynamic updatedAt,
}) => TDJoDocumentInspectionV2(  id: id ?? _id,
  tDJoFinalizeInspectionId: tDJoFinalizeInspectionId ?? _tDJoFinalizeInspectionId,
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
  num? get tDJoFinalizeInspectionId => _tDJoFinalizeInspectionId;
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
    map['t_d_jo_finalize_inspection_id'] = _tDJoFinalizeInspectionId;
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
    return await db.update("t_d_jo_document_inspection", {"is_upload": 1},where: "code=?",whereArgs: [code]);
  }

  static Future<List<Map<String,dynamic>>> getDataSend(int tDJoFinalizeInspectionId)async{
    final db = await SqlHelper.db();
    final sql = '''SELECT * from t_d_jo_document_inspection where t_d_jo_finalize_inspection_id = ? and is_upload = 0''';

    var result = await db.rawQuery(sql,[tDJoFinalizeInspectionId]);
    var finalResult = result.map(Map<String,dynamic>.from).toList();
    return finalResult;
  }

}