import 'package:ops_mobile/data/sqlite.dart';
import 'package:ops_mobile/utils/helper.dart';

/// id : 1
/// t_h_jo_id : 1
/// path_photo : "asdasd"
/// keterangan : "Keterangan asd"
/// code : "tdad"
/// is_active : 1
/// is_upload : 0
/// created_at : "2024-01-01T00:00:00Z"
/// updated_at : null

class TDJoInspectionPict {
  TDJoInspectionPict({
      num? id, 
      num? tHJoId, 
      String? pathPhoto, 
      String? keterangan, 
      String? code, 
      num? isActive, 
      num? isUpload, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _tHJoId = tHJoId;
    _pathPhoto = pathPhoto;
    _keterangan = keterangan;
    _code = code;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  TDJoInspectionPict.fromJson(dynamic json) {
    _id = json['id'];
    _tHJoId = json['t_h_jo_id'];
    _pathPhoto = json['path_photo'];
    _keterangan = json['keterangan'];
    _code = json['code'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _tHJoId;
  String? _pathPhoto;
  String? _keterangan;
  String? _code;
  num? _isActive;
  num? _isUpload;
  String? _createdAt;
  dynamic _updatedAt;
TDJoInspectionPict copyWith({  num? id,
  num? tHJoId,
  String? pathPhoto,
  String? keterangan,
  String? code,
  num? isActive,
  num? isUpload,
  String? createdAt,
  dynamic updatedAt,
}) => TDJoInspectionPict(  id: id ?? _id,
  tHJoId: tHJoId ?? _tHJoId,
  pathPhoto: pathPhoto ?? _pathPhoto,
  keterangan: keterangan ?? _keterangan,
  code: code ?? _code,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get tHJoId => _tHJoId;
  String? get pathPhoto => _pathPhoto;
  String? get keterangan => _keterangan;
  String? get code => _code;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  String? get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;

  set pathPhoto(String? value) => _pathPhoto = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['t_h_jo_id'] = _tHJoId;
    map['path_photo'] = _pathPhoto;
    map['keterangan'] = _keterangan;
    map['code'] = _code;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

  Map<String, dynamic> toEdit() {
    final map = <String, dynamic>{};
    map['t_h_jo_id'] = _tHJoId;
    map['path_photo'] = _pathPhoto;
    map['keterangan'] = _keterangan;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['updated_at'] = _updatedAt;
    return map;
  }
  
  static Future<List<TDJoInspectionPict>> getSendDataPict() async{
    final db = await SqlHelper.db();
    var result = await db.rawQuery('select * from t_d_jo_inspection_pict where is_upload=0');
    List<TDJoInspectionPict> joPicts = result.map((item) => TDJoInspectionPict.fromJson(item)).toList();
    return  joPicts;
  }

  static Future<int> updateUploaded(String code) async {
    final db = await SqlHelper.db();
    return await db.update("t_d_jo_inspection_pict", {"is_upload": 1},where: "code=?",whereArgs: [code]);
  }
  
  

}