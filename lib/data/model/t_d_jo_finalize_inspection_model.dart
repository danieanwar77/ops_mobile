/// id : 1
/// t_h_jo_id : 6
/// no_report : "shdjdjfjfjf"
/// date_report : "2024-10-25"
/// no_blanko_certificate : "sudjdjfjc"
/// lhv_num?ber : "sudjdjfjc"
/// ls_num?ber : "sjdjdjdjfdi"
/// code : "JDOI-1624-1729836484407"
/// is_active : 1
/// is_upload : 0
/// created_by : 1624
/// updated_by : 0
/// created_at : "2024-10-25 13:08:04.407820"
/// updated_at : ""

class TDJoFinalizeInspectionModel {
  TDJoFinalizeInspectionModel({
      num? id, 
      num? tHJoId, 
      String? noReport, 
      String? dateReport, 
      String? noBlankoCertificate, 
      String? lhvNumber, 
      String? lsNumber, 
      String? code, 
      num? isActive, 
      num? isUpload, 
      num? createdBy, 
      num? updatedBy, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _tHJoId = tHJoId;
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

  TDJoFinalizeInspectionModel.fromJson(dynamic json) {
    _id = json['id'];
    _tHJoId = json['t_h_jo_id'];
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
  }
  num? _id;
  num? _tHJoId;
  String? _noReport;
  String? _dateReport;
  String? _noBlankoCertificate;
  String? _lhvNumber;
  String? _lsNumber;
  String? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  num? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
TDJoFinalizeInspectionModel copyWith({  num? id,
  num? tHJoId,
  String? noReport,
  String? dateReport,
  String? noBlankoCertificate,
  String? lhvNumber,
  String? lsNumber,
  String? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  num? updatedBy,
  String? createdAt,
  String? updatedAt,
}) => TDJoFinalizeInspectionModel(  id: id ?? _id,
  tHJoId: tHJoId ?? _tHJoId,
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
  num? get tHJoId => _tHJoId;
  String? get noReport => _noReport;
  String? get dateReport => _dateReport;
  String? get noBlankoCertificate => _noBlankoCertificate;
  String? get lhvNumber => _lhvNumber;
  String? get lsNumber => _lsNumber;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  num? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String?, dynamic> toJson() {
    final map = <String?, dynamic>{};
    map['id'] = _id;
    map['t_h_jo_id'] = _tHJoId;
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
    return map;
  }

}