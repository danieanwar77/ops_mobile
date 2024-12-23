/// t_h_jo_id : 7
/// m_statusinspectionstages_id : 4
/// trans_date : "2024-08-31"
/// start_activity_time : "15:00:00"
/// end_activity_time : "16:00:00"
/// activity : "Menunggu Kedatangan Kapal"
/// created_by : 0
/// remarks : "testing"

class Activity{
  Activity({
      num? id,
      String? code,
      num? tHJoId,
      num? stageId,
      String? stageCode,
      num? mStatusinspectionstagesId, 
      String? transDate, 
      String? startActivityTime, 
      String? endActivityTime, 
      String? activity, 
      num? createdBy, 
      String? remarks,
      String? createdAt,
      num? updatedBy,
      String? updatedAt,
      num? isActive,
      num? isUpload,
  }){
    _id = id;
    _code = code;
    _tHJoId = tHJoId;
    _stageId = stageId;
    _stageCode = stageCode;
    _mStatusinspectionstagesId = mStatusinspectionstagesId;
    _transDate = transDate;
    _startActivityTime = startActivityTime;
    _endActivityTime = endActivityTime;
    _activity = activity;
    _createdBy = createdBy;
    _remarks = remarks;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
    _isActive = isActive;
    _isUpload = isUpload;
}

  Activity.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _tHJoId = json['t_h_jo_id'];
    _stageId = json['inspection_stages_id'];
    _stageCode = json['stage_code'];
    _mStatusinspectionstagesId = json['m_statusinspectionstages_id'];
    _transDate = json['trans_date'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _activity = json['activity'];
    _createdBy = json['created_by'];
    _remarks = json['remarks'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
  }
  num? _id;
  String? _code;
  num? _tHJoId;
  num? _stageId;
  String? _stageCode;
  num? _mStatusinspectionstagesId;
  String? _transDate;
  String? _startActivityTime;
  String? _endActivityTime;
  String? _activity;
  num? _createdBy;
  String? _remarks;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
  num? _isActive;
  num? _isUpload;
  Activity copyWith({  num? id,
  String? code,
  num? tHJoId,
  num? stageId,
  String? stageCode,
  num? mStatusinspectionstagesId,
  String? transDate,
  String? startActivityTime,
  String? endActivityTime,
  String? activity,
  num? createdBy,
  String? remarks,
  String? createdAt,
  num? updatedBy,
  String? updatedAt,
  num? isActive,
  num? isUpload,
}) => Activity(  id: id ?? _id,
  code: code ?? _code,
  tHJoId: tHJoId ?? _tHJoId,
  stageId: stageId ?? _stageId,
  stageCode: stageCode ?? _stageCode,
  mStatusinspectionstagesId: mStatusinspectionstagesId ?? _mStatusinspectionstagesId,
  transDate: transDate ?? _transDate,
  startActivityTime: startActivityTime ?? _startActivityTime,
  endActivityTime: endActivityTime ?? _endActivityTime,
  activity: activity ?? _activity,
  createdBy: createdBy ?? _createdBy,
  remarks: remarks ?? _remarks,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
);
  num? get id => _id;
  String? get code => _code;
  num? get tHJoId => _tHJoId;
  num? get stageId => _stageId;
  String? get stageCode => _stageCode;
  num? get mStatusinspectionstagesId => _mStatusinspectionstagesId;
  String? get transDate => _transDate;
  String? get startActivityTime => _startActivityTime;
  String? get endActivityTime => _endActivityTime;
  String? get activity => _activity;
  num? get createdBy => _createdBy;
  String? get remarks => _remarks;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['t_h_jo_id'] = _tHJoId;
    map['inspection_stages_id'] = _stageId;
    map['stage_code'] = _stageCode;
    map['m_statusinspectionstages_id'] = _mStatusinspectionstagesId;
    map['trans_date'] = _transDate;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['created_by'] = _createdBy;
    map['remarks'] = _remarks;
    map['created_at'] = createdAt;
    map['updated_by'] = updatedBy;
    map['updated_at'] = updatedAt;
    map['is_active'] = isActive;
    map['is_upload'] = isUpload;
    return map;
  }

}

class ActivityLab {
  ActivityLab({
    num? tHJoId,
    num? tDJoLaboratoryId,
    num? mStatuslaboratoryprogresId,
    String? transDate,
    String? startActivityTime,
    String? endActivityTime,
    String? activity,
    num? createdBy,
    String? remarks,}){
    _tHJoId = tHJoId;
    _tDJoLaboratoryId = tDJoLaboratoryId;
    _mStatuslaboratoryprogresId = mStatuslaboratoryprogresId;
    _transDate = transDate;
    _startActivityTime = startActivityTime;
    _endActivityTime = endActivityTime;
    _activity = activity;
    _createdBy = createdBy;
    _remarks = remarks;
  }

  ActivityLab.fromJson(dynamic json) {
    _tHJoId = json['t_h_jo_id'];
    _tDJoLaboratoryId = json['t_d_jo_laboratory_id'];
    _mStatuslaboratoryprogresId = json['m_statuslaboratoryprogres_id'];
    _transDate = json['trans_date'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _activity = json['activity'];
    _createdBy = json['created_by'];
    _remarks = json['remarks'];
  }
  num? _tHJoId;
  num? _tDJoLaboratoryId;
  num? _mStatuslaboratoryprogresId;
  String? _transDate;
  String? _startActivityTime;
  String? _endActivityTime;
  String? _activity;
  num? _createdBy;
  String? _remarks;
  ActivityLab copyWith({  num? tHJoId,
    num? tDJoLaboratoryId,
    num? mStatuslaboratoryprogresId,
    String? transDate,
    String? startActivityTime,
    String? endActivityTime,
    String? activity,
    num? createdBy,
    String? remarks,
  }) => ActivityLab(  tHJoId: tHJoId ?? _tHJoId,
    tDJoLaboratoryId: tDJoLaboratoryId ?? _tDJoLaboratoryId,
    mStatuslaboratoryprogresId: mStatuslaboratoryprogresId ?? _mStatuslaboratoryprogresId,
    transDate: transDate ?? _transDate,
    startActivityTime: startActivityTime ?? _startActivityTime,
    endActivityTime: endActivityTime ?? _endActivityTime,
    activity: activity ?? _activity,
    createdBy: createdBy ?? _createdBy,
    remarks: remarks ?? _remarks,
  );
  num? get tHJoId => _tHJoId;
  num? get tDJoLaboratoryId => _tDJoLaboratoryId;
  num? get mStatuslaboratoryprogresId => _mStatuslaboratoryprogresId;
  String? get transDate => _transDate;
  String? get startActivityTime => _startActivityTime;
  String? get endActivityTime => _endActivityTime;
  String? get activity => _activity;
  num? get createdBy => _createdBy;
  String? get remarks => _remarks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['t_h_jo_id'] = _tHJoId;
    map['t_d_jo_laboratory_id'] = _tDJoLaboratoryId;
    map['m_statuslaboratoryprogres_id'] = _mStatuslaboratoryprogresId;
    map['trans_date'] = _transDate;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['created_by'] = _createdBy;
    map['remarks'] = _remarks;
    return map;
  }

}

class DataDailyPhoto64 {
  DataDailyPhoto64({
    num? id,
    num? tHJoId,
    String? pathPhoto,
    String? keterangan,
    String? createdAt,
    String? updatedAt,}){
    _id = id;
    _tHJoId = tHJoId;
    _pathPhoto = pathPhoto;
    _keterangan = keterangan;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  DataDailyPhoto64.fromJson(dynamic json) {
    _id = json['id'];
    _tHJoId = json['t_h_jo_id'];
    _pathPhoto = json['path_photo'];
    _keterangan = json['keterangan'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _tHJoId;
  String? _pathPhoto;
  String? _keterangan;
  String? _createdAt;
  String? _updatedAt;
  DataDailyPhoto64 copyWith({  num? id,
    num? tHJoId,
    String? pathPhoto,
    String? keterangan,
    String? createdAt,
    String? updatedAt,
  }) => DataDailyPhoto64(  id: id ?? _id,
    tHJoId: tHJoId ?? _tHJoId,
    pathPhoto: pathPhoto ?? _pathPhoto,
    keterangan: keterangan ?? _keterangan,
    createdAt: createdAt ?? _createdAt,
    updatedAt: updatedAt ?? _updatedAt,
  );
  num? get id => _id;
  num? get tHJoId => _tHJoId;
  String? get pathPhoto => _pathPhoto;
  String? get keterangan => _keterangan;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_h_jo_id'] = _tHJoId;
    map['path_photo'] = _pathPhoto;
    map['keterangan'] = _keterangan;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}

/// formDataArray : [{"t_h_jo_id":6,"m_statusinspectionstages_id":5,"uom_id":2,"trans_date":"2024-08-31","actual_qty":"10","created_by":0,"transhipment":[{"jetty":"Testing Alam","initial_date":"2024-09-01","final_date":"2024-09-02","delivery_qty":"3"}]}]

class Activity5 {
  Activity5({
    List<FormDataArray>? formDataArray,}){
    _formDataArray = formDataArray;
  }

  Activity5.fromJson(dynamic json) {
    if (json['formDataArray'] != null) {
      _formDataArray = [];
      json['formDataArray'].forEach((v) {
        _formDataArray?.add(FormDataArray.fromJson(v));
      });
    }
  }
  List<FormDataArray>? _formDataArray;
  Activity5 copyWith({  List<FormDataArray>? formDataArray,
  }) => Activity5(  formDataArray: formDataArray ?? _formDataArray,
  );
  List<FormDataArray>? get formDataArray => _formDataArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_formDataArray != null) {
      map['formDataArray'] = _formDataArray?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class JoActivity5 {
  JoActivity5({
    List<FormDataArray>? formDataArray,}){
    _formDataArray = formDataArray;
  }

  JoActivity5.fromJson(dynamic json) {
    if (json['formDataArray'] != null) {
      _formDataArray = [];
      json['formDataArray'].forEach((v) {
        _formDataArray?.add(FormDataArray.fromJson(v));
      });
    }
  }
  List<FormDataArray>? _formDataArray;
  JoActivity5 copyWith({  List<FormDataArray>? formDataArray,
  }) => JoActivity5(  formDataArray: formDataArray ?? _formDataArray,
  );
  List<FormDataArray>? get formDataArray => _formDataArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_formDataArray != null) {
      map['formDataArray'] = _formDataArray?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// t_h_jo_id : 6
/// m_statusinspectionstages_id : 5
/// uom_id : 2
/// trans_date : "2024-08-31"
/// actual_qty : "10"
/// created_by : 0
/// vessel : "Vessel 1"
/// barge : [{"barge":"Barge 11"},{"barge":"Barge 2"}]
/// transhipment : [{"jetty":"Testing Alam","initial_date":"2024-09-01","final_date":"2024-09-02","delivery_qty":"3"}]

class FormDataArray {
  FormDataArray({
    num? tHJoId,
    num? mStatusinspectionstagesId,
    num? uomId,
    String? transDate,
    String? actualQty,
    num? createdBy,
    String? vessel,
    List<Barge>? barge,
    List<Transhipment>? transhipment,}){
    _tHJoId = tHJoId;
    _mStatusinspectionstagesId = mStatusinspectionstagesId;
    _uomId = uomId;
    _transDate = transDate;
    _actualQty = actualQty;
    _createdBy = createdBy;
    _vessel = vessel;
    _barge = barge;
    _transhipment = transhipment;
  }

  FormDataArray.fromJson(dynamic json) {
    _tHJoId = json['t_h_jo_id'];
    _mStatusinspectionstagesId = json['m_statusinspectionstages_id'];
    _uomId = json['uom_id'];
    _transDate = json['trans_date'];
    _actualQty = json['actual_qty'];
    _createdBy = json['created_by'];
    _vessel = json['vessel'];
    if (json['barge'] != null) {
      _barge = [];
      json['barge'].forEach((v) {
        _barge?.add(Barge.fromJson(v));
      });
    }
    if (json['transhipment'] != null) {
      _transhipment = [];
      json['transhipment'].forEach((v) {
        _transhipment?.add(Transhipment.fromJson(v));
      });
    }
  }
  num? _tHJoId;
  num? _mStatusinspectionstagesId;
  num? _uomId;
  String? _transDate;
  String? _actualQty;
  num? _createdBy;
  String? _vessel;
  List<Barge>? _barge;
  List<Transhipment>? _transhipment;
  FormDataArray copyWith({  num? tHJoId,
    num? mStatusinspectionstagesId,
    num? uomId,
    String? transDate,
    String? actualQty,
    num? createdBy,
    String? vessel,
    List<Barge>? barge,
    List<Transhipment>? transhipment,
  }) => FormDataArray(  tHJoId: tHJoId ?? _tHJoId,
    mStatusinspectionstagesId: mStatusinspectionstagesId ?? _mStatusinspectionstagesId,
    uomId: uomId ?? _uomId,
    transDate: transDate ?? _transDate,
    actualQty: actualQty ?? _actualQty,
    createdBy: createdBy ?? _createdBy,
    vessel: vessel ?? _vessel,
    barge: barge ?? _barge,
    transhipment: transhipment ?? _transhipment,
  );
  num? get tHJoId => _tHJoId;
  num? get mStatusinspectionstagesId => _mStatusinspectionstagesId;
  num? get uomId => _uomId;
  String? get transDate => _transDate;
  String? get actualQty => _actualQty;
  num? get createdBy => _createdBy;
  String? get vessel => _vessel;
  List<Barge>? get barge => _barge;
  List<Transhipment>? get transhipment => _transhipment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['t_h_jo_id'] = _tHJoId;
    map['m_statusinspectionstages_id'] = _mStatusinspectionstagesId;
    map['uom_id'] = _uomId;
    map['trans_date'] = _transDate;
    map['actual_qty'] = _actualQty;
    map['created_by'] = _createdBy;
    map['vessel'] = _vessel;
    if (_barge != null) {
      map['barge'] = _barge?.map((v) => v.toJson()).toList();
    }
    if (_transhipment != null) {
      map['transhipment'] = _transhipment?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// jetty : "Testing Alam"
/// initial_date : "2024-09-01"
/// final_date : "2024-09-02"
/// delivery_qty : "3"

class Transhipment {
  Transhipment({
    String? jetty,
    String? initialDate,
    String? finalDate,
    String? deliveryQty,}){
    _jetty = jetty;
    _initialDate = initialDate;
    _finalDate = finalDate;
    _deliveryQty = deliveryQty;
  }

  Transhipment.fromJson(dynamic json) {
    _jetty = json['jetty'];
    _initialDate = json['initial_date'];
    _finalDate = json['final_date'];
    _deliveryQty = json['delivery_qty'];
  }
  String? _jetty;
  String? _initialDate;
  String? _finalDate;
  String? _deliveryQty;
  Transhipment copyWith({  String? jetty,
    String? initialDate,
    String? finalDate,
    String? deliveryQty,
  }) => Transhipment(  jetty: jetty ?? _jetty,
    initialDate: initialDate ?? _initialDate,
    finalDate: finalDate ?? _finalDate,
    deliveryQty: deliveryQty ?? _deliveryQty,
  );
  String? get jetty => _jetty;
  String? get initialDate => _initialDate;
  String? get finalDate => _finalDate;
  String? get deliveryQty => _deliveryQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['jetty'] = _jetty;
    map['initial_date'] = _initialDate;
    map['final_date'] = _finalDate;
    map['delivery_qty'] = _deliveryQty;
    return map;
  }

}

/// barge : "Barge 11"

class Barge {
  Barge({
    String? barge,}){
    _barge = barge;
  }

  Barge.fromJson(dynamic json) {
    _barge = json['barge'];
  }
  String? _barge;
  Barge copyWith({  String? barge,
  }) => Barge(  barge: barge ?? _barge,
  );
  String? get barge => _barge;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['barge'] = _barge;
    return map;
  }

}

/// t_h_jo_id : 6
/// m_statusinspectionstages_id : 6
/// uom_id : 2
/// trans_date : "2024-08-31"
/// start_activity_time : "15:00:00"
/// end_activity_time : "16:00:00"
/// created_by : 0
/// activity : "testingg alam stage 6"
/// remarks : "testing alam Stage 6"
/// images : ["66fb93f0995ee.jpg"]

class FormDataArray6 {
  FormDataArray6({
    num? tHJoId,
    num? mStatusinspectionstagesId,
    num? uomId,
    String? transDate,
    String? startActivityTime,
    String? endActivityTime,
    num? createdBy,
    String? activity,
    String? remarks,
    List<String>? images,}){
    _tHJoId = tHJoId;
    _mStatusinspectionstagesId = mStatusinspectionstagesId;
    _uomId = uomId;
    _transDate = transDate;
    _startActivityTime = startActivityTime;
    _endActivityTime = endActivityTime;
    _createdBy = createdBy;
    _activity = activity;
    _remarks = remarks;
    _images = images;
  }

  FormDataArray6.fromJson(dynamic json) {
    _tHJoId = json['t_h_jo_id'];
    _mStatusinspectionstagesId = json['m_statusinspectionstages_id'];
    _uomId = json['uom_id'];
    _transDate = json['trans_date'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _createdBy = json['created_by'];
    _activity = json['activity'];
    _remarks = json['remarks'];
    _images = json['images'] != null ? json['images'].cast<String>() : [];
  }
  num? _tHJoId;
  num? _mStatusinspectionstagesId;
  num? _uomId;
  String? _transDate;
  String? _startActivityTime;
  String? _endActivityTime;
  num? _createdBy;
  String? _activity;
  String? _remarks;
  List<String>? _images;
  FormDataArray6 copyWith({  num? tHJoId,
    num? mStatusinspectionstagesId,
    num? uomId,
    String? transDate,
    String? startActivityTime,
    String? endActivityTime,
    num? createdBy,
    String? activity,
    String? remarks,
    List<String>? images,
  }) => FormDataArray6(  tHJoId: tHJoId ?? _tHJoId,
    mStatusinspectionstagesId: mStatusinspectionstagesId ?? _mStatusinspectionstagesId,
    uomId: uomId ?? _uomId,
    transDate: transDate ?? _transDate,
    startActivityTime: startActivityTime ?? _startActivityTime,
    endActivityTime: endActivityTime ?? _endActivityTime,
    createdBy: createdBy ?? _createdBy,
    activity: activity ?? _activity,
    remarks: remarks ?? _remarks,
    images: images ?? _images,
  );
  num? get tHJoId => _tHJoId;
  num? get mStatusinspectionstagesId => _mStatusinspectionstagesId;
  num? get uomId => _uomId;
  String? get transDate => _transDate;
  String? get startActivityTime => _startActivityTime;
  String? get endActivityTime => _endActivityTime;
  num? get createdBy => _createdBy;
  String? get activity => _activity;
  String? get remarks => _remarks;
  List<String>? get images => _images;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['t_h_jo_id'] = _tHJoId;
    map['m_statusinspectionstages_id'] = _mStatusinspectionstagesId;
    map['uom_id'] = _uomId;
    map['trans_date'] = _transDate;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['created_by'] = _createdBy;
    map['activity'] = _activity;
    map['remarks'] = _remarks;
    map['images'] = _images;
    return map;
  }

}

class ActivityAct5Lab {
  ActivityAct5Lab({
    num? tHJoId,
    num? tDJoLaboratoryId,
    num? mStatuslaboratoryprogresId,
    String? transDate,
    String? startActivityTime,
    String? endActivityTime,
    int? totalSampleReceived,
    int? totalSampleAnalyzed,
    int? totalSamplePreparation,
    num? createdBy,}){
    _tHJoId = tHJoId;
    _tDJoLaboratoryId = tDJoLaboratoryId;
    _mStatuslaboratoryprogresId = mStatuslaboratoryprogresId;
    _transDate = transDate;
    _startActivityTime = startActivityTime;
    _endActivityTime = endActivityTime;
    _totalSampleReceived = totalSampleReceived;
    _totalSampleAnalyzed = totalSampleAnalyzed;
    _totalSamplePreparation = totalSamplePreparation;
    _createdBy = createdBy;
  }

  ActivityAct5Lab.fromJson(dynamic json) {
    _tHJoId = json['t_h_jo_id'];
    _tDJoLaboratoryId = json['t_d_jo_laboratory_id'];
    _mStatuslaboratoryprogresId = json['m_statuslaboratoryprogres_id'];
    _transDate = json['trans_date'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _totalSampleReceived = json['total_sample_received'];
    _totalSampleAnalyzed = json['total_sample_analyzed'];
    _totalSamplePreparation = json['total_sample_preparation'];
    _createdBy = json['created_by'];
  }
  num? _tHJoId;
  num? _tDJoLaboratoryId;
  num? _mStatuslaboratoryprogresId;
  String? _transDate;
  String? _startActivityTime;
  String? _endActivityTime;
  int? _totalSampleReceived;
  int? _totalSampleAnalyzed;
  int? _totalSamplePreparation;
  num? _createdBy;
  ActivityAct5Lab copyWith({  num? tHJoId,
    num? tDJoLaboratoryId,
    num? mStatuslaboratoryprogresId,
    String? transDate,
    String? startActivityTime,
    String? endActivityTime,
    int? totalSampleReceived,
    int? totalSampleAnalyzed,
    int? totalSamplePreparation,
    num? createdBy,
  }) => ActivityAct5Lab(  tHJoId: tHJoId ?? _tHJoId,
    tDJoLaboratoryId: tDJoLaboratoryId ?? _tDJoLaboratoryId,
    mStatuslaboratoryprogresId: mStatuslaboratoryprogresId ?? _mStatuslaboratoryprogresId,
    transDate: transDate ?? _transDate,
    startActivityTime: startActivityTime ?? _startActivityTime,
    endActivityTime: endActivityTime ?? _endActivityTime,
    totalSampleReceived: totalSampleReceived ?? _totalSampleReceived,
    totalSampleAnalyzed: totalSampleAnalyzed ?? _totalSampleAnalyzed,
    totalSamplePreparation: totalSamplePreparation ?? _totalSamplePreparation,
    createdBy: createdBy ?? _createdBy,
  );
  num? get tHJoId => _tHJoId;
  num? get tDJoLaboratoryId => _tDJoLaboratoryId;
  num? get mStatuslaboratoryprogresId => _mStatuslaboratoryprogresId;
  String? get transDate => _transDate;
  String? get startActivityTime => _startActivityTime;
  String? get endActivityTime => _endActivityTime;
  int? get totalSampleReceived => _totalSampleReceived;
  int? get totalSampleAnalyzed => _totalSampleAnalyzed;
  int? get totalSamplePreparation => _totalSamplePreparation;
  num? get createdBy => _createdBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['t_h_jo_id'] = _tHJoId;
    map['t_d_jo_laboratory_id'] = _tDJoLaboratoryId;
    map['m_statuslaboratoryprogres_id'] = _mStatuslaboratoryprogresId;
    map['trans_date'] = _transDate;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['total_sample_received'] = _totalSampleReceived;
    map['total_sample_analyzed'] = _totalSampleAnalyzed;
    map['total_sample_preparation'] = _totalSamplePreparation;
    map['created_by'] = _createdBy;
    return map;
  }

}

class FormDataArrayLab6 {
  FormDataArrayLab6({
    num? tHJoId,
    num? tDJoLaboratoryId,
    num? mStatuslaboratoryprogresId,
    String? transDate,
    String? startActivityTime,
    String? endActivityTime,
    String? activity,
    num? createdBy,
    String? remarks,
    String? code,}){
    _tHJoId = tHJoId;
    _tDJoLaboratoryId = tDJoLaboratoryId;
    _mStatuslaboratoryprogresId = mStatuslaboratoryprogresId;
    _transDate = transDate;
    _startActivityTime = startActivityTime;
    _endActivityTime = endActivityTime;
    _activity = activity;
    _createdBy = createdBy;
    _remarks = remarks;
    _code = code;
  }

  FormDataArrayLab6.fromJson(dynamic json) {
    _tHJoId = json['t_h_jo_id'];
    _tDJoLaboratoryId = json['t_d_jo_laboratory_id'];
    _mStatuslaboratoryprogresId = json['m_statuslaboratoryprogres_id'];
    _transDate = json['trans_date'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _activity = json['activity'];
    _createdBy = json['created_by'];
    _remarks = json['remarks'];
    _code = json['code'];
  }
  num? _tHJoId;
  num? _tDJoLaboratoryId;
  num? _mStatuslaboratoryprogresId;
  String? _transDate;
  String? _startActivityTime;
  String? _endActivityTime;
  String? _activity;
  num? _createdBy;
  String? _remarks;
  String? _code;
  FormDataArrayLab6 copyWith({  num? tHJoId,
    num? tDJoLaboratoryId,
    num? mStatuslaboratoryprogresId,
    String? transDate,
    String? startActivityTime,
    String? endActivityTime,
    String? activity,
    num? createdBy,
    String? remarks,
    String? code,
  }) => FormDataArrayLab6(  tHJoId: tHJoId ?? _tHJoId,
    tDJoLaboratoryId: tDJoLaboratoryId ?? _tDJoLaboratoryId,
    mStatuslaboratoryprogresId: mStatuslaboratoryprogresId ?? _mStatuslaboratoryprogresId,
    transDate: transDate ?? _transDate,
    startActivityTime: startActivityTime ?? _startActivityTime,
    endActivityTime: endActivityTime ?? _endActivityTime,
    activity: activity ?? _activity,
    createdBy: createdBy ?? _createdBy,
    remarks: remarks ?? _remarks,
    code: code ?? _code,
  );
  num? get tHJoId => _tHJoId;
  num? get tDJoLaboratoryId => _tDJoLaboratoryId;
  num? get mStatuslaboratoryprogresId => _mStatuslaboratoryprogresId;
  String? get transDate => _transDate;
  String? get startActivityTime => _startActivityTime;
  String? get endActivityTime => _endActivityTime;
  String? get activity => _activity;
  num? get createdBy => _createdBy;
  String? get remarks => _remarks;
  String? get code => _code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['t_h_jo_id'] = _tHJoId;
    map['t_d_jo_laboratory_id'] = _tDJoLaboratoryId;
    map['m_statuslaboratoryprogres_id'] = _mStatuslaboratoryprogresId;
    map['trans_date'] = _transDate;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['created_by'] = _createdBy;
    map['remarks'] = _remarks;
    map['code'] = _code;
    return map;
  }

}