/// id : 1
/// t_so_id : 1
/// type_jo : 3
/// t_so_date : "2024-05-14 00:00:00.0"
/// jo_receive_date : "2024-05-09 00:00:00.0"
/// code : "JO1"
/// flag_lock_jo : 0
/// etta_vessel : "2024-05-02"
/// start_date_of_attendance : "2024-05-03"
/// end_date_of_attendance : "2024-05-14"
/// date_assigment : "2024-05-03"
/// lokasi_kerja : 3
/// pic_inspector : 1624
/// pic_laboratory : 1017
/// inspection_completed_date : null
/// laboratory_completed_date : null
/// inspection_finished_date : null
/// laboratory_finished_date : null
/// canceled_date : null
/// reason_cancel : null
/// flag_doc_inspection : null
/// flag_doc_lab : null
/// m_kindofservice_id : 15
/// m_statusjo_id : 3
/// created_by : 1
/// updated_by : null
/// created_at : "2024-05-15 12:44:05.0"
/// updated_at : null

class THJo {
  THJo({
      num? id, 
      num? tSoId, 
      num? typeJo, 
      String? tSoDate,
      String? joReceiveDate,
      String? code,
      num? flagLockJo, 
      String? ettaVessel,
      String? startDateOfAttendance,
      String? endDateOfAttendance,
      String? dateAssigment,
      num? lokasiKerja, 
      String? picInspector,
      num? picLaboratory, 
      dynamic inspectionCompletedDate, 
      dynamic laboratoryCompletedDate, 
      dynamic inspectionFinishedDate, 
      dynamic laboratoryFinishedDate, 
      dynamic canceledDate, 
      dynamic reasonCancel, 
      dynamic flagDocInspection, 
      dynamic flagDocLab, 
      num? mKindofserviceId, 
      num? mStatusjoId, 
      num? createdBy, 
      dynamic updatedBy, 
      String? createdAt,
      dynamic updatedAt,}){
    _id = id;
    _tSoId = tSoId;
    _typeJo = typeJo;
    _tSoDate = tSoDate;
    _joReceiveDate = joReceiveDate;
    _code = code;
    _flagLockJo = flagLockJo;
    _ettaVessel = ettaVessel;
    _startDateOfAttendance = startDateOfAttendance;
    _endDateOfAttendance = endDateOfAttendance;
    _dateAssigment = dateAssigment;
    _lokasiKerja = lokasiKerja;
    _picInspector = picInspector;
    _picLaboratory = picLaboratory;
    _inspectionCompletedDate = inspectionCompletedDate;
    _laboratoryCompletedDate = laboratoryCompletedDate;
    _inspectionFinishedDate = inspectionFinishedDate;
    _laboratoryFinishedDate = laboratoryFinishedDate;
    _canceledDate = canceledDate;
    _reasonCancel = reasonCancel;
    _flagDocInspection = flagDocInspection;
    _flagDocLab = flagDocLab;
    _mKindofserviceId = mKindofserviceId;
    _mStatusjoId = mStatusjoId;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  THJo.fromJson(dynamic json) {
    _id = json['id'];
    _tSoId = json['t_so_id'];
    _typeJo = json['type_jo'];
    _tSoDate = json['t_so_date'];
    _joReceiveDate = json['jo_receive_date'];
    _code = json['code'];
    _flagLockJo = json['flag_lock_jo'];
    _ettaVessel = json['etta_vessel'];
    _startDateOfAttendance = json['start_date_of_attendance'];
    _endDateOfAttendance = json['end_date_of_attendance'];
    _dateAssigment = json['date_assigment'];
    _lokasiKerja = json['lokasi_kerja'];
    _picInspector = json['pic_inspector'].toString();
    _picLaboratory = json['pic_laboratory'];
    _inspectionCompletedDate = json['inspection_completed_date'];
    _laboratoryCompletedDate = json['laboratory_completed_date'];
    _inspectionFinishedDate = json['inspection_finished_date'];
    _laboratoryFinishedDate = json['laboratory_finished_date'];
    _canceledDate = json['canceled_date'];
    _reasonCancel = json['reason_cancel'];
    _flagDocInspection = json['flag_doc_inspection'];
    _flagDocLab = json['flag_doc_lab'];
    _mKindofserviceId = json['m_kindofservice_id'];
    _mStatusjoId = json['m_statusjo_id'];
    _createdBy = json['created_by'];
    _updatedBy = json['updated_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _tSoId;
  num? _typeJo;
  String? _tSoDate;
  String? _joReceiveDate;
  String? _code;
  num? _flagLockJo;
  String? _ettaVessel;
  String? _startDateOfAttendance;
  String? _endDateOfAttendance;
  String? _dateAssigment;
  num? _lokasiKerja;
  String? _picInspector;
  num? _picLaboratory;
  dynamic _inspectionCompletedDate;
  dynamic _laboratoryCompletedDate;
  dynamic _inspectionFinishedDate;
  dynamic _laboratoryFinishedDate;
  dynamic _canceledDate;
  dynamic _reasonCancel;
  dynamic _flagDocInspection;
  dynamic _flagDocLab;
  num? _mKindofserviceId;
  num? _mStatusjoId;
  num? _createdBy;
  dynamic _updatedBy;
  String? _createdAt;
  dynamic _updatedAt;
THJo copyWith({  num? id,
  num? tSoId,
  num? typeJo,
  String? tSoDate,
  String? joReceiveDate,
  String? code,
  num? flagLockJo,
  String? ettaVessel,
  String? startDateOfAttendance,
  String? endDateOfAttendance,
  String? dateAssigment,
  num? lokasiKerja,
  String? picInspector,
  num? picLaboratory,
  dynamic inspectionCompletedDate,
  dynamic laboratoryCompletedDate,
  dynamic inspectionFinishedDate,
  dynamic laboratoryFinishedDate,
  dynamic canceledDate,
  dynamic reasonCancel,
  dynamic flagDocInspection,
  dynamic flagDocLab,
  num? mKindofserviceId,
  num? mStatusjoId,
  num? createdBy,
  dynamic updatedBy,
  String? createdAt,
  dynamic updatedAt,
}) => THJo(  id: id ?? _id,
  tSoId: tSoId ?? _tSoId,
  typeJo: typeJo ?? _typeJo,
  tSoDate: tSoDate ?? _tSoDate,
  joReceiveDate: joReceiveDate ?? _joReceiveDate,
  code: code ?? _code,
  flagLockJo: flagLockJo ?? _flagLockJo,
  ettaVessel: ettaVessel ?? _ettaVessel,
  startDateOfAttendance: startDateOfAttendance ?? _startDateOfAttendance,
  endDateOfAttendance: endDateOfAttendance ?? _endDateOfAttendance,
  dateAssigment: dateAssigment ?? _dateAssigment,
  lokasiKerja: lokasiKerja ?? _lokasiKerja,
  picInspector: picInspector ?? _picInspector,
  picLaboratory: picLaboratory ?? _picLaboratory,
  inspectionCompletedDate: inspectionCompletedDate ?? _inspectionCompletedDate,
  laboratoryCompletedDate: laboratoryCompletedDate ?? _laboratoryCompletedDate,
  inspectionFinishedDate: inspectionFinishedDate ?? _inspectionFinishedDate,
  laboratoryFinishedDate: laboratoryFinishedDate ?? _laboratoryFinishedDate,
  canceledDate: canceledDate ?? _canceledDate,
  reasonCancel: reasonCancel ?? _reasonCancel,
  flagDocInspection: flagDocInspection ?? _flagDocInspection,
  flagDocLab: flagDocLab ?? _flagDocLab,
  mKindofserviceId: mKindofserviceId ?? _mKindofserviceId,
  mStatusjoId: mStatusjoId ?? _mStatusjoId,
  createdBy: createdBy ?? _createdBy,
  updatedBy: updatedBy ?? _updatedBy,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get tSoId => _tSoId;
  num? get typeJo => _typeJo;
  String? get tSoDate => _tSoDate;
  String? get joReceiveDate => _joReceiveDate;
  String? get code => _code;
  num? get flagLockJo => _flagLockJo;
  String? get ettaVessel => _ettaVessel;
  String? get startDateOfAttendance => _startDateOfAttendance;
  String? get endDateOfAttendance => _endDateOfAttendance;
  String? get dateAssigment => _dateAssigment;
  num? get lokasiKerja => _lokasiKerja;
  String? get picInspector => _picInspector;
  num? get picLaboratory => _picLaboratory;
  dynamic get inspectionCompletedDate => _inspectionCompletedDate;
  dynamic get laboratoryCompletedDate => _laboratoryCompletedDate;
  dynamic get inspectionFinishedDate => _inspectionFinishedDate;
  dynamic get laboratoryFinishedDate => _laboratoryFinishedDate;
  dynamic get canceledDate => _canceledDate;
  dynamic get reasonCancel => _reasonCancel;
  dynamic get flagDocInspection => _flagDocInspection;
  dynamic get flagDocLab => _flagDocLab;
  num? get mKindofserviceId => _mKindofserviceId;
  num? get mStatusjoId => _mStatusjoId;
  num? get createdBy => _createdBy;
  dynamic get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_so_id'] = _tSoId;
    map['type_jo'] = _typeJo;
    map['t_so_date'] = _tSoDate;
    map['jo_receive_date'] = _joReceiveDate;
    map['code'] = _code;
    map['flag_lock_jo'] = _flagLockJo;
    map['etta_vessel'] = _ettaVessel;
    map['start_date_of_attendance'] = _startDateOfAttendance;
    map['end_date_of_attendance'] = _endDateOfAttendance;
    map['date_assigment'] = _dateAssigment;
    map['lokasi_kerja'] = _lokasiKerja;
    map['pic_inspector'] = _picInspector;
    map['pic_laboratory'] = _picLaboratory;
    map['inspection_completed_date'] = _inspectionCompletedDate;
    map['laboratory_completed_date'] = _laboratoryCompletedDate;
    map['inspection_finished_date'] = _inspectionFinishedDate;
    map['laboratory_finished_date'] = _laboratoryFinishedDate;
    map['canceled_date'] = _canceledDate;
    map['reason_cancel'] = _reasonCancel;
    map['flag_doc_inspection'] = _flagDocInspection;
    map['flag_doc_lab'] = _flagDocLab;
    map['m_kindofservice_id'] = _mKindofserviceId;
    map['m_statusjo_id'] = _mStatusjoId;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

  Map<String, dynamic> toCompleteLab() {
    final map = <String, dynamic>{};
    map['laboratory_completed_date'] = _laboratoryCompletedDate;
    map['laboratory_finished_date'] = _laboratoryFinishedDate;
    //map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    //map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

  Map<String, dynamic> toCompleteInspection() {
    final map = <String, dynamic>{};
    map['inspection_completed_date'] = _inspectionCompletedDate;
    map['inspection_finished_date'] = _inspectionFinishedDate;
    //map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    //map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }


}