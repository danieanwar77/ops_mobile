/// inspection_activity : [{"t_d_jo_inspection_activity_stages":{"code":"","t_h_jo_id":0,"m_statusinspectionstages_id":0,"trans_date":"","remarks":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""},"t_d_jo_inspection_activity":[{"code":"","t_d_jo_inspection_activity_stages_id":0,"t_h_jo_id":0,"start_activity_time":"","end_activity_time":"","activity":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}],"activity_work_complete":{"header":{"code":"","actual_qty":"","uom_id":0,"vessel":{"t_h_jo_id":0,"t_d_jo_inspection_activity_stages_id":0,"vessel":"","code":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}},"barges":[{"t_h_jo_id":0,"t_d_jo_inspection_activity_stages_id":0,"barge":"","code":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}],"transhipment":[{"t_d_jo_inspection_stages_id":0,"t_d_jo_inspection_activity_id":0,"initial_date":"","final_date":"","jetty":"","delivery_qty":0,"is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}]}}]

class JoInspectionSendManualModel {
  JoInspectionSendManualModel({
      List<InspectionActivity>? inspectionActivity,}){
    _inspectionActivity = inspectionActivity ?? [];
}

  JoInspectionSendManualModel.fromJson(dynamic json) {
    if (json['inspection_activity'] != null) {
      _inspectionActivity = [];
      json['inspection_activity'].forEach((v) {
        _inspectionActivity?.add(InspectionActivity.fromJson(v));
      });
    }
  }
  List<InspectionActivity>? _inspectionActivity;
JoInspectionSendManualModel copyWith({  List<InspectionActivity>? inspectionActivity,
}) => JoInspectionSendManualModel(  inspectionActivity: inspectionActivity ?? _inspectionActivity,
);
  List<InspectionActivity> get inspectionActivity => _inspectionActivity ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_inspectionActivity != null) {
      map['inspection_activity'] = _inspectionActivity?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// t_d_jo_inspection_activity_stages : {"code":"","t_h_jo_id":0,"m_statusinspectionstages_id":0,"trans_date":"","remarks":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}
/// t_d_jo_inspection_activity : [{"code":"","t_d_jo_inspection_activity_stages_id":0,"t_h_jo_id":0,"start_activity_time":"","end_activity_time":"","activity":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}]
/// activity_work_complete : {"header":{"code":"","actual_qty":"","uom_id":0,"vessel":{"t_h_jo_id":0,"t_d_jo_inspection_activity_stages_id":0,"vessel":"","code":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}},"barges":[{"t_h_jo_id":0,"t_d_jo_inspection_activity_stages_id":0,"barge":"","code":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}],"transhipment":[{"t_d_jo_inspection_stages_id":0,"t_d_jo_inspection_activity_id":0,"initial_date":"","final_date":"","jetty":"","delivery_qty":0,"is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}]}

class InspectionActivity {
  InspectionActivity({
      TdJoInspectionActivityStagesSm? tDJoInspectionActivityStages,
      List<TdJoInspectionActivitySm>? tDJoInspectionActivity,
      ActivityWorkComplete? activityWorkComplete,}){
    _tDJoInspectionActivityStages = tDJoInspectionActivityStages;
    _tDJoInspectionActivity = tDJoInspectionActivity ?? [];
    _activityWorkComplete = activityWorkComplete;
}

  InspectionActivity.fromJson(dynamic json) {
    _tDJoInspectionActivityStages = json['t_d_jo_inspection_activity_stages'] != null ? TdJoInspectionActivityStagesSm.fromJson(json['t_d_jo_inspection_activity_stages']) : null;
    if (json['t_d_jo_inspection_activity'] != null) {
      _tDJoInspectionActivity = [];
      json['t_d_jo_inspection_activity'].forEach((v) {
        _tDJoInspectionActivity?.add(TdJoInspectionActivitySm.fromJson(v));
      });
    }
    _activityWorkComplete = json['activity_work_complete'] != null ? ActivityWorkComplete.fromJson(json['activity_work_complete']) : null;
  }
  TdJoInspectionActivityStagesSm? _tDJoInspectionActivityStages;
  List<TdJoInspectionActivitySm>? _tDJoInspectionActivity;
  ActivityWorkComplete? _activityWorkComplete;
InspectionActivity copyWith({  TdJoInspectionActivityStagesSm? tDJoInspectionActivityStages,
  List<TdJoInspectionActivitySm>? tDJoInspectionActivity,
  ActivityWorkComplete? activityWorkComplete,
}) => InspectionActivity(  tDJoInspectionActivityStages: tDJoInspectionActivityStages ?? _tDJoInspectionActivityStages,
  tDJoInspectionActivity: tDJoInspectionActivity ?? _tDJoInspectionActivity,
  activityWorkComplete: activityWorkComplete ?? _activityWorkComplete,
);
  TdJoInspectionActivityStagesSm? get tDJoInspectionActivityStages => _tDJoInspectionActivityStages;
  List<TdJoInspectionActivitySm>? get tDJoInspectionActivity => _tDJoInspectionActivity;
  ActivityWorkComplete? get activityWorkComplete => _activityWorkComplete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_tDJoInspectionActivityStages != null) {
      map['t_d_jo_inspection_activity_stages'] = _tDJoInspectionActivityStages?.toJson();
    }
    if (_tDJoInspectionActivity != null) {
      map['t_d_jo_inspection_activity'] = _tDJoInspectionActivity?.map((v) => v.toJson()).toList();
    }
    if (_activityWorkComplete != null) {
      map['activity_work_complete'] = _activityWorkComplete?.toJson();
    }
    return map;
  }

}

/// header : {"code":"","actual_qty":"","uom_id":0,"vessel":{"t_h_jo_id":0,"t_d_jo_inspection_activity_stages_id":0,"vessel":"","code":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}}
/// barges : [{"t_h_jo_id":0,"t_d_jo_inspection_activity_stages_id":0,"barge":"","code":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}]
/// transhipment : [{"t_d_jo_inspection_stages_id":0,"t_d_jo_inspection_activity_id":0,"initial_date":"","final_date":"","jetty":"","delivery_qty":0,"is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}]

class ActivityWorkComplete {
  ActivityWorkComplete({
      Header? header,
      List<Barges>? barges,
      List<Transhipment>? transhipment,}){
    _header = header;
    _barges = barges;
    _transhipment = transhipment;
}

  ActivityWorkComplete.fromJson(dynamic json) {
    _header = json['header'] != null ? Header.fromJson(json['header']) : null;
    if (json['barges'] != null) {
      _barges = [];
      json['barges'].forEach((v) {
        _barges?.add(Barges.fromJson(v));
      });
    }
    if (json['transhipment'] != null) {
      _transhipment = [];
      json['transhipment'].forEach((v) {
        _transhipment?.add(Transhipment.fromJson(v));
      });
    }
  }
  Header? _header;
  List<Barges>? _barges;
  List<Transhipment>? _transhipment;
ActivityWorkComplete copyWith({  Header? header,
  List<Barges>? barges,
  List<Transhipment>? transhipment,
}) => ActivityWorkComplete(  header: header ?? _header,
  barges: barges ?? _barges,
  transhipment: transhipment ?? _transhipment,
);
  Header? get header => _header;
  List<Barges>? get barges => _barges;
  List<Transhipment>? get transhipment => _transhipment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_header != null) {
      map['header'] = _header?.toJson();
    }
    if (_barges != null) {
      map['barges'] = _barges?.map((v) => v.toJson()).toList();
    }
    if (_transhipment != null) {
      map['transhipment'] = _transhipment?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// t_d_jo_inspection_stages_id : 0
/// t_d_jo_inspection_activity_id : 0
/// initial_date : ""
/// final_date : ""
/// jetty : ""
/// delivery_qty : 0
/// is_active : 0
/// is_upload : 0
/// created_by : 0
/// created_at : ""
/// updated_by : 0
/// updated_at : ""

class Transhipment {
  Transhipment({
      num? tDJoInspectionStagesId,
      num? tDJoInspectionActivityId,
      String? initialDate,
      String? finalDate,
      String? jetty,
      num? deliveryQty,
      num? isActive,
      num? isUpload,
      num? createdBy,
      String? createdAt,
      num? updatedBy,
      String? updatedAt,}){
    _tDJoInspectionStagesId = tDJoInspectionStagesId;
    _tDJoInspectionActivityId = tDJoInspectionActivityId;
    _initialDate = initialDate;
    _finalDate = finalDate;
    _jetty = jetty;
    _deliveryQty = deliveryQty;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
}

  Transhipment.fromJson(dynamic json) {
    _tDJoInspectionStagesId = json['t_d_jo_inspection_stages_id'];
    _tDJoInspectionActivityId = json['t_d_jo_inspection_activity_id'];
    _initialDate = json['initial_date'];
    _finalDate = json['final_date'];
    _jetty = json['jetty'];
    _deliveryQty = json['delivery_qty'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
  }
  num? _tDJoInspectionStagesId;
  num? _tDJoInspectionActivityId;
  String? _initialDate;
  String? _finalDate;
  String? _jetty;
  num? _deliveryQty;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
Transhipment copyWith({  num? tDJoInspectionStagesId,
  num? tDJoInspectionActivityId,
  String? initialDate,
  String? finalDate,
  String? jetty,
  num? deliveryQty,
  num? isActive,
  num? isUpload,
  num? createdBy,
  String? createdAt,
  num? updatedBy,
  String? updatedAt,
}) => Transhipment(  tDJoInspectionStagesId: tDJoInspectionStagesId ?? _tDJoInspectionStagesId,
  tDJoInspectionActivityId: tDJoInspectionActivityId ?? _tDJoInspectionActivityId,
  initialDate: initialDate ?? _initialDate,
  finalDate: finalDate ?? _finalDate,
  jetty: jetty ?? _jetty,
  deliveryQty: deliveryQty ?? _deliveryQty,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get tDJoInspectionStagesId => _tDJoInspectionStagesId;
  num? get tDJoInspectionActivityId => _tDJoInspectionActivityId;
  String? get initialDate => _initialDate;
  String? get finalDate => _finalDate;
  String? get jetty => _jetty;
  num? get deliveryQty => _deliveryQty;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['t_d_jo_inspection_stages_id'] = _tDJoInspectionStagesId;
    map['t_d_jo_inspection_activity_id'] = _tDJoInspectionActivityId;
    map['initial_date'] = _initialDate;
    map['final_date'] = _finalDate;
    map['jetty'] = _jetty;
    map['delivery_qty'] = _deliveryQty;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    return map;
  }

}

/// t_h_jo_id : 0
/// t_d_jo_inspection_activity_stages_id : 0
/// barge : ""
/// code : ""
/// is_active : 0
/// is_upload : 0
/// created_by : 0
/// created_at : ""
/// updated_by : 0
/// updated_at : ""

class Barges {
  Barges({
      num? tHJoId,
      num? tDJoInspectionActivityStagesId,
      String? barge,
      String? code,
      num? isActive,
      num? isUpload,
      num? createdBy,
      String? createdAt,
      num? updatedBy,
      String? updatedAt,}){
    _tHJoId = tHJoId;
    _tDJoInspectionActivityStagesId = tDJoInspectionActivityStagesId;
    _barge = barge;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
}

  Barges.fromJson(dynamic json) {
    _tHJoId = json['t_h_jo_id'];
    _tDJoInspectionActivityStagesId = json['t_d_jo_inspection_activity_stages_id'];
    _barge = json['barge'];
    _code = json['code'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
  }
  num? _tHJoId;
  num? _tDJoInspectionActivityStagesId;
  String? _barge;
  String? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
Barges copyWith({  num? tHJoId,
  num? tDJoInspectionActivityStagesId,
  String? barge,
  String? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  String? createdAt,
  num? updatedBy,
  String? updatedAt,
}) => Barges(  tHJoId: tHJoId ?? _tHJoId,
  tDJoInspectionActivityStagesId: tDJoInspectionActivityStagesId ?? _tDJoInspectionActivityStagesId,
  barge: barge ?? _barge,
  code: code ?? _code,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get tHJoId => _tHJoId;
  num? get tDJoInspectionActivityStagesId => _tDJoInspectionActivityStagesId;
  String? get barge => _barge;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['t_h_jo_id'] = _tHJoId;
    map['t_d_jo_inspection_activity_stages_id'] = _tDJoInspectionActivityStagesId;
    map['barge'] = _barge;
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

/// code : ""
/// actual_qty : ""
/// uom_id : 0
/// vessel : {"t_h_jo_id":0,"t_d_jo_inspection_activity_stages_id":0,"vessel":"","code":"","is_active":0,"is_upload":0,"created_by":0,"created_at":"","updated_by":0,"updated_at":""}

class Header {
  Header({
      String? code,
      String? actualQty,
      num? uomId,
      Vessel? vessel,}){
    _code = code;
    _actualQty = actualQty;
    _uomId = uomId;
    _vessel = vessel;
}

  Header.fromJson(dynamic json) {
    _code = json['code'];
    _actualQty = json['actual_qty'];
    _uomId = json['uom_id'];
    _vessel = json['vessel'] != null ? Vessel.fromJson(json['vessel']) : null;
  }
  String? _code;
  String? _actualQty;
  num? _uomId;
  Vessel? _vessel;
Header copyWith({  String? code,
  String? actualQty,
  num? uomId,
  Vessel? vessel,
}) => Header(  code: code ?? _code,
  actualQty: actualQty ?? _actualQty,
  uomId: uomId ?? _uomId,
  vessel: vessel ?? _vessel,
);
  String? get code => _code;
  String? get actualQty => _actualQty;
  num? get uomId => _uomId;
  Vessel? get vessel => _vessel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['actual_qty'] = _actualQty;
    map['uom_id'] = _uomId;
    if (_vessel != null) {
      map['vessel'] = _vessel?.toJson();
    }
    return map;
  }

}

/// t_h_jo_id : 0
/// t_d_jo_inspection_activity_stages_id : 0
/// vessel : ""
/// code : ""
/// is_active : 0
/// is_upload : 0
/// created_by : 0
/// created_at : ""
/// updated_by : 0
/// updated_at : ""

class Vessel {
  Vessel({
      num? tHJoId,
      num? tDJoInspectionActivityStagesId,
      String? vessel,
      String? code,
      num? isActive,
      num? isUpload,
      num? createdBy,
      String? createdAt,
      num? updatedBy,
      String? updatedAt,}){
    _tHJoId = tHJoId;
    _tDJoInspectionActivityStagesId = tDJoInspectionActivityStagesId;
    _vessel = vessel;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
}

  Vessel.fromJson(dynamic json) {
    _tHJoId = json['t_h_jo_id'];
    _tDJoInspectionActivityStagesId = json['t_d_jo_inspection_activity_stages_id'];
    _vessel = json['vessel'];
    _code = json['code'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
  }
  num? _tHJoId;
  num? _tDJoInspectionActivityStagesId;
  String? _vessel;
  String? _code;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
Vessel copyWith({  num? tHJoId,
  num? tDJoInspectionActivityStagesId,
  String? vessel,
  String? code,
  num? isActive,
  num? isUpload,
  num? createdBy,
  String? createdAt,
  num? updatedBy,
  String? updatedAt,
}) => Vessel(  tHJoId: tHJoId ?? _tHJoId,
  tDJoInspectionActivityStagesId: tDJoInspectionActivityStagesId ?? _tDJoInspectionActivityStagesId,
  vessel: vessel ?? _vessel,
  code: code ?? _code,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get tHJoId => _tHJoId;
  num? get tDJoInspectionActivityStagesId => _tDJoInspectionActivityStagesId;
  String? get vessel => _vessel;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  num? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['t_h_jo_id'] = _tHJoId;
    map['t_d_jo_inspection_activity_stages_id'] = _tDJoInspectionActivityStagesId;
    map['vessel'] = _vessel;
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

/// code : ""
/// t_d_jo_inspection_activity_stages_id : 0
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

class TdJoInspectionActivitySm {
  TdJoInspectionActivitySm({
      String? code,
      num? tDJoInspectionActivityStagesId,
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
    _code = code;
    _tDJoInspectionActivityStagesId = tDJoInspectionActivityStagesId;
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

  TdJoInspectionActivitySm.fromJson(dynamic json) {
    _code = json['code'];
    _tDJoInspectionActivityStagesId = json['t_d_jo_inspection_activity_stages_id'];
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
  String? _code;
  num? _tDJoInspectionActivityStagesId;
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
  TdJoInspectionActivitySm copyWith({  String? code,
  num? tDJoInspectionActivityStagesId,
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
}) => TdJoInspectionActivitySm(  code: code ?? _code,
  tDJoInspectionActivityStagesId: tDJoInspectionActivityStagesId ?? _tDJoInspectionActivityStagesId,
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
  String? get code => _code;
  num? get tDJoInspectionActivityStagesId => _tDJoInspectionActivityStagesId;
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
    map['code'] = _code;
    map['t_d_jo_inspection_activity_stages_id'] = _tDJoInspectionActivityStagesId;
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

/// code : ""
/// t_h_jo_id : 0
/// m_statusinspectionstages_id : 0
/// trans_date : ""
/// remarks : ""
/// is_active : 0
/// is_upload : 0
/// created_by : 0
/// created_at : ""
/// updated_by : 0
/// updated_at : ""

class TdJoInspectionActivityStagesSm {
  TdJoInspectionActivityStagesSm({
      String? code,
      num? tHJoId,
      num? mStatusinspectionstagesId,
      String? transDate,
      String? remarks,
      num? isActive,
      num? isUpload,
      num? createdBy,
      String? createdAt,
      num? updatedBy,
      String? updatedAt,}){
    _code = code;
    _tHJoId = tHJoId;
    _mStatusinspectionstagesId = mStatusinspectionstagesId;
    _transDate = transDate;
    _remarks = remarks;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
}

  TdJoInspectionActivityStagesSm.fromJson(dynamic json) {
    _code = json['code'];
    _tHJoId = json['t_h_jo_id'];
    _mStatusinspectionstagesId = json['m_statusinspectionstages_id'];
    _transDate = json['trans_date'];
    _remarks = json['remarks'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
  }
  String? _code;
  num? _tHJoId;
  num? _mStatusinspectionstagesId;
  String? _transDate;
  String? _remarks;
  num? _isActive;
  num? _isUpload;
  num? _createdBy;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
  TdJoInspectionActivityStagesSm copyWith({  String? code,
  num? tHJoId,
  num? mStatusinspectionstagesId,
  String? transDate,
  String? remarks,
  num? isActive,
  num? isUpload,
  num? createdBy,
  String? createdAt,
  num? updatedBy,
  String? updatedAt,
}) => TdJoInspectionActivityStagesSm(  code: code ?? _code,
  tHJoId: tHJoId ?? _tHJoId,
  mStatusinspectionstagesId: mStatusinspectionstagesId ?? _mStatusinspectionstagesId,
  transDate: transDate ?? _transDate,
  remarks: remarks ?? _remarks,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get code => _code;
  num? get tHJoId => _tHJoId;
  num? get mStatusinspectionstagesId => _mStatusinspectionstagesId;
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
    map['code'] = _code;
    map['t_h_jo_id'] = _tHJoId;
    map['m_statusinspectionstages_id'] = _mStatusinspectionstagesId;
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