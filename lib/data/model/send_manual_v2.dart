import 'package:ops_mobile/data/sqlite.dart';

/// id_trans : 1
/// module : "Stage 1"
/// table : "t_h_jo"
/// is_upload : 0

class SendManualV2 {
  SendManualV2({
      num? idTrans,
      String? module,
      String? table,
      num? isUpload,
      num? type,
    dynamic? transDate
  }){
    _idTrans = idTrans;
    _module = module;
    _table = table;
    _isUpload = isUpload;
    _transDate = transDate;
    _type = type;
}

  SendManualV2.fromJson(dynamic json) {
    _idTrans = json['id_trans'];
    _module = json['module'];
    _table = json['table'];
    _isUpload = json['is_upload'];
    _transDate = json['trans_date'];
    _type = json['type'];

  }
  num? _idTrans;
  String? _module;
  String? _table;
  num? _isUpload;
  dynamic? _transDate;
  num? _type;
  SendManualV2 copyWith({  num? idTrans,
  String? module,
  String? table,
  num? isUpload,
}) => SendManualV2(  idTrans: idTrans ?? _idTrans,
  module: module ?? _module,
  table: table ?? _table,
  isUpload: isUpload ?? _isUpload,
);
  num? get idTrans => _idTrans;
  String? get module => _module;
  String? get table => _table;
  num? get isUpload => _isUpload;
  dynamic? get transDate => _transDate;
  num? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id_trans'] = _idTrans;
    map['module'] = _module;
    map['table'] = _table;
    map['is_upload'] = _isUpload;
    map['trans_date'] = _transDate;
    map['type'] = _type;
    return map;
  }
  
  static Future<List<SendManualV2>> dataPending() async{
    final db = await SqlHelper.db();
    List<SendManualV2> result = [];
    var inspAct = await db.rawQuery('''SELECT * from t_d_jo_inspection_activity_stages where is_upload  = 0 ''');
    for(var dataAct in inspAct){
      result.add(SendManualV2(
        idTrans: int.tryParse(dataAct['id'].toString()),
        module: 'JO - ${dataAct['t_h_jo_id']} Activity Inspection ${dataAct['m_statusinspectionstages_id']}',
        table: 't_d_jo_inspection_activity_stages',
        transDate: dataAct['created_at'],
        isUpload: 0,
        type: 1
      ));
    }

    var inspPict = await db.rawQuery('''SELECT * from t_d_jo_inspection_pict where is_upload = 0;''');
    for(var item in inspPict){
      result.add(SendManualV2(
          idTrans: int.tryParse(item['id'].toString()),
          module: 'JO - ${item['t_h_jo_id']} Picture Inspection',
          table: 't_d_jo_inspection_pict',
          transDate: item['created_at'],
          isUpload: 0,
          type: 2
      ));
    }

    var inspFinalize = await db.rawQuery('''SELECT * from t_d_jo_finalize_inspection where is_upload = 0''');
    for(var dataInspFinal in inspFinalize){
      result.add(SendManualV2(
          idTrans: int.tryParse(dataInspFinal['id'].toString()),
          module: 'JO - ${dataInspFinal['t_h_jo_id']} Finalize Inspection',
          table: 't_d_jo_finalize_inspection',
          transDate: dataInspFinal['created_at'],
          isUpload: 0,
          type: 3
      ));
    }

    var labAct = await db.rawQuery('''SELECT * from t_d_jo_laboratory_activity_stages where is_upload =0''');
    for(var item in labAct){
      result.add(SendManualV2(
          idTrans: int.tryParse(item['id'].toString()),
          module: 'JO - ${item['t_h_jo_id']} Activity Lab Stage ${item['m_statuslaboratoryprogres_id']}',
          table: 't_d_jo_laboratory_activity_stages',
          transDate: item['created_at'],
          isUpload: 0,
          type: 4
      ));
    }
    var labFinalize = await db.rawQuery('''SELECT * from t_d_jo_finalize_laboratory where is_upload = 0''');
    for(var dataLabFinal in labFinalize){
      result.add(SendManualV2(
          idTrans: int.tryParse(dataLabFinal['id'].toString()),
          module: 'JO Lab - ${dataLabFinal['t_h_jo_id']} Finalize Laboratory',
          table: 't_d_jo_finalize_laboratory',
          transDate: dataLabFinal['created_at'],
          isUpload: 0,
          type: 5
      ));
    }
    //data finalize lab belum
    return result;
  }


}