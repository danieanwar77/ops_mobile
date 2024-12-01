import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:ops_mobile/data/model/t_d_jo_document_laboratory.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_activity_stages.dart';
import 'package:ops_mobile/data/model/t_d_jo_inspection_attachment.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory.dart';
import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/utils/helper.dart';

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
      num? picInspector,
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
      List<TDJoInspectionActivityStages>? inspection_activity_stages,
    List<TDJoLaboratory>? laboratory,
  }){
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
    _inspectionActivityStages = inspection_activity_stages;
    _laboratory = laboratory;

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
  num? _picInspector;
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
  List<TDJoInspectionActivityStages>? _inspectionActivityStages;
  List<TDJoLaboratory>? _laboratory;

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
    //_picInspector = json['pic_inspector'];
    //_picLaboratory = num.tryParse(json['pic_laboratory']);
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
    
    if (json['inspection_activity_stages'] != null) {
      _inspectionActivityStages = (json['inspection_activity_stages'] as List)
          .map((e) => TDJoInspectionActivityStages.fromJson(e))
          .toList();
    } else {
      _inspectionActivityStages = [];
    }

    if (json['list_laboratory'] != null) {
      _laboratory = (json['list_laboratory'] as List)
          .map((e) => TDJoLaboratory.fromJson(e))
          .toList();
    } else {
      _laboratory = [];
    }



  }
  
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
  num? picInspector,
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
  num? get picInspector => _picInspector;
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
  List<TDJoInspectionActivityStages>? get inspectionActivityStages => _inspectionActivityStages;
  List<TDJoLaboratory>? get laboratory => _laboratory;

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

  Map<String, dynamic> toSend() {
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
    if (_inspectionActivityStages != null) {
      map['inspection_activity_stages'] = _inspectionActivityStages?.map((v) => v.toJson()).toList();
    }
    if(_laboratory != null){
      map['list_laboratory'] = _laboratory?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  static Future<THJo>getJoById(int id) async{
    final db = await SqlHelper.db();
    var joRslt = await db.rawQuery("SELECT * FROM t_h_jo WHERE id = ?", [id]);
    if(joRslt.length > 0){
      return THJo.fromJson(joRslt[0]);
    }
    return THJo();
  }

  static Future<THJo>getJoActivitySend() async{
    final db = await SqlHelper.db();
    final sqlActStage = 'SELECT * from t_d_jo_inspection_activity_stages where is_upload = 0';
    var dataActStage = await db.rawQuery(sqlActStage);
    if (dataActStage.isNotEmpty) {
      // Ambil data pertama dari dataActStage
      var firstStage = Map<String, dynamic>.from(dataActStage[0]);

      // Query untuk mendapatkan data activity
      final sqlAct = '''SELECT * FROM t_d_jo_inspection_activity WHERE t_d_jo_inspection_activity_stages_id = ? AND is_upload = 0 ''';
      var dataAct = await db.rawQuery(sqlAct, [firstStage['id']]);
      var copyDataAct = dataAct.map((item) => Map<String, dynamic>.from(item)).toList();

      if(firstStage['m_statusinspectionstages_id'] == 5){
        final sqlTranshipment = '''SELECT * from t_d_jo_inspection_activity_stages_transhipment where t_d_inspection_stages_id = ? and is_upload=0 ''';
        var dataTranshipment = await db.rawQuery(sqlTranshipment, [firstStage['id']]);
        const sqlBarge = '''SELECT * from t_d_jo_inspection_activity_barge where is_upload  = 0 and t_d_jo_inspection_activity_stages_id = ?;''';
        var dataBarge = await db.rawQuery(sqlBarge,[firstStage['id']]);
        firstStage['listactivitybarge'] = dataBarge.map((item) => Map<String,dynamic>.from(item)).toList();
        firstStage['listactivitytranshipment'] = dataTranshipment.map((item) => Map<String,dynamic>.from(item)).toList();
        const sqlVesel = '''SELECT * from t_d_jo_inspection_activity_vessel where is_upload = 0 and t_d_jo_inspection_activity_stages_id = ?''';
        var dataVesel = await db.rawQuery(sqlVesel,[firstStage['id']]);
        firstStage['listactivityvessel'] = dataVesel.map((item) => Map<String,dynamic>.from(item)).toList();
      }

      if(firstStage['m_statusinspectionstages_id'] == 6){
        final sqlAttachment = '''SELECT * from t_d_jo_inspection_attachment where t_h_jo_id =  ? and is_upload  = 0''';
        var dataAttachment = await db.rawQuery(sqlAttachment,[firstStage['t_h_jo_id']]);
        var copyAttachment = dataAttachment.map((item) => Map<String, dynamic>.from(item)).toList();
        for(int a = 0; a < copyAttachment.length; a++){
          var data = copyAttachment[a];
          data['path_name'] = await Helper.convertPhotosToBase64(data['path_name'].toString());
          //masukan data ke result
        }
        firstStage['listattachment'] = copyAttachment;
      }

      // Tambahkan list activity ke dalam firstStage
      firstStage['listactivity'] = copyDataAct;

      var joResultList = await db.rawQuery(
          "SELECT * FROM t_h_jo WHERE id = ?",
          [firstStage['t_h_jo_id']]
      );

      // Ambil data pertama dari joResultList jika ada
      var joResult = joResultList.isNotEmpty ? Map<String, dynamic>.from(joResultList.first) : null;

      // Tambahkan inspection_activity_stage ke joResult jika ada
      if (joResult != null) {
        joResult['inspection_activity_stages'] = [firstStage];
        return THJo.fromJson(joResult);
      }
    }
    return THJo();
  }

  static Future<THJo>getJoLaboratorySend() async{
    final db = await SqlHelper.db();
    final sqlLabActStage = 'SELECT * from t_d_jo_laboratory_activity_stages where is_upload = 0';
    var dataActStage = await db.rawQuery(sqlLabActStage);
    if(dataActStage.isNotEmpty){
      var firstStage = Map<String, dynamic>.from(dataActStage[0]);
      var joResult = await db.rawQuery("SELECT * FROM t_h_jo WHERE id = ?", [firstStage['t_h_jo_id']]);
      var joLabResult = await db.rawQuery("SELECT * from t_d_jo_laboratory where id = ?",[firstStage['d_jo_laboratory_id']]);
      var joLabAct = await db.rawQuery('SELECT * from t_d_jo_laboratory_activity where t_d_jo_laboratory_activity_stages_id = ? and is_upload  = 0',[firstStage['id']]);
      var copyDataAct = joLabAct.map((item) => Map<String, dynamic>.from(item)).toList();
      var copyJoLabResult = joLabResult.isNotEmpty ? Map<String, dynamic>.from(joLabResult.first) : null;
      var copyResult = joResult.map((item) => Map<String, dynamic>.from(item)).toList();
      firstStage['list_lab_activity'] = copyDataAct;
      var thJo = copyResult.isNotEmpty ? Map<String, dynamic>.from(copyResult.first) : null;
      if(firstStage['m_statuslaboratoryprogress_id'] == 6){
        var dataLabAttachment =  await db.rawQuery('select * from t_d_jo_laboratory_attachment where t_d_jo_laboratory = ? and is_upload = 0',[firstStage['d_jo_laboratory_id']]);
        var copyLabAttach = dataLabAttachment.map((item) => Map<String,dynamic>.from(item)).toList();
        firstStage['list_lab_attachment'] = copyLabAttach;
      }
      if(thJo != null && copyJoLabResult != null){
        copyJoLabResult['laboratory_activity_stages'] = [firstStage];
        thJo['list_laboratory'] = [copyJoLabResult];
        return THJo.fromJson(thJo);
      }
    }
    return THJo();
  }

}