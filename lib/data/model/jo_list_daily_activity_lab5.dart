/// http_code : 200
/// data : {"current_page":1,"data":[{"laboratory_stages_id":22,"laboratory_activity_id":42,"d_jo_laboratory_id":6,"m_statuslaboratoryprogres_id":5,"stages_name":"Issued Analyze Result","trans_date":"2024-09-04","remarks":null,"start_activity_time":"10:00:00","end_activity_time":null,"activity":"","laboratorium_name":"Lab Evan Test Center"}],"first_page_url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_laboratory/activity_5/6?page=1","from":1,"last_page":1,"last_page_url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_laboratory/activity_5/6?page=1","links":[{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_laboratory/activity_5/6?page=1","label":"1","active":true},{"url":null,"label":"Next &raquo;","active":false}],"next_page_url":null,"path":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_laboratory/activity_5/6","per_page":10,"prev_page_url":null,"to":1,"total":1}
/// message : "Success get activity"

class JoListDailyActivityLab5 {
  JoListDailyActivityLab5({
      num? httpCode,
      DataListActivityLab5? data,
      String? message,}){
    _httpCode = httpCode;
    _data = data;
    _message = message;
}

  JoListDailyActivityLab5.fromJson(dynamic json) {
    _httpCode = json['http_code'];
    _data = json['data'] != null ? DataListActivityLab5.fromJson(json['data']) : null;
    _message = json['message'];
  }
  num? _httpCode;
  DataListActivityLab5? _data;
  String? _message;
JoListDailyActivityLab5 copyWith({  num? httpCode,
  DataListActivityLab5? data,
  String? message,
}) => JoListDailyActivityLab5(  httpCode: httpCode ?? _httpCode,
  data: data ?? _data,
  message: message ?? _message,
);
  num? get httpCode => _httpCode;
  DataListActivityLab5? get data => _data;
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
/// data : [{"laboratory_stages_id":22,"laboratory_activity_id":42,"d_jo_laboratory_id":6,"m_statuslaboratoryprogres_id":5,"stages_name":"Issued Analyze Result","trans_date":"2024-09-04","remarks":null,"start_activity_time":"10:00:00","end_activity_time":null,"activity":"","laboratorium_name":"Lab Evan Test Center"}]
/// first_page_url : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_laboratory/activity_5/6?page=1"
/// from : 1
/// last_page : 1
/// last_page_url : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_laboratory/activity_5/6?page=1"
/// links : [{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_laboratory/activity_5/6?page=1","label":"1","active":true},{"url":null,"label":"Next &raquo;","active":false}]
/// next_page_url : null
/// path : "https://tbi-ops-dev.intishaka.com/api/transaksi/jo/progress_daily_laboratory/activity_5/6"
/// per_page : 10
/// prev_page_url : null
/// to : 1
/// total : 1

class DataListActivityLab5 {
  DataListActivityLab5({
      num? currentPage, 
      List<DataActivityLab5>? data,
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

  DataListActivityLab5.fromJson(dynamic json) {
    _currentPage = json['current_page'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DataActivityLab5.fromJson(v));
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
  List<DataActivityLab5>? _data;
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
  DataListActivityLab5 copyWith({  num? currentPage,
  List<DataActivityLab5>? data,
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
}) => DataListActivityLab5(  currentPage: currentPage ?? _currentPage,
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
  List<DataActivityLab5>? get data => _data;
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

/// laboratory_stages_id : 22
/// laboratory_activity_id : 42
/// d_jo_laboratory_id : 6
/// m_statuslaboratoryprogres_id : 5
/// stages_name : "Issued Analyze Result"
/// trans_date : "2024-09-04"
/// remarks : null
/// start_activity_time : "10:00:00"
/// end_activity_time : null
/// activity : ""
/// laboratorium_name : "Lab Evan Test Center"

class DataActivityLab5 {
  DataActivityLab5({
    num? laboratoryStagesId,
    num? laboratoryActivityId,
    num? dJoLaboratoryId,
    num? mStatuslaboratoryprogresId,
    String? stagesName,
    String? transDate,
    dynamic remarks,
    String? startActivityTime,
    String? endActivityTime,
    String? activity,
    num? totalSampleReceived,
    num? totalSampleAnalyzed,
    num? totalSamplePreparation,
    String? laboratoriumName,}){
    _laboratoryStagesId = laboratoryStagesId;
    _laboratoryActivityId = laboratoryActivityId;
    _dJoLaboratoryId = dJoLaboratoryId;
    _mStatuslaboratoryprogresId = mStatuslaboratoryprogresId;
    _stagesName = stagesName;
    _transDate = transDate;
    _remarks = remarks;
    _startActivityTime = startActivityTime;
    _endActivityTime = endActivityTime;
    _activity = activity;
    _totalSampleReceived = totalSampleReceived;
    _totalSampleAnalyzed = totalSampleAnalyzed;
    _totalSamplePreparation = totalSamplePreparation;
    _laboratoriumName = laboratoriumName;
  }

  DataActivityLab5.fromJson(dynamic json) {
    _laboratoryStagesId = json['laboratory_stages_id'];
    _laboratoryActivityId = json['laboratory_activity_id'];
    _dJoLaboratoryId = json['d_jo_laboratory_id'];
    _mStatuslaboratoryprogresId = json['m_statuslaboratoryprogres_id'];
    _stagesName = json['stages_name'];
    _transDate = json['trans_date'];
    _remarks = json['remarks'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _activity = json['activity'];
    _totalSampleReceived = json['total_sample_received'];
    _totalSampleAnalyzed = json['total_sample_analyzed'];
    _totalSamplePreparation = json['total_sample_preparation'];
    _laboratoriumName = json['laboratorium_name'];
  }
  num? _laboratoryStagesId;
  num? _laboratoryActivityId;
  num? _dJoLaboratoryId;
  num? _mStatuslaboratoryprogresId;
  String? _stagesName;
  String? _transDate;
  dynamic _remarks;
  String? _startActivityTime;
  String? _endActivityTime;
  String? _activity;
  num? _totalSampleReceived;
  num? _totalSampleAnalyzed;
  num? _totalSamplePreparation;
  String? _laboratoriumName;
  DataActivityLab5 copyWith({  num? laboratoryStagesId,
    num? laboratoryActivityId,
    num? dJoLaboratoryId,
    num? mStatuslaboratoryprogresId,
    String? stagesName,
    String? transDate,
    dynamic remarks,
    String? startActivityTime,
    String? endActivityTime,
    String? activity,
    num? totalSampleReceived,
    num? totalSampleAnalyzed,
    num? totalSamplePreparation,
    String? laboratoriumName,
  }) => DataActivityLab5(  laboratoryStagesId: laboratoryStagesId ?? _laboratoryStagesId,
    laboratoryActivityId: laboratoryActivityId ?? _laboratoryActivityId,
    dJoLaboratoryId: dJoLaboratoryId ?? _dJoLaboratoryId,
    mStatuslaboratoryprogresId: mStatuslaboratoryprogresId ?? _mStatuslaboratoryprogresId,
    stagesName: stagesName ?? _stagesName,
    transDate: transDate ?? _transDate,
    remarks: remarks ?? _remarks,
    startActivityTime: startActivityTime ?? _startActivityTime,
    endActivityTime: endActivityTime ?? _endActivityTime,
    activity: activity ?? _activity,
    totalSampleReceived: totalSampleReceived ?? _totalSampleReceived,
    totalSampleAnalyzed: totalSampleAnalyzed ?? _totalSampleAnalyzed,
    totalSamplePreparation: totalSamplePreparation ?? _totalSamplePreparation,
    laboratoriumName: laboratoriumName ?? _laboratoriumName,
  );
  num? get laboratoryStagesId => _laboratoryStagesId;
  num? get laboratoryActivityId => _laboratoryActivityId;
  num? get dJoLaboratoryId => _dJoLaboratoryId;
  num? get mStatuslaboratoryprogresId => _mStatuslaboratoryprogresId;
  String? get stagesName => _stagesName;
  String? get transDate => _transDate;
  dynamic get remarks => _remarks;
  String? get startActivityTime => _startActivityTime;
  String? get endActivityTime => _endActivityTime;
  String? get activity => _activity;
  num? get totalSampleReceived => _totalSampleReceived;
  num? get totalSampleAnalyzed => _totalSampleAnalyzed;
  num? get totalSamplePreparation => _totalSamplePreparation;
  String? get laboratoriumName => _laboratoriumName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['laboratory_stages_id'] = _laboratoryStagesId;
    map['laboratory_activity_id'] = _laboratoryActivityId;
    map['d_jo_laboratory_id'] = _dJoLaboratoryId;
    map['m_statuslaboratoryprogres_id'] = _mStatuslaboratoryprogresId;
    map['stages_name'] = _stagesName;
    map['trans_date'] = _transDate;
    map['remarks'] = _remarks;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['total_sample_received'] = _totalSampleReceived;
    map['total_sample_analyzed'] = _totalSampleAnalyzed;
    map['total_sample_preparation'] = _totalSamplePreparation;
    map['laboratorium_name'] = _laboratoriumName;
    return map;
  }

}