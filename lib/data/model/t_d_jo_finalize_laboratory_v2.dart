import 'package:ops_mobile/data/model/t_d_jo_document_laboratory_v2.dart';
import 'package:ops_mobile/data/sqlite.dart';

/// id : 1
/// t_d_jo_finalize_laboratory : 1
/// no_report : "1"
/// date_report : "1"
/// no_blanko_certificate : "1"
/// lhv_number : "1"
/// ls_number : "1"
/// code : "1"
/// is_active : 0
/// is_upload : 0
/// created_by : 1
/// updated_by : null
/// created_at : null
/// updated_at : null

class TDJoFinalizeLaboratoryV2 {
  TDJoFinalizeLaboratoryV2({
      num? id,
      num? tDJoFinalizeLaboratory,
      String? noReport,
      String? dateReport,
      String? noBlankoCertificate,
      String? lhvNumber,
      String? lsNumber,
      String? code,
      num? isActive,
      num? isUpload,
      num? createdBy,
      dynamic? updatedBy,
      dynamic? createdAt,
      dynamic? updatedAt,
      List<TDJoDocumentLaboratoryV2>? listDocument,
  }){
    _id = id;
    _tDJoFinalizeLaboratory = tDJoFinalizeLaboratory;
    _noReport = noReport;
    _dateReport = dateReport;
    _noBlankoCertificate = noBlankoCertificate;
    _lhvNumber = lhvNumber;
    _lsNumber = lsNumber;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  TDJoFinalizeLaboratoryV2.fromJson(dynamic json) {
    _id = json['id'];
    _tDJoFinalizeLaboratory = json['t_d_jo_finalize_laboratory_id'];
    _noReport = json['no_report'];
    _dateReport = json['date_report'];
    _noBlankoCertificate = json['no_blanko_certificate'];
    _lhvNumber = json['lhv_number'];
    _lsNumber = json['ls_number'];
    _code = json['code'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _updatedBy = json['updated_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['list_document'] != null) {
      _listDocument = (json['list_document'] as List)
          .map((e) => TDJoDocumentLaboratoryV2.fromJson(e))
          .toList();
    } else {
      _listDocument = [];
    }
  }
  num? _id;
  num? _tDJoFinalizeLaboratory;
  String? _noReport;
  String? _dateReport;
  String? _noBlankoCertificate;
  String? _lhvNumber;
  String? _lsNumber;
  String? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  dynamic? _updatedBy;
  dynamic? _createdAt;
  dynamic? _updatedAt;
  List<TDJoDocumentLaboratoryV2>? _listDocument;
TDJoFinalizeLaboratoryV2 copyWith({
  num? id,
  num? tDJoFinalizeLaboratory,
  String? noReport,
  String? dateReport,
  String? noBlankoCertificate,
  String? lhvNumber,
  String? lsNumber,
  String? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  dynamic? updatedBy,
  dynamic? createdAt,
  dynamic? updatedAt,
}) => TDJoFinalizeLaboratoryV2(  id: id ?? _id,
  tDJoFinalizeLaboratory: tDJoFinalizeLaboratory ?? _tDJoFinalizeLaboratory,
  noReport: noReport ?? _noReport,
  dateReport: dateReport ?? _dateReport,
  noBlankoCertificate: noBlankoCertificate ?? _noBlankoCertificate,
  lhvNumber: lhvNumber ?? _lhvNumber,
  lsNumber: lsNumber ?? _lsNumber,
  code: code ?? _code,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdBy: createdBy ?? _createdBy,
  updatedBy: updatedBy ?? _updatedBy,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get tDJoFinalizeLaboratory => _tDJoFinalizeLaboratory;
  String? get noReport => _noReport;
  String? get dateReport => _dateReport;
  String? get noBlankoCertificate => _noBlankoCertificate;
  String? get lhvNumber => _lhvNumber;
  String? get lsNumber => _lsNumber;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  dynamic get updatedBy => _updatedBy;
  dynamic get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;
  List<TDJoDocumentLaboratoryV2>? get listDocument => _listDocument;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_d_jo_finalize_laboratory_id'] = _tDJoFinalizeLaboratory;
    map['no_report'] = _noReport;
    map['date_report'] = _dateReport;
    map['no_blanko_certificate'] = _noBlankoCertificate;
    map['lhv_number'] = _lhvNumber;
    map['ls_number'] = _lsNumber;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_listDocument != null) {
      map['list_document'] = _listDocument?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  static Future<int> updateUploaded(String code) async {
    final db = await SqlHelper.db();
    return await db.update("t_d_jo_finalize_laboratory", {"is_upload": 1},where: "code=?",whereArgs: [code]);
  }

  static Future<TDJoFinalizeLaboratoryV2?> getSendData() async{
    final db = await SqlHelper.db();
    final sql = '''SELECT * from t_d_jo_finalize_laboratory where is_upload  = 0''';
    var result = await db.rawQuery(sql);

    if (result.isEmpty) {
      return null;
    }

    var copyResult = Map<String, dynamic>.from(result.first); // Ambil elemen pertama
    copyResult['list_document'] = await TDJoDocumentLaboratoryV2.getDataSend(copyResult['id'] ?? 0);

    return TDJoFinalizeLaboratoryV2.fromJson(copyResult);
  }

  static Future<TDJoFinalizeLaboratoryV2?> getSendDataById(int id) async{
    final db = await SqlHelper.db();
    final sql = '''SELECT * from t_d_jo_finalize_laboratory where is_upload  = 0 and id=?''';
    var result = await db.rawQuery(sql,[id]);

    if (result.isEmpty) {
      return null;
    }

    var copyResult = Map<String, dynamic>.from(result.first); // Ambil elemen pertama
    copyResult['list_document'] = await TDJoDocumentLaboratoryV2.getDataSend(copyResult['id'] ?? 0);

    return TDJoFinalizeLaboratoryV2.fromJson(copyResult);
  }

  // static Future<TDJoFinalizeLaboratoryV2?> getSendDataById(id) async{
  //   final db = await SqlHelper.db();
  //   final sql = '''SELECT * from t_d_jo_finalize_laboratory where is_upload  = 0 and id = ?''';
  //   var result = await db.rawQuery(sql,[id]);
  //
  //   if (result.isEmpty) {
  //     return null;
  //   }
  //
  //   var copyResult = Map<String, dynamic>.from(result.first); // Ambil elemen pertama
  //   copyResult['list_document'] = await TDJoDocumentLaboratoryV2.getDataSend(copyResult['id'] ?? 0);
  //
  //   return TDJoFinalizeLaboratoryV2.fromJson(copyResult);
  // }

}