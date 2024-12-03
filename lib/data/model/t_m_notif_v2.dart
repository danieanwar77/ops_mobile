import 'package:ops_mobile/data/sqlite.dart';

/// id : 878
/// jo_id : 7
/// id_trans : null
/// message : "Berhasil Merubah Status Assign"
/// employee_id : 1234
/// link : null
/// flag_active : 1
/// flag_read : 0
/// created_by : 0
/// updated_by : null
/// created_at : "2024-12-02 16:20:33.0"
/// updated_at : "2024-12-02 16:20:33.0"

class TMNotifV2 {
  TMNotifV2({
      num? id,
      num? joId,
      dynamic? idTrans,
      String? message,
      num? employeeId,
      dynamic? link,
      num? flagActive,
      num? flagRead,
      num? createdBy,
      dynamic? updatedBy,
      String? createdAt,
      String? updatedAt,}){
    _id = id;
    _joId = joId;
    _idTrans = idTrans;
    _message = message;
    _employeeId = employeeId;
    _link = link;
    _flagActive = flagActive;
    _flagRead = flagRead;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  TMNotifV2.fromJson(dynamic json) {
    _id = json['id'];
    _joId = json['jo_id'];
    _idTrans = json['id_trans'];
    _message = json['message'];
    _employeeId = json['employee_id'];
    _link = json['link'];
    _flagActive = json['flag_active'];
    _flagRead = json['flag_read'];
    _createdBy = json['created_by'];
    _updatedBy = json['updated_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _joId;
  dynamic? _idTrans;
  String? _message;
  num? _employeeId;
  dynamic? _link;
  num? _flagActive;
  num? _flagRead;
  num? _createdBy;
  dynamic? _updatedBy;
  String? _createdAt;
  String? _updatedAt;
TMNotifV2 copyWith({
  num? id,
  num? joId,
  dynamic? idTrans,
  String? message,
  num? employeeId,
  dynamic? link,
  num? flagActive,
  num? flagRead,
  num? createdBy,
  dynamic? updatedBy,
  String? createdAt,
  String? updatedAt,
}) => TMNotifV2(  id: id ?? _id,
  joId: joId ?? _joId,
  idTrans: idTrans ?? _idTrans,
  message: message ?? _message,
  employeeId: employeeId ?? _employeeId,
  link: link ?? _link,
  flagActive: flagActive ?? _flagActive,
  flagRead: flagRead ?? _flagRead,
  createdBy: createdBy ?? _createdBy,
  updatedBy: updatedBy ?? _updatedBy,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get joId => _joId;
  dynamic? get idTrans => _idTrans;
  String? get message => _message;
  num? get employeeId => _employeeId;
  dynamic? get link => _link;
  num? get flagActive => _flagActive;
  num? get flagRead => _flagRead;
  num? get createdBy => _createdBy;
  dynamic? get updatedBy => _updatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['jo_id'] = _joId;
    map['id_trans'] = _idTrans;
    map['message'] = _message;
    map['employee_id'] = _employeeId;
    map['link'] = _link;
    map['flag_active'] = _flagActive;
    map['flag_read'] = _flagRead;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

  Map<String, dynamic> toInsert() {
    final map = <String, dynamic>{};
    //map['id'] = _id;
    map['jo_id'] = _joId;
    map['id_trans'] = _idTrans;
    map['message'] = _message;
    map['employee_id'] = _employeeId;
    map['link'] = _link;
    map['flag_active'] = _flagActive;
    map['flag_read'] = _flagRead;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

  static Future<void> syncNotif(List<TMNotifV2> data) async{
    final db = await SqlHelper.db();
    for(int i= 0; i < data.length; i++){
      final id = data[i]!.id ?? 0;
      var sql = '''SELECT * from t_mnotif where id=?''';
      var exsis = await db.rawQuery(sql,[id]);
      if(exsis.isEmpty){
        await db.insert('t_mnotif', data[i].toInsert());
      }
    }
  }
  static Future<int> countNotif(int employeeId) async {
    final db = await SqlHelper.db();
    var sql = '''select * from t_mnotif where employee_id=? and flag_active=1 and flag_read=0''';
    var result = await db.rawQuery(sql,[employeeId]);
    return result.length;
  }

}