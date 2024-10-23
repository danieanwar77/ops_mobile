/// http_code : 200
/// data : {"current_page":1,"data":[{"inspection_stages_id":28,"inspection_activity_id":60,"t_h_jo_id":7,"m_statusinspectionstages_id":1,"stages_name":"Waiting For Arrival","trans_date":"2024-08-26","remarks":"Di infokan kapal pasti datang","start_activity_time":"16:05:00","end_activity_time":"16:20:00","activity":"Ada rumor kapal datang","actual_qty":null},{"inspection_stages_id":28,"inspection_activity_id":59,"t_h_jo_id":7,"m_statusinspectionstages_id":1,"stages_name":"Waiting For Arrival","trans_date":"2024-08-26","remarks":"Di infokan kapal pasti datang","start_activity_time":"16:00:00","end_activity_time":"16:15:00","activity":"Istirahat Makan dan ngopi sore","actual_qty":null},{"inspection_stages_id":28,"inspection_activity_id":50,"t_h_jo_id":7,"m_statusinspectionstages_id":1,"stages_name":"Waiting For Arrival","trans_date":"2024-08-26","remarks":"Di infokan kapal pasti datang","start_activity_time":"15:00:00","end_activity_time":"16:00:00","activity":"Menunggu Kedatangan Kapal","actual_qty":null},{"inspection_stages_id":29,"inspection_activity_id":51,"t_h_jo_id":7,"m_statusinspectionstages_id":2,"stages_name":"Ship Arrived","trans_date":"2024-08-27","remarks":"Kapal sampai tujuan, tapi hampir karam","start_activity_time":"10:00:00","end_activity_time":"12:00:00","activity":"Kapal baru sampai","actual_qty":null},{"inspection_stages_id":30,"inspection_activity_id":61,"t_h_jo_id":7,"m_statusinspectionstages_id":3,"stages_name":"Ship Berthing","trans_date":"2024-08-30","remarks":"Kapal mulai sampai ke pelabuhan","start_activity_time":"15:00:00","end_activity_time":"16:15:00","activity":"Kapal sampai, melakukan pengecekan perkapalan","actual_qty":null},{"inspection_stages_id":30,"inspection_activity_id":52,"t_h_jo_id":7,"m_statusinspectionstages_id":3,"stages_name":"Ship Berthing","trans_date":"2024-08-30","remarks":"Kapal mulai sampai ke pelabuhan","start_activity_time":"12:00:00","end_activity_time":"16:00:00","activity":"Koordinasi dengan tim kapal, agar kapal tidak karam","actual_qty":null},{"inspection_stages_id":31,"inspection_activity_id":53,"t_h_jo_id":7,"m_statusinspectionstages_id":4,"stages_name":"Work Commence","trans_date":"2024-08-31","remarks":"Pekerjaan dimulai","start_activity_time":"08:00:00","end_activity_time":"17:00:00","activity":"Melakukan pekerjaan perkapalan","actual_qty":null},{"inspection_stages_id":31,"inspection_activity_id":62,"t_h_jo_id":7,"m_statusinspectionstages_id":4,"stages_name":"Work Commence","trans_date":"2024-08-31","remarks":"Pekerjaan dimulai","start_activity_time":"12:00:00","end_activity_time":"13:00:00","activity":"Break Makan dan ngopi siang","actual_qty":null},{"inspection_stages_id":38,"inspection_activity_id":64,"t_h_jo_id":7,"m_statusinspectionstages_id":5,"stages_name":"Work Complete","trans_date":"2024-09-02","remarks":"Pekerjaan selesai ya","start_activity_time":"14:00:00","end_activity_time":"15:37:00","activity":"Penyempurnaan paket, wrapping di buat lagi","actual_qty":137},{"inspection_stages_id":39,"inspection_activity_id":66,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"12:00:00","end_activity_time":"13:51:00","activity":"Penyococokan laporan dengan data aktual lapangan","actual_qty":null}],"first_page_url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7?page=1","from":1,"last_page":2,"last_page_url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7?page=2","links":[{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7?page=1","label":"1","active":true},{"url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7?page=2","label":"2","active":false},{"url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7?page=2","label":"Next &raquo;","active":false}],"next_page_url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7?page=2","path":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7","per_page":10,"prev_page_url":null,"to":10,"total":12}
/// message : "Success get activity"

class JoListDailyActivity {
  JoListDailyActivity({
      num? httpCode, 
      DataListActivity? data, 
      String? message,}){
    _httpCode = httpCode;
    _data = data;
    _message = message;
}

  JoListDailyActivity.fromJson(dynamic json) {
    _httpCode = json['http_code'];
    _data = json['data'] != null ? DataListActivity.fromJson(json['data']) : null;
    _message = json['message'];
  }
  num? _httpCode;
  DataListActivity? _data;
  String? _message;
JoListDailyActivity copyWith({  num? httpCode,
  DataListActivity? data,
  String? message,
}) => JoListDailyActivity(  httpCode: httpCode ?? _httpCode,
  data: data ?? _data,
  message: message ?? _message,
);
  num? get httpCode => _httpCode;
  DataListActivity? get data => _data;
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
/// data : [{"inspection_stages_id":28,"inspection_activity_id":60,"t_h_jo_id":7,"m_statusinspectionstages_id":1,"stages_name":"Waiting For Arrival","trans_date":"2024-08-26","remarks":"Di infokan kapal pasti datang","start_activity_time":"16:05:00","end_activity_time":"16:20:00","activity":"Ada rumor kapal datang","actual_qty":null},{"inspection_stages_id":28,"inspection_activity_id":59,"t_h_jo_id":7,"m_statusinspectionstages_id":1,"stages_name":"Waiting For Arrival","trans_date":"2024-08-26","remarks":"Di infokan kapal pasti datang","start_activity_time":"16:00:00","end_activity_time":"16:15:00","activity":"Istirahat Makan dan ngopi sore","actual_qty":null},{"inspection_stages_id":28,"inspection_activity_id":50,"t_h_jo_id":7,"m_statusinspectionstages_id":1,"stages_name":"Waiting For Arrival","trans_date":"2024-08-26","remarks":"Di infokan kapal pasti datang","start_activity_time":"15:00:00","end_activity_time":"16:00:00","activity":"Menunggu Kedatangan Kapal","actual_qty":null},{"inspection_stages_id":29,"inspection_activity_id":51,"t_h_jo_id":7,"m_statusinspectionstages_id":2,"stages_name":"Ship Arrived","trans_date":"2024-08-27","remarks":"Kapal sampai tujuan, tapi hampir karam","start_activity_time":"10:00:00","end_activity_time":"12:00:00","activity":"Kapal baru sampai","actual_qty":null},{"inspection_stages_id":30,"inspection_activity_id":61,"t_h_jo_id":7,"m_statusinspectionstages_id":3,"stages_name":"Ship Berthing","trans_date":"2024-08-30","remarks":"Kapal mulai sampai ke pelabuhan","start_activity_time":"15:00:00","end_activity_time":"16:15:00","activity":"Kapal sampai, melakukan pengecekan perkapalan","actual_qty":null},{"inspection_stages_id":30,"inspection_activity_id":52,"t_h_jo_id":7,"m_statusinspectionstages_id":3,"stages_name":"Ship Berthing","trans_date":"2024-08-30","remarks":"Kapal mulai sampai ke pelabuhan","start_activity_time":"12:00:00","end_activity_time":"16:00:00","activity":"Koordinasi dengan tim kapal, agar kapal tidak karam","actual_qty":null},{"inspection_stages_id":31,"inspection_activity_id":53,"t_h_jo_id":7,"m_statusinspectionstages_id":4,"stages_name":"Work Commence","trans_date":"2024-08-31","remarks":"Pekerjaan dimulai","start_activity_time":"08:00:00","end_activity_time":"17:00:00","activity":"Melakukan pekerjaan perkapalan","actual_qty":null},{"inspection_stages_id":31,"inspection_activity_id":62,"t_h_jo_id":7,"m_statusinspectionstages_id":4,"stages_name":"Work Commence","trans_date":"2024-08-31","remarks":"Pekerjaan dimulai","start_activity_time":"12:00:00","end_activity_time":"13:00:00","activity":"Break Makan dan ngopi siang","actual_qty":null},{"inspection_stages_id":38,"inspection_activity_id":64,"t_h_jo_id":7,"m_statusinspectionstages_id":5,"stages_name":"Work Complete","trans_date":"2024-09-02","remarks":"Pekerjaan selesai ya","start_activity_time":"14:00:00","end_activity_time":"15:37:00","activity":"Penyempurnaan paket, wrapping di buat lagi","actual_qty":137},{"inspection_stages_id":39,"inspection_activity_id":66,"t_h_jo_id":7,"m_statusinspectionstages_id":6,"stages_name":"Report to client","trans_date":"2024-09-04","remarks":"Draft survey dikirim ke client","start_activity_time":"12:00:00","end_activity_time":"13:51:00","activity":"Penyococokan laporan dengan data aktual lapangan","actual_qty":null}]
/// first_page_url : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7?page=1"
/// from : 1
/// last_page : 2
/// last_page_url : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7?page=2"
/// links : [{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7?page=1","label":"1","active":true},{"url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7?page=2","label":"2","active":false},{"url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7?page=2","label":"Next &raquo;","active":false}]
/// next_page_url : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7?page=2"
/// path : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_activity/activity/7"
/// per_page : 10
/// prev_page_url : null
/// to : 10
/// total : 12

class DataListActivity {
  DataListActivity({
      num? currentPage, 
      List<DataActivity>? data, 
      String? firstPageUrl, 
      num? from, 
      num? lastPage, 
      String? lastPageUrl, 
      List<Links>? links, 
      String? nextPageUrl, 
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

  DataListActivity.fromJson(dynamic json) {
    _currentPage = json['current_page'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DataActivity.fromJson(v));
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
  List<DataActivity>? _data;
  String? _firstPageUrl;
  num? _from;
  num? _lastPage;
  String? _lastPageUrl;
  List<Links>? _links;
  String? _nextPageUrl;
  String? _path;
  num? _perPage;
  dynamic _prevPageUrl;
  num? _to;
  num? _total;
  DataListActivity copyWith({  num? currentPage,
  List<DataActivity>? data,
  String? firstPageUrl,
  num? from,
  num? lastPage,
  String? lastPageUrl,
  List<Links>? links,
  String? nextPageUrl,
  String? path,
  num? perPage,
  dynamic prevPageUrl,
  num? to,
  num? total,
}) => DataListActivity(  currentPage: currentPage ?? _currentPage,
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
  List<DataActivity>? get data => _data;
  String? get firstPageUrl => _firstPageUrl;
  num? get from => _from;
  num? get lastPage => _lastPage;
  String? get lastPageUrl => _lastPageUrl;
  List<Links>? get links => _links;
  String? get nextPageUrl => _nextPageUrl;
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

/// inspection_stages_id : 28
/// inspection_activity_id : 60
/// t_h_jo_id : 7
/// m_statusinspectionstages_id : 1
/// stages_name : "Waiting For Arrival"
/// trans_date : "2024-08-26"
/// remarks : "Di infokan kapal pasti datang"
/// start_activity_time : "16:05:00"
/// end_activity_time : "16:20:00"
/// activity : "Ada rumor kapal datang"
/// actual_qty : null

class DataActivity {
  DataActivity({
      num? inspectionStagesId, 
      num? inspectionActivityId,
      String? code,
      num? tHJoId,
      String? stageCode,
      num? mStatusinspectionstagesId, 
      String? stagesName, 
      String? transDate, 
      String? remarks, 
      String? startActivityTime, 
      String? endActivityTime, 
      String? activity,
      num? createdBy,
      dynamic actualQty,
      String? createdAt,
      num? updatedBy,
      String? updatedAt,
      num? isActive,
      num? isUpload,}){
    _inspectionStagesId = inspectionStagesId;
    _inspectionActivityId = inspectionActivityId;
    _code = code;
    _tHJoId = tHJoId;
    _stageCode = stageCode;
    _mStatusinspectionstagesId = mStatusinspectionstagesId;
    _stagesName = stagesName;
    _transDate = transDate;
    _remarks = remarks;
    _startActivityTime = startActivityTime;
    _endActivityTime = endActivityTime;
    _activity = activity;
    _createdBy = createdBy;
    _actualQty = actualQty;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
    _isActive = isActive;
    _isUpload = isUpload;
}

  DataActivity.fromJson(dynamic json) {
    _inspectionStagesId = json['inspection_stages_id'];
    _inspectionActivityId = json['inspection_activity_id'];
    _code = json['code'];
    _tHJoId = json['t_h_jo_id'];
    _stageCode = json['stage_code'];
    _mStatusinspectionstagesId = json['m_statusinspectionstages_id'];
    _stagesName = json['stages_name'];
    _transDate = json['trans_date'];
    _remarks = json['remarks'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _activity = json['activity'];
    _createdBy = json['created_by'];
    _actualQty = json['actual_qty'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
  }
  num? _inspectionStagesId;
  num? _inspectionActivityId;
  String? _code;
  num? _tHJoId;
  String? _stageCode;
  num? _mStatusinspectionstagesId;
  String? _stagesName;
  String? _transDate;
  String? _remarks;
  String? _startActivityTime;
  String? _endActivityTime;
  String? _activity;
  num? _createdBy;
  dynamic _actualQty;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
  num? _isActive;
  num? _isUpload;
  DataActivity copyWith({   num? inspectionStagesId,
  num? inspectionActivityId,
  String? code,
  num? tHJoId,
  String? stageCode,
  num? mStatusinspectionstagesId,
  String? stagesName,
  String? transDate,
  String? remarks,
  String? startActivityTime,
  String? endActivityTime,
  String? activity,
  num? createdBy,
  dynamic actualQty,
  String? createdAt,
  num? updatedBy,
  String? updatedAt,
  num? isActive,
  num? isUpload,
  }) => DataActivity(  inspectionStagesId: inspectionStagesId ?? _inspectionStagesId,
  inspectionActivityId: inspectionActivityId ?? _inspectionActivityId,
  code: code ?? _code,
  tHJoId: tHJoId ?? _tHJoId,
  stageCode: stageCode ?? _stageCode,
  mStatusinspectionstagesId: mStatusinspectionstagesId ?? _mStatusinspectionstagesId,
  stagesName: stagesName ?? _stagesName,
  transDate: transDate ?? _transDate,
  remarks: remarks ?? _remarks,
  startActivityTime: startActivityTime ?? _startActivityTime,
  endActivityTime: endActivityTime ?? _endActivityTime,
  activity: activity ?? _activity,
  createdBy: createdBy ?? _createdBy,
  actualQty: actualQty ?? _actualQty,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
);
  num? get inspectionStagesId => _inspectionStagesId;
  num? get inspectionActivityId => _inspectionActivityId;
  String? get code => _code;
  num? get tHJoId => _tHJoId;
  String? get stageCode => _stageCode;
  num? get mStatusinspectionstagesId => _mStatusinspectionstagesId;
  String? get stagesName => _stagesName;
  String? get transDate => _transDate;
  String? get remarks => _remarks;
  String? get startActivityTime => _startActivityTime;
  String? get endActivityTime => _endActivityTime;
  String? get activity => _activity;
  num? get createdBy => _createdBy;
  dynamic get actualQty => _actualQty;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['inspection_stages_id'] = _inspectionStagesId;
    map['inspection_activity_id'] = _inspectionActivityId;
    map['code'] = _code;
    map['t_h_jo_id'] = _tHJoId;
    map['stage_code'] = _stageCode;
    map['m_statusinspectionstages_id'] = _mStatusinspectionstagesId;
    map['stages_name'] = _stagesName;
    map['trans_date'] = _transDate;
    map['remarks'] = _remarks;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['created_by'] = _createdBy;
    map['actual_qty'] = _actualQty;
    map['created_at'] = createdAt;
    map['updated_by'] = updatedBy;
    map['updated_at'] = updatedAt;
    map['is_active'] = isActive;
    map['is_upload'] = isUpload;
    return map;
  }

}