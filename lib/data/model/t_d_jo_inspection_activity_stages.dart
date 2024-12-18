import 'package:ops_mobile/data/model/t_d_jo_inspection_activity.dart';

/// id : 1
/// t_h_jo_id : 1
/// m_statusinspectionstages_id : 1
/// trans_date : ""
/// actual_qty : ""
/// uom_id : ""
/// remarks : "ndo5X"
/// code : ""
/// is_active : ""
/// is_upload : ""
/// created_by : 1
/// updated_by : ""
/// created_at : "2024-05-15 12:44:06"
/// updated_at : "2024-05-15 12:44:06"

class TDJoInspectionActivityStages {
  TDJoInspectionActivityStages({
    num? id,
    num? tHJoId,
    num? mStatusinspectionstagesId,
    String? transDate,
    String? actualQty,
    String? uomId,
    String? remarks,
    String? code,
    String? isActive,
    String? isUpload,
    num? createdBy,
    String? updatedBy,
    String? createdAt,
    String? updatedAt,
    List<TDJoInspectionActivity>? listActivity,
  }) {
    _id = id;
    _tHJoId = tHJoId;
    _mStatusinspectionstagesId = mStatusinspectionstagesId;
    _transDate = transDate;
    _actualQty = actualQty;
    _uomId = uomId;
    _remarks = remarks;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _listActivity = listActivity ?? [];
  }

  TDJoInspectionActivityStages.fromJson(dynamic json) {
    _id = json['id'];
    _tHJoId = json['t_h_jo_id'];
    _mStatusinspectionstagesId = json['m_statusinspectionstages_id'];
    _transDate = json['trans_date'];
    _actualQty = json['actual_qty'];
    _uomId = json['uom_id'];
    _remarks = json['remarks'];
    _code = json['code'];
    _isActive = json['is_active'].toString();
    _isUpload = json['is_upload'].toString();
    _createdBy = json['created_by'];
    _updatedBy = json['updated_by'].toString();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['listactivity'] != null) {
      _listActivity = (json['listactivity'] as List)
          .map((e) => TDJoInspectionActivity.fromJson(e))
          .toList();
    } else {
      _listActivity = [];
    }
  }

  num? _id;
  num? _tHJoId;
  num? _mStatusinspectionstagesId;
  String? _transDate;
  String? _actualQty;
  String? _uomId;
  String? _remarks;
  String? _code;
  String? _isActive;
  String? _isUpload;
  num? _createdBy;
  String? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
  List<TDJoInspectionActivity>? _listActivity;

  TDJoInspectionActivityStages copyWith({
    num? id,
    num? tHJoId,
    num? mStatusinspectionstagesId,
    String? transDate,
    String? actualQty,
    String? uomId,
    String? remarks,
    String? code,
    String? isActive,
    String? isUpload,
    num? createdBy,
    String? updatedBy,
    String? createdAt,
    String? updatedAt,
    List<TDJoInspectionActivity>? listActivity,
  }) =>
      TDJoInspectionActivityStages(
        id: id ?? _id,
        tHJoId: tHJoId ?? _tHJoId,
        mStatusinspectionstagesId: mStatusinspectionstagesId ?? _mStatusinspectionstagesId,
        transDate: transDate ?? _transDate,
        actualQty: actualQty ?? _actualQty,
        uomId: uomId ?? _uomId,
        remarks: remarks ?? _remarks,
        code: code ?? _code,
        isActive: isActive ?? _isActive,
        isUpload: isUpload ?? _isUpload,
        createdBy: createdBy ?? _createdBy,
        updatedBy: updatedBy ?? _updatedBy,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        listActivity: listActivity ?? _listActivity,
      );

  num? get id => _id;
  num? get tHJoId => _tHJoId;
  num? get mStatusinspectionstagesId => _mStatusinspectionstagesId;
  String? get transDate => _transDate;
  String? get actualQty => _actualQty;
  String? get uomId => _uomId;
  String? get remarks => _remarks;
  String? get code => _code;
  String? get isActive => _isActive;
  String? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<TDJoInspectionActivity>? get listActivity => _listActivity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_h_jo_id'] = _tHJoId;
    map['m_statusinspectionstages_id'] = _mStatusinspectionstagesId;
    map['trans_date'] = _transDate;
    map['actual_qty'] = _actualQty;
    map['uom_id'] = _uomId;
    map['remarks'] = _remarks;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_listActivity != null) {
      map['listactivity'] = _listActivity?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  Map<String, dynamic> toInsert() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_h_jo_id'] = _tHJoId;
    map['m_statusinspectionstages_id'] = _mStatusinspectionstagesId;
    map['trans_date'] = _transDate;
    map['actual_qty'] = _actualQty;
    map['uom_id'] = _uomId;
    map['remarks'] = _remarks;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

  Map<String, dynamic> toEdit() {
    final map = <String, dynamic>{};
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['remarks'] = _remarks;
   // map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    //map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
