import 'package:ops_mobile/data/model/t_d_jo_laboratory_activity.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_attachment.dart';

/// id : 21
/// d_jo_laboratory_id : 6
/// t_h_jo_id : 0
/// m_statuslaboratoryprogres_id : 1
/// trans_date : "2024-08-31"
/// remarks : "testingg alam cek lagi aja lagi"
/// created_by : 0
/// updated_by : 0
/// created_at : "2024-09-03 11:07:51.0"
/// updated_at : "2024-10-02 14:21:34.0"
/// total_sample_received : null
/// total_sample_analyzed : null
/// total_sample_preparation : null
/// code : null
/// is_active : 0
/// is_upload : 0

class TDJoLaboratoryActivityStages {
  TDJoLaboratoryActivityStages({
    num? id,
    num? dJoLaboratoryId,
    num? tHJoId,
    num? mStatuslaboratoryprogresId,
    String? transDate,
    String? remarks,
    num? createdBy,
    num? updatedBy,
    String? createdAt,
    String? updatedAt,
    dynamic totalSampleReceived,
    dynamic totalSampleAnalyzed,
    dynamic totalSamplePreparation,
    dynamic code,
    num? isActive,
    num? isUpload,
    List<TDJoLaboratoryActivity>? listLabActivity,
    List<TDJoLaboratoryAttachment>? listLabAttachment,
  }) {
    _id = id;
    _dJoLaboratoryId = dJoLaboratoryId;
    _tHJoId = tHJoId;
    _mStatuslaboratoryprogresId = mStatuslaboratoryprogresId;
    _transDate = transDate;
    _remarks = remarks;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _totalSampleReceived = totalSampleReceived;
    _totalSampleAnalyzed = totalSampleAnalyzed;
    _totalSamplePreparation = totalSamplePreparation;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _listLabActivity = listLabActivity ?? [];
    _listLabAttachment = listLabAttachment ?? [];
  }

  TDJoLaboratoryActivityStages.fromJson(dynamic json) {
    _id = json['id'];
    _dJoLaboratoryId = json['d_jo_laboratory_id'];
    _tHJoId = json['t_h_jo_id'];
    _mStatuslaboratoryprogresId = json['m_statuslaboratoryprogres_id'];
    _transDate = json['trans_date'];
    _remarks = json['remarks'];
    _createdBy = json['created_by'];
    _updatedBy = json['updated_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _totalSampleReceived = json['total_sample_received'];
    _totalSampleAnalyzed = json['total_sample_analyzed'];
    _totalSamplePreparation = json['total_sample_preparation'];
    _code = json['code'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];

    if (json['list_lab_activity'] != null) {
      _listLabActivity = (json['list_lab_activity'] as List)
          .map((e) => TDJoLaboratoryActivity.fromJson(e))
          .toList();
    } else {
      _listLabActivity = [];
    }

    if (json['list_lab_attachment'] != null) {
      _listLabAttachment = (json['list_lab_attachment'] as List)
          .map((e) => TDJoLaboratoryAttachment.fromJson(e))
          .toList();
    } else {
      _listLabAttachment = [];
    }
  }

  num? _id;
  num? _dJoLaboratoryId;
  num? _tHJoId;
  num? _mStatuslaboratoryprogresId;
  String? _transDate;
  String? _remarks;
  num? _createdBy;
  num? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
  dynamic _totalSampleReceived;
  dynamic _totalSampleAnalyzed;
  dynamic _totalSamplePreparation;
  dynamic _code;
  num? _isActive;
  num? _isUpload;
  List<TDJoLaboratoryActivity>? _listLabActivity;
  List<TDJoLaboratoryAttachment>? _listLabAttachment;

  TDJoLaboratoryActivityStages copyWith({
    num? id,
    num? dJoLaboratoryId,
    num? tHJoId,
    num? mStatuslaboratoryprogresId,
    String? transDate,
    String? remarks,
    num? createdBy,
    num? updatedBy,
    String? createdAt,
    String? updatedAt,
    dynamic totalSampleReceived,
    dynamic totalSampleAnalyzed,
    dynamic totalSamplePreparation,
    dynamic code,
    num? isActive,
    num? isUpload,
    List<TDJoLaboratoryActivity>? listLabActivity,
    List<TDJoLaboratoryAttachment>? listLabAttachment,
  }) =>
      TDJoLaboratoryActivityStages(
        id: id ?? _id,
        dJoLaboratoryId: dJoLaboratoryId ?? _dJoLaboratoryId,
        tHJoId: tHJoId ?? _tHJoId,
        mStatuslaboratoryprogresId: mStatuslaboratoryprogresId ?? _mStatuslaboratoryprogresId,
        transDate: transDate ?? _transDate,
        remarks: remarks ?? _remarks,
        createdBy: createdBy ?? _createdBy,
        updatedBy: updatedBy ?? _updatedBy,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        totalSampleReceived: totalSampleReceived ?? _totalSampleReceived,
        totalSampleAnalyzed: totalSampleAnalyzed ?? _totalSampleAnalyzed,
        totalSamplePreparation: totalSamplePreparation ?? _totalSamplePreparation,
        code: code ?? _code,
        isActive: isActive ?? _isActive,
        isUpload: isUpload ?? _isUpload,
        listLabActivity: listLabActivity ?? _listLabActivity,
        listLabAttachment: listLabAttachment ?? _listLabAttachment,
      );

  num? get id => _id;
  num? get dJoLaboratoryId => _dJoLaboratoryId;
  num? get tHJoId => _tHJoId;
  num? get mStatuslaboratoryprogresId => _mStatuslaboratoryprogresId;
  String? get transDate => _transDate;
  String? get remarks => _remarks;
  num? get createdBy => _createdBy;
  num? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get totalSampleReceived => _totalSampleReceived;
  dynamic get totalSampleAnalyzed => _totalSampleAnalyzed;
  dynamic get totalSamplePreparation => _totalSamplePreparation;
  dynamic get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  List<TDJoLaboratoryActivity>? get listLabActivity => _listLabActivity;
  List<TDJoLaboratoryAttachment>? get listLabAttachment => _listLabAttachment;

  set listLabActivity(List<TDJoLaboratoryActivity>? value) => _listLabActivity = value ?? [];
  set listLabAttachment(List<TDJoLaboratoryAttachment>? value) => _listLabAttachment = value ?? [];
  set createdBy(num? value) => _createdBy = value;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['d_jo_laboratory_id'] = _dJoLaboratoryId;
    map['t_h_jo_id'] = _tHJoId;
    map['m_statuslaboratoryprogres_id'] = _mStatuslaboratoryprogresId;
    map['trans_date'] = _transDate;
    map['remarks'] = _remarks;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['total_sample_received'] = _totalSampleReceived;
    map['total_sample_analyzed'] = _totalSampleAnalyzed;
    map['total_sample_preparation'] = _totalSamplePreparation;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    if (_listLabActivity != null) {
      map['list_lab_activity'] = _listLabActivity?.map((v) => v.toJson()).toList();
    }
    if (_listLabAttachment != null) {
      map['list_lab_attachment'] = _listLabAttachment?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  Map<String, dynamic> toInsert() {
    final map = <String, dynamic>{};
    map['d_jo_laboratory_id'] = _dJoLaboratoryId;
    map['t_h_jo_id'] = _tHJoId;
    map['m_statuslaboratoryprogres_id'] = _mStatuslaboratoryprogresId;
    map['trans_date'] = _transDate;
    map['remarks'] = _remarks;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['total_sample_received'] = _totalSampleReceived;
    map['total_sample_analyzed'] = _totalSampleAnalyzed;
    map['total_sample_preparation'] = _totalSamplePreparation;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    return map;
  }

  Map<String, dynamic> toEdit() {
    final map = <String, dynamic>{};
    map['remarks'] = _remarks;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    map['total_sample_received'] = _totalSampleReceived;
    map['total_sample_analyzed'] = _totalSampleAnalyzed;
    map['total_sample_preparation'] = _totalSamplePreparation;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    return map;
  }
}