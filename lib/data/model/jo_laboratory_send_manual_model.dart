/// laboratory_activity : [{"t_d_jo_laboratory_activity_stages":{"id":0,"code":"","t_d_jo_laboratory_id":0,"t_h_jo_id":0,"m_statuslaboratoryprogres_id":0,"trans_date":"","remarks":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""},"t_d_jo_laboratory_activity":[{"id":0,"code":"","t_d_jo_laboratory_id":0,"t_d_jo_laboratory_activity_stages_id":0,"t_h_jo_id":0,"start_activity_time":"","end_activity_time":"","activity":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}],"issued_analyzed_result":{"t_d_jo_laboratory_activity_stages_id":0,"t_d_jo_laboratory_id":0,"activity_date":"","activity_time":"","total_sample_received":0,"total_sample_analyzed":0,"total_sample_preparation":0},"attachment":[{"id":0,"t_h_jo_id":0,"t_d_jo_laboratory_id":0,"t_d_jo_laboratory_activity_stages_id":0,"path_name":"","file_name":"","description":"","code":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}]}]
/// finalize_laboratory : [{"id":0,"no_report":"","date_report":"","no_blanko_certificate":"","lhv_number":"","ls_number":"","documents":[{"id":0,"path_file":"","file_name":""}]}]

class JoLaboratorySendManualModel {
  JoLaboratorySendManualModel({
      List<LaboratoryActivity>? laboratoryActivity,
      List<FinalizeLaboratory>? finalizeLaboratory,}){
    _laboratoryActivity = laboratoryActivity;
    _finalizeLaboratory = finalizeLaboratory;
}

  JoLaboratorySendManualModel.fromJson(dynamic json) {
    if (json['laboratory_activity'] != null) {
      _laboratoryActivity = [];
      json['laboratory_activity'].forEach((v) {
        _laboratoryActivity?.add(LaboratoryActivity.fromJson(v));
      });
    }
    if (json['finalize_laboratory'] != null) {
      _finalizeLaboratory = [];
      json['finalize_laboratory'].forEach((v) {
        _finalizeLaboratory?.add(FinalizeLaboratory.fromJson(v));
      });
    }
  }
  List<LaboratoryActivity>? _laboratoryActivity;
  List<FinalizeLaboratory>? _finalizeLaboratory;
JoLaboratorySendManualModel copyWith({  List<LaboratoryActivity>? laboratoryActivity,
  List<FinalizeLaboratory>? finalizeLaboratory,
}) => JoLaboratorySendManualModel(  laboratoryActivity: laboratoryActivity ?? _laboratoryActivity,
  finalizeLaboratory: finalizeLaboratory ?? _finalizeLaboratory,
);
  List<LaboratoryActivity>? get laboratoryActivity => _laboratoryActivity;
  List<FinalizeLaboratory>? get finalizeLaboratory => _finalizeLaboratory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_laboratoryActivity != null) {
      map['laboratory_activity'] = _laboratoryActivity?.map((v) => v.toJson()).toList();
    }
    if (_finalizeLaboratory != null) {
      map['finalize_laboratory'] = _finalizeLaboratory?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 0
/// no_report : ""
/// date_report : ""
/// no_blanko_certificate : ""
/// lhv_number : ""
/// ls_number : ""
/// documents : [{"id":0,"path_file":"","file_name":""}]

class FinalizeLaboratory {
  FinalizeLaboratory({
      num? id, 
      String? noReport, 
      String? dateReport, 
      String? noBlankoCertificate, 
      String? lhvNumber, 
      String? lsNumber, 
      List<LaboratoryDocuments>? documents,}){
    _id = id;
    _noReport = noReport;
    _dateReport = dateReport;
    _noBlankoCertificate = noBlankoCertificate;
    _lhvNumber = lhvNumber;
    _lsNumber = lsNumber;
    _documents = documents;
}

  FinalizeLaboratory.fromJson(dynamic json) {
    _id = json['id'];
    _noReport = json['no_report'];
    _dateReport = json['date_report'];
    _noBlankoCertificate = json['no_blanko_certificate'];
    _lhvNumber = json['lhv_number'];
    _lsNumber = json['ls_number'];
    if (json['documents'] != null) {
      _documents = [];
      json['documents'].forEach((v) {
        _documents?.add(LaboratoryDocuments.fromJson(v));
      });
    }
  }
  num? _id;
  String? _noReport;
  String? _dateReport;
  String? _noBlankoCertificate;
  String? _lhvNumber;
  String? _lsNumber;
  List<LaboratoryDocuments>? _documents;
FinalizeLaboratory copyWith({  num? id,
  String? noReport,
  String? dateReport,
  String? noBlankoCertificate,
  String? lhvNumber,
  String? lsNumber,
  List<LaboratoryDocuments>? documents,
}) => FinalizeLaboratory(  id: id ?? _id,
  noReport: noReport ?? _noReport,
  dateReport: dateReport ?? _dateReport,
  noBlankoCertificate: noBlankoCertificate ?? _noBlankoCertificate,
  lhvNumber: lhvNumber ?? _lhvNumber,
  lsNumber: lsNumber ?? _lsNumber,
  documents: documents ?? _documents,
);
  num? get id => _id;
  String? get noReport => _noReport;
  String? get dateReport => _dateReport;
  String? get noBlankoCertificate => _noBlankoCertificate;
  String? get lhvNumber => _lhvNumber;
  String? get lsNumber => _lsNumber;
  List<LaboratoryDocuments>? get documents => _documents;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['no_report'] = _noReport;
    map['date_report'] = _dateReport;
    map['no_blanko_certificate'] = _noBlankoCertificate;
    map['lhv_number'] = _lhvNumber;
    map['ls_number'] = _lsNumber;
    if (_documents != null) {
      map['documents'] = _documents?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 0
/// path_file : ""
/// file_name : ""

class LaboratoryDocuments {
  LaboratoryDocuments({
      num? id, 
      String? pathFile, 
      String? fileName,}){
    _id = id;
    _pathFile = pathFile;
    _fileName = fileName;
}

  LaboratoryDocuments.fromJson(dynamic json) {
    _id = json['id'];
    _pathFile = json['path_file'];
    _fileName = json['file_name'];
  }
  num? _id;
  String? _pathFile;
  String? _fileName;
LaboratoryDocuments copyWith({  num? id,
  String? pathFile,
  String? fileName,
}) => LaboratoryDocuments(  id: id ?? _id,
  pathFile: pathFile ?? _pathFile,
  fileName: fileName ?? _fileName,
);
  num? get id => _id;
  String? get pathFile => _pathFile;
  String? get fileName => _fileName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['path_file'] = _pathFile;
    map['file_name'] = _fileName;
    return map;
  }

}

/// t_d_jo_laboratory_activity_stages : {"id":0,"code":"","t_d_jo_laboratory_id":0,"t_h_jo_id":0,"m_statuslaboratoryprogres_id":0,"trans_date":"","remarks":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}
/// t_d_jo_laboratory_activity : [{"id":0,"code":"","t_d_jo_laboratory_id":0,"t_d_jo_laboratory_activity_stages_id":0,"t_h_jo_id":0,"start_activity_time":"","end_activity_time":"","activity":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}]
/// issued_analyzed_result : {"t_d_jo_laboratory_activity_stages_id":0,"t_d_jo_laboratory_id":0,"activity_date":"","activity_time":"","total_sample_received":0,"total_sample_analyzed":0,"total_sample_preparation":0}
/// attachment : [{"id":0,"t_h_jo_id":0,"t_d_jo_laboratory_id":0,"t_d_jo_laboratory_activity_stages_id":0,"path_name":"","file_name":"","description":"","code":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}]

class LaboratoryActivity {
  LaboratoryActivity({
      TDJoLaboratoryActivityStagesSm? tDJoLaboratoryActivityStages, 
      List<TDJoLaboratoryActivitySm>? tDJoLaboratoryActivity, 
      IssuedAnalyzedResult? issuedAnalyzedResult, 
      List<LaboratoryAttachment>? attachment,}){
    _tDJoLaboratoryActivityStages = tDJoLaboratoryActivityStages;
    _tDJoLaboratoryActivity = tDJoLaboratoryActivity;
    _issuedAnalyzedResult = issuedAnalyzedResult;
    _attachment = attachment;
}

  LaboratoryActivity.fromJson(dynamic json) {
    _tDJoLaboratoryActivityStages = json['t_d_jo_laboratory_activity_stages'] != null ? TDJoLaboratoryActivityStagesSm.fromJson(json['t_d_jo_laboratory_activity_stages']) : null;
    if (json['t_d_jo_laboratory_activity'] != null) {
      _tDJoLaboratoryActivity = [];
      json['t_d_jo_laboratory_activity'].forEach((v) {
        _tDJoLaboratoryActivity?.add(TDJoLaboratoryActivitySm.fromJson(v));
      });
    }
    _issuedAnalyzedResult = json['issued_analyzed_result'] != null ? IssuedAnalyzedResult.fromJson(json['issued_analyzed_result']) : null;
    if (json['attachment'] != null) {
      _attachment = [];
      json['attachment'].forEach((v) {
        _attachment?.add(LaboratoryAttachment.fromJson(v));
      });
    }
  }
  TDJoLaboratoryActivityStagesSm? _tDJoLaboratoryActivityStages;
  List<TDJoLaboratoryActivitySm>? _tDJoLaboratoryActivity;
  IssuedAnalyzedResult? _issuedAnalyzedResult;
  List<LaboratoryAttachment>? _attachment;
LaboratoryActivity copyWith({  TDJoLaboratoryActivityStagesSm? tDJoLaboratoryActivityStages,
  List<TDJoLaboratoryActivitySm>? tDJoLaboratoryActivity,
  IssuedAnalyzedResult? issuedAnalyzedResult,
  List<LaboratoryAttachment>? attachment,
}) => LaboratoryActivity(  tDJoLaboratoryActivityStages: tDJoLaboratoryActivityStages ?? _tDJoLaboratoryActivityStages,
  tDJoLaboratoryActivity: tDJoLaboratoryActivity ?? _tDJoLaboratoryActivity,
  issuedAnalyzedResult: issuedAnalyzedResult ?? _issuedAnalyzedResult,
  attachment: attachment ?? _attachment,
);
  TDJoLaboratoryActivityStagesSm? get tDJoLaboratoryActivityStages => _tDJoLaboratoryActivityStages;
  List<TDJoLaboratoryActivitySm>? get tDJoLaboratoryActivity => _tDJoLaboratoryActivity;
  IssuedAnalyzedResult? get issuedAnalyzedResult => _issuedAnalyzedResult;
  List<LaboratoryAttachment>? get attachment => _attachment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_tDJoLaboratoryActivityStages != null) {
      map['t_d_jo_laboratory_activity_stages'] = _tDJoLaboratoryActivityStages?.toJson();
    }
    if (_tDJoLaboratoryActivity != null) {
      map['t_d_jo_laboratory_activity'] = _tDJoLaboratoryActivity?.map((v) => v.toJson()).toList();
    }
    if (_issuedAnalyzedResult != null) {
      map['issued_analyzed_result'] = _issuedAnalyzedResult?.toJson();
    }
    if (_attachment != null) {
      map['attachment'] = _attachment?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class TDJoLaboratoryActivityStagesSm {
  TDJoLaboratoryActivityStagesSm({
    num? id,
    String? code,
    num? tDJoLaboratoryId,

    num? tHJoId,
    num? mStatuslaboratoryprogresId,
    String? transDate,
    String? remarks,
    num? isActive,
    num? isUpload,
    num? createdBy,
    String? createdAt,
    num? updatedBy,
    String? updatedAt,}){
    _id = id;
    _tDJoLaboratoryId = tDJoLaboratoryId;
    _code = code;
    _tHJoId = tHJoId;
    _mStatuslaboratoryprogresId = mStatuslaboratoryprogresId;
    _transDate = transDate;
    _remarks = remarks;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
  }

  TDJoLaboratoryActivityStagesSm.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _tDJoLaboratoryId = json['t_d_jo_laboratory_id'];
    _tHJoId = json['t_h_jo_id'];
    _mStatuslaboratoryprogresId = json['m_statuslaboratoryprogres_id'];
    _transDate = json['trans_date'];
    _remarks = json['remarks'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _code;
  num? _tDJoLaboratoryId;
  num? _tHJoId;
  num? _mStatuslaboratoryprogresId;
  String? _transDate;
  String? _remarks;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
  TDJoLaboratoryActivityStagesSm copyWith({ num? id,
    String? code,
    num? tDJoLaboratoryId,
    num? tHJoId,
    num? mStatuslaboratoryprogresId,
    String? transDate,
    String? remarks,
    num? isActive,
    num? isUpload,
    num? createdBy,
    String? createdAt,
    num? updatedBy,
    String? updatedAt,
  }) => TDJoLaboratoryActivityStagesSm(  id: id ?? _id,
    code: code ?? _code,
    tDJoLaboratoryId: tDJoLaboratoryId ?? _tDJoLaboratoryId,
    tHJoId: tHJoId ?? _tHJoId,
    mStatuslaboratoryprogresId: mStatuslaboratoryprogresId ?? _mStatuslaboratoryprogresId,
    transDate: transDate ?? _transDate,
    remarks: remarks ?? _remarks,
    isActive: isActive ?? _isActive,
    isUpload: isUpload ?? _isUpload,
    createdBy: createdBy ?? _createdBy,
    createdAt: createdAt ?? _createdAt,
    updatedBy: updatedBy ?? _updatedBy,
    updatedAt: updatedAt ?? _updatedAt,
  );
  num? get id => _id;
  String? get code => _code;
  num? get tDJoLaboratoryId => _tDJoLaboratoryId;
  num? get tHJoId => _tHJoId;
  num? get mStatuslaboratoryprogresId => _mStatuslaboratoryprogresId;
  String? get transDate => _transDate;
  String? get remarks => _remarks;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['t_d_jo_laboratory_id'] = _tDJoLaboratoryId;
    map['t_h_jo_id'] = _tHJoId;
    map['m_statuslaboratoryprogres_id'] = _mStatuslaboratoryprogresId;
    map['trans_date'] = _transDate;
    map['remarks'] = _remarks;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    return map;
  }

}

class TDJoLaboratoryActivitySm {
  TDJoLaboratoryActivitySm({
    num? id,
    String? code,
    num? tDJoLaboratoryId,
    num? tDJoLaboratoryActivityStagesId,
    num? tHJoId,
    String? startActivityTime,
    String? endActivityTime,
    String? activity,
    num? isActive,
    num? isUpload,
    num? createdBy,
    String? createdAt,
    num? updatedBy,
    String? updatedAt,}){
    _id = id;
    _code = code;
    _tDJoLaboratoryId = tDJoLaboratoryId;
    _tDJoLaboratoryActivityStagesId = tDJoLaboratoryActivityStagesId;
    _tHJoId = tHJoId;
    _startActivityTime = startActivityTime;
    _endActivityTime = endActivityTime;
    _activity = activity;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
  }

  TDJoLaboratoryActivitySm.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _tDJoLaboratoryId = json['t_d_jo_laboratory_id'];
    _tDJoLaboratoryActivityStagesId = json['t_d_jo_laboratory_activity_stages_id'];
    _tHJoId = json['t_h_jo_id'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _activity = json['activity'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _code;
  num? _tDJoLaboratoryId;
  num? _tDJoLaboratoryActivityStagesId;
  num? _tHJoId;
  String? _startActivityTime;
  String? _endActivityTime;
  String? _activity;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
  TDJoLaboratoryActivitySm copyWith({  num? id,
    String? code,
    num? tDJoLaboratoryId,
    num? tDJoLaboratoryActivityStagesId,
    num? tHJoId,
    String? startActivityTime,
    String? endActivityTime,
    String? activity,
    num? isActive,
    num? isUpload,
    num? createdBy,
    String? createdAt,
    num? updatedBy,
    String? updatedAt,
  }) => TDJoLaboratoryActivitySm(  id: id ?? _id,
    code: code ?? _code,
    tDJoLaboratoryId: tDJoLaboratoryId ?? _tDJoLaboratoryId,
    tDJoLaboratoryActivityStagesId: tDJoLaboratoryActivityStagesId ?? _tDJoLaboratoryActivityStagesId,
    tHJoId: tHJoId ?? _tHJoId,
    startActivityTime: startActivityTime ?? _startActivityTime,
    endActivityTime: endActivityTime ?? _endActivityTime,
    activity: activity ?? _activity,
    isActive: isActive ?? _isActive,
    isUpload: isUpload ?? _isUpload,
    createdBy: createdBy ?? _createdBy,
    createdAt: createdAt ?? _createdAt,
    updatedBy: updatedBy ?? _updatedBy,
    updatedAt: updatedAt ?? _updatedAt,
  );
  num? get id => _id;
  String? get code => _code;
  num? get tDJoLaboratoryId => _tDJoLaboratoryId;
  num? get tDJoLaboratoryActivityStagesId => _tDJoLaboratoryActivityStagesId;
  num? get tHJoId => _tHJoId;
  String? get startActivityTime => _startActivityTime;
  String? get endActivityTime => _endActivityTime;
  String? get activity => _activity;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['t_d_jo_laboratory_id'] = _tDJoLaboratoryId;
    map['t_d_jo_laboratory_activity_stages_id'] = _tDJoLaboratoryActivityStagesId;
    map['t_h_jo_id'] = _tHJoId;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    return map;
  }

}

/// id : 0
/// t_h_jo_id : 0
/// t_d_jo_laboratory_id : 0
/// t_d_jo_laboratory_activity_stages_id : 0
/// path_name : ""
/// file_name : ""
/// description : ""
/// code : ""
/// is_active : 0
/// is_upload : 0
/// created_by : 0
/// created_at : ""
/// updated_by : 0
/// updated_at : ""

class LaboratoryAttachment {
  LaboratoryAttachment({
      num? id, 
      num? tHJoId, 
      num? tDJoLaboratoryId, 
      num? tDJoLaboratoryActivityStagesId, 
      String? pathName, 
      String? fileName, 
      String? description, 
      String? code, 
      num? isActive, 
      num? isUpload, 
      num? createdBy, 
      String? createdAt, 
      num? updatedBy, 
      String? updatedAt,}){
    _id = id;
    _tHJoId = tHJoId;
    _tDJoLaboratoryId = tDJoLaboratoryId;
    _tDJoLaboratoryActivityStagesId = tDJoLaboratoryActivityStagesId;
    _pathName = pathName;
    _fileName = fileName;
    _description = description;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
}

  LaboratoryAttachment.fromJson(dynamic json) {
    _id = json['id'];
    _tHJoId = json['t_h_jo_id'];
    _tDJoLaboratoryId = json['t_d_jo_laboratory_id'];
    _tDJoLaboratoryActivityStagesId = json['t_d_jo_laboratory_activity_stages_id'];
    _pathName = json['path_name'];
    _fileName = json['file_name'];
    _description = json['description'];
    _code = json['code'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _tHJoId;
  num? _tDJoLaboratoryId;
  num? _tDJoLaboratoryActivityStagesId;
  String? _pathName;
  String? _fileName;
  String? _description;
  String? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
LaboratoryAttachment copyWith({  num? id,
  num? tHJoId,
  num? tDJoLaboratoryId,
  num? tDJoLaboratoryActivityStagesId,
  String? pathName,
  String? fileName,
  String? description,
  String? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  String? createdAt,
  num? updatedBy,
  String? updatedAt,
}) => LaboratoryAttachment(  id: id ?? _id,
  tHJoId: tHJoId ?? _tHJoId,
  tDJoLaboratoryId: tDJoLaboratoryId ?? _tDJoLaboratoryId,
  tDJoLaboratoryActivityStagesId: tDJoLaboratoryActivityStagesId ?? _tDJoLaboratoryActivityStagesId,
  pathName: pathName ?? _pathName,
  fileName: fileName ?? _fileName,
  description: description ?? _description,
  code: code ?? _code,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get tHJoId => _tHJoId;
  num? get tDJoLaboratoryId => _tDJoLaboratoryId;
  num? get tDJoLaboratoryActivityStagesId => _tDJoLaboratoryActivityStagesId;
  String? get pathName => _pathName;
  String? get fileName => _fileName;
  String? get description => _description;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_h_jo_id'] = _tHJoId;
    map['t_d_jo_laboratory_id'] = _tDJoLaboratoryId;
    map['t_d_jo_laboratory_activity_stages_id'] = _tDJoLaboratoryActivityStagesId;
    map['path_name'] = _pathName;
    map['file_name'] = _fileName;
    map['description'] = _description;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    return map;
  }

}

/// t_d_jo_laboratory_activity_stages_id : 0
/// t_d_jo_laboratory_id : 0
/// activity_date : ""
/// activity_time : ""
/// total_sample_received : 0
/// total_sample_analyzed : 0
/// total_sample_preparation : 0

class IssuedAnalyzedResult {
  IssuedAnalyzedResult({
      num? tDJoLaboratoryActivityStagesId,
      num? tDJoLaboratoryId,
      String? activityDate,
      String? activityTime,
      num? totalSampleReceived,
      num? totalSampleAnalyzed,
      num? totalSamplePreparation,}){
    _tDJoLaboratoryActivityStagesId = tDJoLaboratoryActivityStagesId;
    _tDJoLaboratoryId = tDJoLaboratoryId;
    _activityDate = activityDate;
    _activityTime = activityTime;
    _totalSampleReceived = totalSampleReceived;
    _totalSampleAnalyzed = totalSampleAnalyzed;
    _totalSamplePreparation = totalSamplePreparation;
}

  IssuedAnalyzedResult.fromJson(dynamic json) {
    _tDJoLaboratoryActivityStagesId = json['t_d_jo_laboratory_activity_stages_id'];
    _tDJoLaboratoryId = json['t_d_jo_laboratory_id'];
    _activityDate = json['activity_date'];
    _activityTime = json['activity_time'];
    _totalSampleReceived = json['total_sample_received'];
    _totalSampleAnalyzed = json['total_sample_analyzed'];
    _totalSamplePreparation = json['total_sample_preparation'];
  }
  num? _tDJoLaboratoryActivityStagesId;
  num? _tDJoLaboratoryId;
  String? _activityDate;
  String? _activityTime;
  num? _totalSampleReceived;
  num? _totalSampleAnalyzed;
  num? _totalSamplePreparation;
IssuedAnalyzedResult copyWith({  num? tDJoLaboratoryActivityStagesId,
  num? tDJoLaboratoryId,
  String? activityDate,
  String? activityTime,
  num? totalSampleReceived,
  num? totalSampleAnalyzed,
  num? totalSamplePreparation,
}) => IssuedAnalyzedResult(  tDJoLaboratoryActivityStagesId: tDJoLaboratoryActivityStagesId ?? _tDJoLaboratoryActivityStagesId,
  tDJoLaboratoryId: tDJoLaboratoryId ?? _tDJoLaboratoryId,
  activityDate: activityDate ?? _activityDate,
  activityTime: activityTime ?? _activityTime,
  totalSampleReceived: totalSampleReceived ?? _totalSampleReceived,
  totalSampleAnalyzed: totalSampleAnalyzed ?? _totalSampleAnalyzed,
  totalSamplePreparation: totalSamplePreparation ?? _totalSamplePreparation,
);
  num? get tDJoLaboratoryActivityStagesId => _tDJoLaboratoryActivityStagesId;
  num? get tDJoLaboratoryId => _tDJoLaboratoryId;
  String? get activityDate => _activityDate;
  String? get activityTime => _activityTime;
  num? get totalSampleReceived => _totalSampleReceived;
  num? get totalSampleAnalyzed => _totalSampleAnalyzed;
  num? get totalSamplePreparation => _totalSamplePreparation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['t_d_jo_laboratory_activity_stages_id'] = _tDJoLaboratoryActivityStagesId;
    map['t_d_jo_laboratory_id'] = _tDJoLaboratoryId;
    map['activity_date'] = _activityDate;
    map['activity_time'] = _activityTime;
    map['total_sample_received'] = _totalSampleReceived;
    map['total_sample_analyzed'] = _totalSampleAnalyzed;
    map['total_sample_preparation'] = _totalSamplePreparation;
    return map;
  }

}

/// id : 0
/// code : ""
/// t_d_jo_laboratory_id : 0
/// t_d_jo_laboratory_activity_stages_id : 0
/// t_h_jo_id : 0
/// start_activity_time : ""
/// end_activity_time : ""
/// activity : ""
/// is_active : 0
/// is_upload : 0
/// created_by : 0
/// created_at : ""
/// updated_by : 0
/// updated_at : ""

class TdJoLaboratoryActivity {
  TdJoLaboratoryActivity({
      num? id,
      String? code, 
      num? tDJoLaboratoryId, 
      num? tDJoLaboratoryActivityStagesId, 
      num? tHJoId, 
      String? startActivityTime, 
      String? endActivityTime, 
      String? activity, 
      num? isActive, 
      num? isUpload, 
      num? createdBy, 
      String? createdAt, 
      num? updatedBy, 
      String? updatedAt,}){
    _id = id;
    _code = code;
    _tDJoLaboratoryId = tDJoLaboratoryId;
    _tDJoLaboratoryActivityStagesId = tDJoLaboratoryActivityStagesId;
    _tHJoId = tHJoId;
    _startActivityTime = startActivityTime;
    _endActivityTime = endActivityTime;
    _activity = activity;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
}

  TdJoLaboratoryActivity.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _tDJoLaboratoryId = json['t_d_jo_laboratory_id'];
    _tDJoLaboratoryActivityStagesId = json['t_d_jo_laboratory_activity_stages_id'];
    _tHJoId = json['t_h_jo_id'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _activity = json['activity'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _code;
  num? _tDJoLaboratoryId;
  num? _tDJoLaboratoryActivityStagesId;
  num? _tHJoId;
  String? _startActivityTime;
  String? _endActivityTime;
  String? _activity;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
TdJoLaboratoryActivity copyWith({  num? id,
  String? code,
  num? tDJoLaboratoryId,
  num? tDJoLaboratoryActivityStagesId,
  num? tHJoId,
  String? startActivityTime,
  String? endActivityTime,
  String? activity,
  num? isActive,
  num? isUpload,
  num? createdBy,
  String? createdAt,
  num? updatedBy,
  String? updatedAt,
}) => TdJoLaboratoryActivity(  id: id ?? _id,
  code: code ?? _code,
  tDJoLaboratoryId: tDJoLaboratoryId ?? _tDJoLaboratoryId,
  tDJoLaboratoryActivityStagesId: tDJoLaboratoryActivityStagesId ?? _tDJoLaboratoryActivityStagesId,
  tHJoId: tHJoId ?? _tHJoId,
  startActivityTime: startActivityTime ?? _startActivityTime,
  endActivityTime: endActivityTime ?? _endActivityTime,
  activity: activity ?? _activity,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get code => _code;
  num? get tDJoLaboratoryId => _tDJoLaboratoryId;
  num? get tDJoLaboratoryActivityStagesId => _tDJoLaboratoryActivityStagesId;
  num? get tHJoId => _tHJoId;
  String? get startActivityTime => _startActivityTime;
  String? get endActivityTime => _endActivityTime;
  String? get activity => _activity;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['t_d_jo_laboratory_id'] = _tDJoLaboratoryId;
    map['t_d_jo_laboratory_activity_stages_id'] = _tDJoLaboratoryActivityStagesId;
    map['t_h_jo_id'] = _tHJoId;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    return map;
  }

}

/// id : 0
/// code : ""
/// t_d_jo_laboratory_id : 0
/// t_h_jo_id : 0
/// m_statuslaboratoryprogres_id : 0
/// trans_date : ""
/// remarks : ""
/// is_active : 0
/// is_upload : 0
/// created_by : 0
/// created_at : ""
/// updated_by : 0
/// updated_at : ""

class TdJoLaboratoryActivityStages {
  TdJoLaboratoryActivityStages({
      num? id, 
      String? code, 
      num? tDJoLaboratoryId, 
      num? tHJoId, 
      num? mStatuslaboratoryprogresId, 
      String? transDate, 
      String? remarks, 
      num? isActive, 
      num? isUpload, 
      num? createdBy, 
      String? createdAt, 
      num? updatedBy, 
      String? updatedAt,}){
    _id = id;
    _code = code;
    _tDJoLaboratoryId = tDJoLaboratoryId;
    _tHJoId = tHJoId;
    _mStatuslaboratoryprogresId = mStatuslaboratoryprogresId;
    _transDate = transDate;
    _remarks = remarks;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
}

  TdJoLaboratoryActivityStages.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _tDJoLaboratoryId = json['t_d_jo_laboratory_id'];
    _tHJoId = json['t_h_jo_id'];
    _mStatuslaboratoryprogresId = json['m_statuslaboratoryprogres_id'];
    _transDate = json['trans_date'];
    _remarks = json['remarks'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _code;
  num? _tDJoLaboratoryId;
  num? _tHJoId;
  num? _mStatuslaboratoryprogresId;
  String? _transDate;
  String? _remarks;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
TdJoLaboratoryActivityStages copyWith({  num? id,
  String? code,
  num? tDJoLaboratoryId,
  num? tHJoId,
  num? mStatuslaboratoryprogresId,
  String? transDate,
  String? remarks,
  num? isActive,
  num? isUpload,
  num? createdBy,
  String? createdAt,
  num? updatedBy,
  String? updatedAt,
}) => TdJoLaboratoryActivityStages(  id: id ?? _id,
  code: code ?? _code,
  tDJoLaboratoryId: tDJoLaboratoryId ?? _tDJoLaboratoryId,
  tHJoId: tHJoId ?? _tHJoId,
  mStatuslaboratoryprogresId: mStatuslaboratoryprogresId ?? _mStatuslaboratoryprogresId,
  transDate: transDate ?? _transDate,
  remarks: remarks ?? _remarks,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get code => _code;
  num? get tDJoLaboratoryId => _tDJoLaboratoryId;
  num? get tHJoId => _tHJoId;
  num? get mStatuslaboratoryprogresId => _mStatuslaboratoryprogresId;
  String? get transDate => _transDate;
  String? get remarks => _remarks;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['t_d_jo_laboratory_id'] = _tDJoLaboratoryId;
    map['t_h_jo_id'] = _tHJoId;
    map['m_statuslaboratoryprogres_id'] = _mStatuslaboratoryprogresId;
    map['trans_date'] = _transDate;
    map['remarks'] = _remarks;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    return map;
  }

}