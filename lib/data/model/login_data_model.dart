/// status : 1
/// title : "Employee"
/// message : "Detail employee"
/// info : {"total":1}
/// data : {"id":1624,"fullname":"Navisaaa","nip":"1234","position_id":169,"position":"Training & Development Supervisor","division_id":6,"division":"Information & Technology","superior":"-"}

class LoginDataModel {
  LoginDataModel({
      num? status, 
      String? title, 
      String? message, 
      Info? info, 
      Data? data,}){
    _status = status;
    _title = title;
    _message = message;
    _info = info;
    _data = data;
}

  LoginDataModel.fromJson(dynamic json) {
    _status = json['status'];
    _title = json['title'];
    _message = json['message'];
    _info = json['info'] != null ? Info.fromJson(json['info']) : null;
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? _status;
  String? _title;
  String? _message;
  Info? _info;
  Data? _data;
LoginDataModel copyWith({  num? status,
  String? title,
  String? message,
  Info? info,
  Data? data,
}) => LoginDataModel(  status: status ?? _status,
  title: title ?? _title,
  message: message ?? _message,
  info: info ?? _info,
  data: data ?? _data,
);
  num? get status => _status;
  String? get title => _title;
  String? get message => _message;
  Info? get info => _info;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['title'] = _title;
    map['message'] = _message;
    if (_info != null) {
      map['info'] = _info?.toJson();
    }
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// id : 1624
/// fullname : "Navisaaa"
/// nip : "1234"
/// position_id : 169
/// position : "Training & Development Supervisor"
/// division_id : 6
/// division : "Information & Technology"
/// superior : "-"

class Data {
  Data({
      num? id, 
      String? fullname, 
      String? nip, 
      num? positionId, 
      String? position, 
      num? divisionId, 
      String? division, 
      String? superior,}){
    _id = id;
    _fullname = fullname;
    _nip = nip;
    _positionId = positionId;
    _position = position;
    _divisionId = divisionId;
    _division = division;
    _superior = superior;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _fullname = json['fullname'];
    _nip = json['nip'];
    _positionId = json['position_id'];
    _position = json['position'];
    _divisionId = json['division_id'];
    _division = json['division'];
    _superior = json['superior'];
  }
  num? _id;
  String? _fullname;
  String? _nip;
  num? _positionId;
  String? _position;
  num? _divisionId;
  String? _division;
  String? _superior;
Data copyWith({  num? id,
  String? fullname,
  String? nip,
  num? positionId,
  String? position,
  num? divisionId,
  String? division,
  String? superior,
}) => Data(  id: id ?? _id,
  fullname: fullname ?? _fullname,
  nip: nip ?? _nip,
  positionId: positionId ?? _positionId,
  position: position ?? _position,
  divisionId: divisionId ?? _divisionId,
  division: division ?? _division,
  superior: superior ?? _superior,
);
  num? get id => _id;
  String? get fullname => _fullname;
  String? get nip => _nip;
  num? get positionId => _positionId;
  String? get position => _position;
  num? get divisionId => _divisionId;
  String? get division => _division;
  String? get superior => _superior;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['fullname'] = _fullname;
    map['nip'] = _nip;
    map['position_id'] = _positionId;
    map['position'] = _position;
    map['division_id'] = _divisionId;
    map['division'] = _division;
    map['superior'] = _superior;
    return map;
  }

}

/// total : 1

class Info {
  Info({
      num? total,}){
    _total = total;
}

  Info.fromJson(dynamic json) {
    _total = json['total'];
  }
  num? _total;
Info copyWith({  num? total,
}) => Info(  total: total ?? _total,
);
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = _total;
    return map;
  }

}