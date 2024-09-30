/// http_code : 200
/// data : {"current_page":1,"data":[{"inspection_stages_id":39,"inspection_activity_id":65,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"10:00:00","end_activity_time":"11:51:00","activity":"Pembuatan draft survey","actual_qty":null,"uom_name":null,"path_name":"images/inspection/attach/66d6b6ed91143.jpg"},{"inspection_stages_id":39,"inspection_activity_id":67,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"14:20:00","end_activity_time":"15:00:00","activity":"Diskusi dengan spv untuk hasil laporan","actual_qty":null,"uom_name":null,"path_name":"images/inspection/attach/66d687a96b768.pdf"},{"inspection_stages_id":39,"inspection_activity_id":66,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"12:00:00","end_activity_time":"13:51:00","activity":"Penyococokan laporan dengan data aktual lapangan","actual_qty":null,"uom_name":null,"path_name":"images/inspection/attach/66d687a96b768.pdf"},{"inspection_stages_id":39,"inspection_activity_id":67,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"14:20:00","end_activity_time":"15:00:00","activity":"Diskusi dengan spv untuk hasil laporan","actual_qty":null,"uom_name":null,"path_name":"images/inspection/attach/66d6b6ed91143.jpg"},{"inspection_stages_id":39,"inspection_activity_id":65,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"10:00:00","end_activity_time":"11:51:00","activity":"Pembuatan draft survey","actual_qty":null,"uom_name":null,"path_name":"images/inspection/attach/66d687a96b768.pdf"},{"inspection_stages_id":39,"inspection_activity_id":66,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"12:00:00","end_activity_time":"13:51:00","activity":"Penyococokan laporan dengan data aktual lapangan","actual_qty":null,"uom_name":null,"path_name":"images/inspection/attach/66d6b6ed91143.jpg"}],"first_page_url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity_6/7?page=1","from":1,"last_page":1,"last_page_url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity_6/7?page=1","links":[{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity_6/7?page=1","label":"1","active":true},{"url":null,"label":"Next &raquo;","active":false}],"next_page_url":null,"path":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity_6/7","per_page":10,"prev_page_url":null,"to":6,"total":6}
/// message : "Success get activity"

class JoListDailyActivity6 {
  JoListDailyActivity6({
      num? httpCode,
      DataListActivity6? data,
      String? message,}){
    _httpCode = httpCode;
    _data = data;
    _message = message;
}

  JoListDailyActivity6.fromJson(dynamic json) {
    _httpCode = json['http_code'];
    _data = json['data'] != null ? DataListActivity6.fromJson(json['data']) : null;
    _message = json['message'];
  }
  num? _httpCode;
  DataListActivity6? _data;
  String? _message;
JoListDailyActivity6 copyWith({  num? httpCode,
  DataListActivity6? data,
  String? message,
}) => JoListDailyActivity6(  httpCode: httpCode ?? _httpCode,
  data: data ?? _data,
  message: message ?? _message,
);
  num? get httpCode => _httpCode;
  DataListActivity6? get data => _data;
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
/// data : [{"inspection_stages_id":39,"inspection_activity_id":65,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"10:00:00","end_activity_time":"11:51:00","activity":"Pembuatan draft survey","actual_qty":null,"uom_name":null,"path_name":"images/inspection/attach/66d6b6ed91143.jpg"},{"inspection_stages_id":39,"inspection_activity_id":67,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"14:20:00","end_activity_time":"15:00:00","activity":"Diskusi dengan spv untuk hasil laporan","actual_qty":null,"uom_name":null,"path_name":"images/inspection/attach/66d687a96b768.pdf"},{"inspection_stages_id":39,"inspection_activity_id":66,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"12:00:00","end_activity_time":"13:51:00","activity":"Penyococokan laporan dengan data aktual lapangan","actual_qty":null,"uom_name":null,"path_name":"images/inspection/attach/66d687a96b768.pdf"},{"inspection_stages_id":39,"inspection_activity_id":67,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"14:20:00","end_activity_time":"15:00:00","activity":"Diskusi dengan spv untuk hasil laporan","actual_qty":null,"uom_name":null,"path_name":"images/inspection/attach/66d6b6ed91143.jpg"},{"inspection_stages_id":39,"inspection_activity_id":65,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"10:00:00","end_activity_time":"11:51:00","activity":"Pembuatan draft survey","actual_qty":null,"uom_name":null,"path_name":"images/inspection/attach/66d687a96b768.pdf"},{"inspection_stages_id":39,"inspection_activity_id":66,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"12:00:00","end_activity_time":"13:51:00","activity":"Penyococokan laporan dengan data aktual lapangan","actual_qty":null,"uom_name":null,"path_name":"images/inspection/attach/66d6b6ed91143.jpg"}]
/// first_page_url : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity_6/7?page=1"
/// from : 1
/// last_page : 1
/// last_page_url : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity_6/7?page=1"
/// links : [{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity_6/7?page=1","label":"1","active":true},{"url":null,"label":"Next &raquo;","active":false}]
/// next_page_url : null
/// path : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity_6/7"
/// per_page : 10
/// prev_page_url : null
/// to : 6
/// total : 6

class DataListActivity6 {
  DataListActivity6({
      num? currentPage, 
      List<DataActivity6>? data,
      String? firstPageUrl, 
      num? from, 
      num? lastPage, 
      String? lastPageUrl, 
      List<Links>? links, 
      dynamic nextPageUrl, 
      String? path, 
      num? perPage, 
      dynamic prevPageUrl, 
      num? to, 
      num? total,}){
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

  DataListActivity6.fromJson(dynamic json) {
    _currentPage = json['current_page'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DataActivity6.fromJson(v));
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
  num? _currentPage;
  List<DataActivity6>? _data;
  String? _firstPageUrl;
  num? _from;
  num? _lastPage;
  String? _lastPageUrl;
  List<Links>? _links;
  dynamic _nextPageUrl;
  String? _path;
  num? _perPage;
  dynamic _prevPageUrl;
  num? _to;
  num? _total;
  DataListActivity6 copyWith({  num? currentPage,
  List<DataActivity6>? data,
  String? firstPageUrl,
  num? from,
  num? lastPage,
  String? lastPageUrl,
  List<Links>? links,
  dynamic nextPageUrl,
  String? path,
  num? perPage,
  dynamic prevPageUrl,
  num? to,
  num? total,
}) => DataListActivity6(  currentPage: currentPage ?? _currentPage,
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
  num? get currentPage => _currentPage;
  List<DataActivity6>? get data => _data;
  String? get firstPageUrl => _firstPageUrl;
  num? get from => _from;
  num? get lastPage => _lastPage;
  String? get lastPageUrl => _lastPageUrl;
  List<Links>? get links => _links;
  dynamic get nextPageUrl => _nextPageUrl;
  String? get path => _path;
  num? get perPage => _perPage;
  dynamic get prevPageUrl => _prevPageUrl;
  num? get to => _to;
  num? get total => _total;

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

/// inspection_stages_id : 39
/// inspection_activity_id : 65
/// t_h_jo_id : 7
/// m_statusinspectionstages_id : 6
/// stages_name : "Report to client"
/// trans_date : "2024-09-04"
/// remarks : "Draft survey dikirim ke client"
/// start_activity_time : "10:00:00"
/// end_activity_time : "11:51:00"
/// activity : "Pembuatan draft survey"
/// actual_qty : null
/// uom_name : null
/// path_name : "images/inspection/attach/66d6b6ed91143.jpg"

class DataActivity6 {
  DataActivity6({
      num? inspectionStagesId, 
      num? inspectionActivityId, 
      num? tHJoId, 
      num? mStatusinspectionstagesId, 
      String? stagesName, 
      String? transDate, 
      String? remarks, 
      String? startActivityTime, 
      String? endActivityTime, 
      String? activity, 
      dynamic actualQty, 
      dynamic uomName, 
      String? pathName,}){
    _inspectionStagesId = inspectionStagesId;
    _inspectionActivityId = inspectionActivityId;
    _tHJoId = tHJoId;
    _mStatusinspectionstagesId = mStatusinspectionstagesId;
    _stagesName = stagesName;
    _transDate = transDate;
    _remarks = remarks;
    _startActivityTime = startActivityTime;
    _endActivityTime = endActivityTime;
    _activity = activity;
    _actualQty = actualQty;
    _uomName = uomName;
    _pathName = pathName;
}

  DataActivity6.fromJson(dynamic json) {
    _inspectionStagesId = json['inspection_stages_id'];
    _inspectionActivityId = json['inspection_activity_id'];
    _tHJoId = json['t_h_jo_id'];
    _mStatusinspectionstagesId = json['m_statusinspectionstages_id'];
    _stagesName = json['stages_name'];
    _transDate = json['trans_date'];
    _remarks = json['remarks'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _activity = json['activity'];
    _actualQty = json['actual_qty'];
    _uomName = json['uom_name'];
    _pathName = json['path_name'];
  }
  num? _inspectionStagesId;
  num? _inspectionActivityId;
  num? _tHJoId;
  num? _mStatusinspectionstagesId;
  String? _stagesName;
  String? _transDate;
  String? _remarks;
  String? _startActivityTime;
  String? _endActivityTime;
  String? _activity;
  dynamic _actualQty;
  dynamic _uomName;
  String? _pathName;
  DataActivity6 copyWith({  num? inspectionStagesId,
  num? inspectionActivityId,
  num? tHJoId,
  num? mStatusinspectionstagesId,
  String? stagesName,
  String? transDate,
  String? remarks,
  String? startActivityTime,
  String? endActivityTime,
  String? activity,
  dynamic actualQty,
  dynamic uomName,
  String? pathName,
}) => DataActivity6(  inspectionStagesId: inspectionStagesId ?? _inspectionStagesId,
  inspectionActivityId: inspectionActivityId ?? _inspectionActivityId,
  tHJoId: tHJoId ?? _tHJoId,
  mStatusinspectionstagesId: mStatusinspectionstagesId ?? _mStatusinspectionstagesId,
  stagesName: stagesName ?? _stagesName,
  transDate: transDate ?? _transDate,
  remarks: remarks ?? _remarks,
  startActivityTime: startActivityTime ?? _startActivityTime,
  endActivityTime: endActivityTime ?? _endActivityTime,
  activity: activity ?? _activity,
  actualQty: actualQty ?? _actualQty,
  uomName: uomName ?? _uomName,
  pathName: pathName ?? _pathName,
);
  num? get inspectionStagesId => _inspectionStagesId;
  num? get inspectionActivityId => _inspectionActivityId;
  num? get tHJoId => _tHJoId;
  num? get mStatusinspectionstagesId => _mStatusinspectionstagesId;
  String? get stagesName => _stagesName;
  String? get transDate => _transDate;
  String? get remarks => _remarks;
  String? get startActivityTime => _startActivityTime;
  String? get endActivityTime => _endActivityTime;
  String? get activity => _activity;
  dynamic get actualQty => _actualQty;
  dynamic get uomName => _uomName;
  String? get pathName => _pathName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['inspection_stages_id'] = _inspectionStagesId;
    map['inspection_activity_id'] = _inspectionActivityId;
    map['t_h_jo_id'] = _tHJoId;
    map['m_statusinspectionstages_id'] = _mStatusinspectionstagesId;
    map['stages_name'] = _stagesName;
    map['trans_date'] = _transDate;
    map['remarks'] = _remarks;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['actual_qty'] = _actualQty;
    map['uom_name'] = _uomName;
    map['path_name'] = _pathName;
    return map;
  }

}