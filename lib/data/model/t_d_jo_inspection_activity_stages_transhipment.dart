/// id : 4
/// t_d_inspection_stages_id : 38
/// t_d_jo_inspection_activity_id : 64
/// initial_date : "2024-09-01"
/// final_date : "2024-09-02"
/// date_arrive : null
/// delivery_qty : 10.0
/// uom_id : 2
/// created_by : 0
/// jetty : "Jetty A"
/// code : ""
/// is_active : 0
/// is_upload : 0
/// updated_by : null
/// created_at : "2024-09-02 14:08:04.0"
/// updated_at : "2024-09-03 00:54:46.0"

class TDJoInspectionActivityStagesTranshipment {
  TDJoInspectionActivityStagesTranshipment({
      num? id,
      num? tDInspectionStagesId,
      num? tDJoInspectionActivityId,
      String? initialDate,
      String? finalDate,
      String? dateArrive,
      double? deliveryQty,
      num? uomId,
      String? uomName,
      num? createdBy,
      String? jetty,
      String? code,
      num? isActive= 1,
      num? isUpload= 0,
      String? updatedBy,
      String? createdAt,
      String? updatedAt,}){
    _id = id;
    _tDInspectionStagesId = tDInspectionStagesId;
    _tDJoInspectionActivityId = tDJoInspectionActivityId;
    _initialDate = initialDate;
    _finalDate = finalDate;
    _dateArrive = dateArrive;
    _deliveryQty = deliveryQty;
    _uomId = uomId;
    _uomName = uomName;
    _createdBy = createdBy;
    _jetty = jetty;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  TDJoInspectionActivityStagesTranshipment.fromJson(dynamic json) {
    _id = json['id'];
    _tDInspectionStagesId = json['t_d_inspection_stages_id'];
    _tDJoInspectionActivityId = json['t_d_jo_inspection_activity_id'];
    _initialDate = json['initial_date'];
    _finalDate = json['final_date'];
    _dateArrive = json['date_arrive'];
    _deliveryQty = json['delivery_qty'];
    _uomId = json['uom_id'];
    _uomName = json['uom_name'];
    _createdBy = json['created_by'];
    _jetty = json['jetty'];
    _code = json['code'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _updatedBy = json['updated_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _tDInspectionStagesId;
  num? _tDJoInspectionActivityId;
  String? _initialDate;
  String? _finalDate;
  dynamic? _dateArrive;
  double? _deliveryQty;
  num? _uomId;
  String? _uomName;
  num? _createdBy;
  String? _jetty;
  String? _code;
  num? _isActive;
  num? _isUpload;
  String? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
TDJoInspectionActivityStagesTranshipment copyWith({
  num? id,
  num? tDInspectionStagesId,
  num? tDJoInspectionActivityId,
  String? initialDate,
  String? finalDate,
  String? dateArrive,
  double? deliveryQty,
  num? uomId,
  String? uomName,
  num? createdBy,
  String? jetty,
  String? code,
  num? isActive,
  num? isUpload,
  String? updatedBy,
  String? createdAt,
  String? updatedAt,
}) => TDJoInspectionActivityStagesTranshipment(  id: id ?? _id,
  tDInspectionStagesId: tDInspectionStagesId ?? _tDInspectionStagesId,
  tDJoInspectionActivityId: tDJoInspectionActivityId ?? _tDJoInspectionActivityId,
  initialDate: initialDate ?? _initialDate,
  finalDate: finalDate ?? _finalDate,
  dateArrive: dateArrive ?? _dateArrive,
  deliveryQty: deliveryQty ?? _deliveryQty,
  uomId: uomId ?? _uomId,
  uomName: uomName ?? _uomName,
  createdBy: createdBy ?? _createdBy,
  jetty: jetty ?? _jetty,
  code: code ?? _code,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  updatedBy: updatedBy ?? _updatedBy,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num?get tDInspectionStagesId => _tDInspectionStagesId;
  num? get tDJoInspectionActivityId => _tDJoInspectionActivityId;
  String? get initialDate => _initialDate;
  String? get finalDate => _finalDate;
  String? get dateArrive => _dateArrive;
  num? get deliveryQty => _deliveryQty;
  num? get uomId => _uomId;
  String? get uomName => _uomName;
  num? get createdBy => _createdBy;
  String? get jetty => _jetty;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  String? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_d_inspection_stages_id'] = _tDInspectionStagesId;
    map['t_d_jo_inspection_activity_id'] = _tDJoInspectionActivityId;
    map['initial_date'] = _initialDate;
    map['final_date'] = _finalDate;
    map['date_arrive'] = _dateArrive;
    map['delivery_qty'] = _deliveryQty;
    map['uom_id'] = _uomId;
    map['created_by'] = _createdBy;
    map['jetty'] = _jetty;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
  Map<String, dynamic> toInsert() {
    final map = <String, dynamic>{};
    //map['id'] = _id;
    map['t_d_inspection_stages_id'] = _tDInspectionStagesId;
    map['t_d_jo_inspection_activity_id'] = _tDJoInspectionActivityId;
    map['initial_date'] = _initialDate;
    map['final_date'] = _finalDate;
    map['date_arrive'] = _dateArrive;
    map['delivery_qty'] = _deliveryQty;
    map['uom_id'] = _uomId;
    map['created_by'] = _createdBy;
    map['jetty'] = _jetty;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    //map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    //map['updated_at'] = _updatedAt;
    return map;
  }

}