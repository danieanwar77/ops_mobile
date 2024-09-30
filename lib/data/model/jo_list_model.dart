/// http_code : 200
/// data : {"current_page":1,"data":[{"jo_id":17,"code":"JO17","id_h_so":2,"id_d_kos":4,"sbu_id":2,"sbu_name":"Agri","company_acc_id":9,"company_name":"Bumi Nusantara Jaya","m_statusjo_id":1,"statusjo_name":"New","kos_name":"Quantity & Quality Control Management Services","created_at":"2024-06-11 09:00:41"}],"first_page_url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/1?page=1","from":1,"last_page":1,"last_page_url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/1?page=1","links":[{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/1?page=1","label":"1","active":true},{"url":null,"label":"Next &raquo;","active":false}],"next_page_url":null,"path":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/1","per_page":10,"prev_page_url":null,"to":1,"total":1}
/// message : "Success get jo by status"

class JoListModel {
  JoListModel({
      int? httpCode, 
      DataListJo? data,
      String? message,}){
    _httpCode = httpCode;
    _data = data;
    _message = message;
}

  JoListModel.fromJson(dynamic json) {
    _httpCode = json['http_code'];
    _data = json['data'] != null ? DataListJo.fromJson(json['data']) : null;
    _message = json['message'];
  }
  int? _httpCode;
  DataListJo? _data;
  String? _message;
JoListModel copyWith({  int? httpCode,
  DataListJo? data,
  String? message,
}) => JoListModel(  httpCode: httpCode ?? _httpCode,
  data: data ?? _data,
  message: message ?? _message,
);
  int? get httpCode => _httpCode;
  DataListJo? get data => _data;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['http_code'] = _httpCode;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['message'] = _message;
    return map;
  }

}

/// current_page : 1
/// data : [{"jo_id":17,"code":"JO17","id_h_so":2,"id_d_kos":4,"sbu_id":2,"sbu_name":"Agri","company_acc_id":9,"company_name":"Bumi Nusantara Jaya","m_statusjo_id":1,"statusjo_name":"New","kos_name":"Quantity & Quality Control Management Services","created_at":"2024-06-11 09:00:41"}]
/// first_page_url : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/1?page=1"
/// from : 1
/// last_page : 1
/// last_page_url : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/1?page=1"
/// links : [{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/1?page=1","label":"1","active":true},{"url":null,"label":"Next &raquo;","active":false}]
/// next_page_url : null
/// path : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/1"
/// per_page : 10
/// prev_page_url : null
/// to : 1
/// total : 1

class DataListJo {
  DataListJo({
      int? currentPage, 
      List<DataJo>? data,
      String? firstPageUrl, 
      int? from, 
      int? lastPage, 
      String? lastPageUrl, 
      List<Links>? links, 
      dynamic nextPageUrl, 
      String? path, 
      int? perPage, 
      dynamic prevPageUrl, 
      int? to, 
      int? total,}){
    _currentPage = currentPage;
    _data = data;
    _firstPageUrl = firstPageUrl;
    _from = from;
    _lastPage = lastPage;
    _lastPageUrl = lastPageUrl;
    _links = links;
    _nextPageUrl = nextPageUrl;
    _path = path;
    _perPage = perPage;
    _prevPageUrl = prevPageUrl;
    _to = to;
    _total = total;
}

  DataListJo.fromJson(dynamic json) {
    _currentPage = json['current_page'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DataJo.fromJson(v));
      });
    }
    _firstPageUrl = json['first_page_url'];
    _from = json['from'];
    _lastPage = json['last_page'];
    _lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      _links = [];
      json['links'].forEach((v) {
        _links?.add(Links.fromJson(v));
      });
    }
    _nextPageUrl = json['next_page_url'];
    _path = json['path'];
    _perPage = json['per_page'];
    _prevPageUrl = json['prev_page_url'];
    _to = json['to'];
    _total = json['total'];
  }
  int? _currentPage;
  List<DataJo>? _data;
  String? _firstPageUrl;
  int? _from;
  int? _lastPage;
  String? _lastPageUrl;
  List<Links>? _links;
  dynamic _nextPageUrl;
  String? _path;
  int? _perPage;
  dynamic _prevPageUrl;
  int? _to;
  int? _total;
  DataListJo copyWith({  int? currentPage,
  List<DataJo>? data,
  String? firstPageUrl,
  int? from,
  int? lastPage,
  String? lastPageUrl,
  List<Links>? links,
  dynamic nextPageUrl,
  String? path,
  int? perPage,
  dynamic prevPageUrl,
  int? to,
  int? total,
}) => DataListJo(  currentPage: currentPage ?? _currentPage,
  data: data ?? _data,
  firstPageUrl: firstPageUrl ?? _firstPageUrl,
  from: from ?? _from,
  lastPage: lastPage ?? _lastPage,
  lastPageUrl: lastPageUrl ?? _lastPageUrl,
  links: links ?? _links,
  nextPageUrl: nextPageUrl ?? _nextPageUrl,
  path: path ?? _path,
  perPage: perPage ?? _perPage,
  prevPageUrl: prevPageUrl ?? _prevPageUrl,
  to: to ?? _to,
  total: total ?? _total,
);
  int? get currentPage => _currentPage;
  List<DataJo>? get data => _data;
  String? get firstPageUrl => _firstPageUrl;
  int? get from => _from;
  int? get lastPage => _lastPage;
  String? get lastPageUrl => _lastPageUrl;
  List<Links>? get links => _links;
  dynamic get nextPageUrl => _nextPageUrl;
  String? get path => _path;
  int? get perPage => _perPage;
  dynamic get prevPageUrl => _prevPageUrl;
  int? get to => _to;
  int? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = _currentPage;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['first_page_url'] = _firstPageUrl;
    map['from'] = _from;
    map['last_page'] = _lastPage;
    map['last_page_url'] = _lastPageUrl;
    if (_links != null) {
      map['links'] = _links?.map((v) => v.toJson()).toList();
    }
    map['next_page_url'] = _nextPageUrl;
    map['path'] = _path;
    map['per_page'] = _perPage;
    map['prev_page_url'] = _prevPageUrl;
    map['to'] = _to;
    map['total'] = _total;
    return map;
  }

}

/// url : null
/// label : "&laquo; Previous"
/// active : false

class Links {
  Links({
      dynamic url, 
      String? label, 
      bool? active,}){
    _url = url;
    _label = label;
    _active = active;
}

  Links.fromJson(dynamic json) {
    _url = json['url'];
    _label = json['label'];
    _active = json['active'];
  }
  dynamic _url;
  String? _label;
  bool? _active;
Links copyWith({  dynamic url,
  String? label,
  bool? active,
}) => Links(  url: url ?? _url,
  label: label ?? _label,
  active: active ?? _active,
);
  dynamic get url => _url;
  String? get label => _label;
  bool? get active => _active;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = _url;
    map['label'] = _label;
    map['active'] = _active;
    return map;
  }

}

/// jo_id : 17
/// code : "JO17"
/// id_h_so : 2
/// id_d_kos : 4
/// sbu_id : 2
/// sbu_name : "Agri"
/// company_acc_id : 9
/// company_name : "Bumi Nusantara Jaya"
/// m_statusjo_id : 1
/// statusjo_name : "New"
/// kos_name : "Quantity & Quality Control Management Services"
/// created_at : "2024-06-11 09:00:41"

class DataJo {
  DataJo({
      int? joId, 
      String? code, 
      int? idHSo, 
      int? idDKos, 
      int? sbuId, 
      String? sbuName, 
      int? companyAccId, 
      String? companyName, 
      int? mStatusjoId, 
      String? statusjoName, 
      String? kosName, 
      String? createdAt,}){
    _joId = joId;
    _code = code;
    _idHSo = idHSo;
    _idDKos = idDKos;
    _sbuId = sbuId;
    _sbuName = sbuName;
    _companyAccId = companyAccId;
    _companyName = companyName;
    _mStatusjoId = mStatusjoId;
    _statusjoName = statusjoName;
    _kosName = kosName;
    _createdAt = createdAt;
}

  DataJo.fromJson(dynamic json) {
    _joId = json['jo_id'];
    _code = json['code'];
    _idHSo = json['id_h_so'];
    _idDKos = json['id_d_kos'];
    _sbuId = json['sbu_id'];
    _sbuName = json['sbu_name'];
    _companyAccId = json['company_acc_id'];
    _companyName = json['company_name'];
    _mStatusjoId = json['m_statusjo_id'];
    _statusjoName = json['statusjo_name'];
    _kosName = json['kos_name'];
    _createdAt = json['created_at'];
  }
  int? _joId;
  String? _code;
  int? _idHSo;
  int? _idDKos;
  int? _sbuId;
  String? _sbuName;
  int? _companyAccId;
  String? _companyName;
  int? _mStatusjoId;
  String? _statusjoName;
  String? _kosName;
  String? _createdAt;
  DataJo copyWith({  int? joId,
  String? code,
  int? idHSo,
  int? idDKos,
  int? sbuId,
  String? sbuName,
  int? companyAccId,
  String? companyName,
  int? mStatusjoId,
  String? statusjoName,
  String? kosName,
  String? createdAt,
}) => DataJo(  joId: joId ?? _joId,
  code: code ?? _code,
  idHSo: idHSo ?? _idHSo,
  idDKos: idDKos ?? _idDKos,
  sbuId: sbuId ?? _sbuId,
  sbuName: sbuName ?? _sbuName,
  companyAccId: companyAccId ?? _companyAccId,
  companyName: companyName ?? _companyName,
  mStatusjoId: mStatusjoId ?? _mStatusjoId,
  statusjoName: statusjoName ?? _statusjoName,
  kosName: kosName ?? _kosName,
  createdAt: createdAt ?? _createdAt,
);
  int? get joId => _joId;
  String? get code => _code;
  int? get idHSo => _idHSo;
  int? get idDKos => _idDKos;
  int? get sbuId => _sbuId;
  String? get sbuName => _sbuName;
  int? get companyAccId => _companyAccId;
  String? get companyName => _companyName;
  int? get mStatusjoId => _mStatusjoId;
  String? get statusjoName => _statusjoName;
  String? get kosName => _kosName;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['jo_id'] = _joId;
    map['code'] = _code;
    map['id_h_so'] = _idHSo;
    map['id_d_kos'] = _idDKos;
    map['sbu_id'] = _sbuId;
    map['sbu_name'] = _sbuName;
    map['company_acc_id'] = _companyAccId;
    map['company_name'] = _companyName;
    map['m_statusjo_id'] = _mStatusjoId;
    map['statusjo_name'] = _statusjoName;
    map['kos_name'] = _kosName;
    map['created_at'] = _createdAt;
    return map;
  }

}