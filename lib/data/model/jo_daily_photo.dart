/// http_code : 200
/// message : "Success get photo."
/// data : [{"id":47,"t_h_jo_id":7,"path_photo":"images/66d4bcb35dd04.jpg","keterangan":"","created_at":"2024-09-01T19:02:37.000000Z","updated_at":"2024-09-01T19:12:51.000000Z"}]

class JoDailyPhoto {
  JoDailyPhoto({
      num? httpCode, 
      String? message, 
      List<DataDailyPhoto>? data,}){
    _httpCode = httpCode;
    _message = message;
    _data = data;
}

  JoDailyPhoto.fromJson(dynamic json) {
    _httpCode = json['http_code'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DataDailyPhoto.fromJson(v));
      });
    }
  }
  num? _httpCode;
  String? _message;
  List<DataDailyPhoto>? _data;
JoDailyPhoto copyWith({  num? httpCode,
  String? message,
  List<DataDailyPhoto>? data,
}) => JoDailyPhoto(  httpCode: httpCode ?? _httpCode,
  message: message ?? _message,
  data: data ?? _data,
);
  num? get httpCode => _httpCode;
  String? get message => _message;
  List<DataDailyPhoto>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['http_code'] = _httpCode;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 47
/// t_h_jo_id : 7
/// path_photo : "images/66d4bcb35dd04.jpg"
/// keterangan : ""
/// created_at : "2024-09-01T19:02:37.000000Z"
/// updated_at : "2024-09-01T19:12:51.000000Z"

class DataDailyPhoto {
  DataDailyPhoto({
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

  DataDailyPhoto.fromJson(dynamic json) {
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
DataDailyPhoto copyWith({  num? id,
  num? tHJoId,
  String? pathPhoto,
  String? keterangan,
  String? createdAt,
  String? updatedAt,
}) => DataDailyPhoto(  id: id ?? _id,
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