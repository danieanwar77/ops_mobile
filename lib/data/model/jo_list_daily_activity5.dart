import 'package:ops_mobile/data/model/jo_list_daily_activity.dart';

/// http_code : 200
/// data : {"detail":[{"inspection_stages_id":51,"inspection_activity_id":76,"trans_date":"2024-09-25","start_activity_time":null,"end_activity_time":null,"activity":"","actual_qty":25,"vessel":"V Master 1"}],"barge":[{"barge":"B chila 2"},{"barge":"B Chila 3"},{"barge":"B chila 4"},{"barge":"B child 1"},{"barge":"B Chilla 5"}],"transhipment":[{"initial_date":"2024-09-28","final_date":"2024-09-29","delivery_qty":20,"jetty":"jetty 1","name":"Case"}]}
/// message : "Success get activity"

class JoListDailyActivity5 {
  JoListDailyActivity5({
    num? httpCode,
    DataListActivity5? data,
    String? message,}){
    _httpCode = httpCode;
    _data = data;
    _message = message;
  }

  JoListDailyActivity5.fromJson(dynamic json) {
    _httpCode = json['http_code'];
    _data = json['data'] != null ? DataListActivity5.fromJson(json['data']) : null;
    _message = json['message'];
  }
  num? _httpCode;
  DataListActivity5? _data;
  String? _message;
  JoListDailyActivity5 copyWith({  num? httpCode,
    DataListActivity5? data,
    String? message,
  }) => JoListDailyActivity5(  httpCode: httpCode ?? _httpCode,
    data: data ?? _data,
    message: message ?? _message,
  );
  num? get httpCode => _httpCode;
  DataListActivity5? get data => _data;
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

/// detail : [{"inspection_stages_id":51,"inspection_activity_id":76,"trans_date":"2024-09-25","start_activity_time":null,"end_activity_time":null,"activity":"","actual_qty":25,"vessel":"V Master 1"}]
/// barge : [{"barge":"B chila 2"},{"barge":"B Chila 3"},{"barge":"B chila 4"},{"barge":"B child 1"},{"barge":"B Chilla 5"}]
/// transhipment : [{"initial_date":"2024-09-28","final_date":"2024-09-29","delivery_qty":20,"jetty":"jetty 1","name":"Case"}]

class DataListActivity5 {
  DataListActivity5({
    List<Detail>? detail,
    List<DataBarge>? barge,
    List<DataTranshipment>? transhipment,}){
    _detail = detail;
    _barge = barge;
    _transhipment = transhipment;
  }

  DataListActivity5.fromJson(dynamic json) {
    if (json['detail'] != null) {
      _detail = [];
      json['detail'].forEach((v) {
        _detail?.add(Detail.fromJson(v));
      });
    }
    if (json['barge'] != null) {
      _barge = [];
      json['barge'].forEach((v) {
        _barge?.add(DataBarge.fromJson(v));
      });
    }
    if (json['transhipment'] != null) {
      _transhipment = [];
      json['transhipment'].forEach((v) {
        _transhipment?.add(DataTranshipment.fromJson(v));
      });
    }
  }
  List<Detail>? _detail;
  List<DataBarge>? _barge;
  List<DataTranshipment>? _transhipment;
  DataListActivity5 copyWith({  List<Detail>? detail,
    List<DataBarge>? barge,
    List<DataTranshipment>? transhipment,
  }) => DataListActivity5(  detail: detail ?? _detail,
    barge: barge ?? _barge,
    transhipment: transhipment ?? _transhipment,
  );
  List<Detail>? get detail => _detail;
  List<DataBarge>? get barge => _barge;
  List<DataTranshipment>? get transhipment => _transhipment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_detail != null) {
      map['detail'] = _detail?.map((v) => v.toJson()).toList();
    }
    if (_barge != null) {
      map['barge'] = _barge?.map((v) => v.toJson()).toList();
    }
    if (_transhipment != null) {
      map['transhipment'] = _transhipment?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// initial_date : "2024-09-28"
/// final_date : "2024-09-29"
/// delivery_qty : 20
/// jetty : "jetty 1"
/// name : "Case"

class DataTranshipment {
  DataTranshipment({
    String? initialDate,
    String? finalDate,
    num? deliveryQty,
    String? jetty,
    String? name,}){
    _initialDate = initialDate;
    _finalDate = finalDate;
    _deliveryQty = deliveryQty;
    _jetty = jetty;
    _name = name;
  }

  DataTranshipment.fromJson(dynamic json) {
    _initialDate = json['initial_date'];
    _finalDate = json['final_date'];
    _deliveryQty = json['delivery_qty'];
    _jetty = json['jetty'];
    _name = json['name'];
  }
  String? _initialDate;
  String? _finalDate;
  num? _deliveryQty;
  String? _jetty;
  String? _name;
  DataTranshipment copyWith({  String? initialDate,
    String? finalDate,
    num? deliveryQty,
    String? jetty,
    String? name,
  }) => DataTranshipment(  initialDate: initialDate ?? _initialDate,
    finalDate: finalDate ?? _finalDate,
    deliveryQty: deliveryQty ?? _deliveryQty,
    jetty: jetty ?? _jetty,
    name: name ?? _name,
  );
  String? get initialDate => _initialDate;
  String? get finalDate => _finalDate;
  num? get deliveryQty => _deliveryQty;
  String? get jetty => _jetty;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['initial_date'] = _initialDate;
    map['final_date'] = _finalDate;
    map['delivery_qty'] = _deliveryQty;
    map['jetty'] = _jetty;
    map['name'] = _name;
    return map;
  }

}

/// barge : "B chila 2"

class DataBarge {
  DataBarge({
    String? barge,}){
    _barge = barge;
  }

  DataBarge.fromJson(dynamic json) {
    _barge = json['barge'];
  }
  String? _barge;
  DataBarge copyWith({  String? barge,
  }) => DataBarge(  barge: barge ?? _barge,
  );
  String? get barge => _barge;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['barge'] = _barge;
    return map;
  }

}

/// inspection_stages_id : 51
/// inspection_activity_id : 76
/// trans_date : "2024-09-25"
/// start_activity_time : null
/// end_activity_time : null
/// activity : ""
/// actual_qty : 25
/// vessel : "V Master 1"

class Detail {
  Detail({
    num? inspectionStagesId,
    num? inspectionActivityId,
    String? transDate,
    dynamic startActivityTime,
    dynamic endActivityTime,
    String? activity,
    num? actualQty,
    String? vessel,}){
    _inspectionStagesId = inspectionStagesId;
    _inspectionActivityId = inspectionActivityId;
    _transDate = transDate;
    _startActivityTime = startActivityTime;
    _endActivityTime = endActivityTime;
    _activity = activity;
    _actualQty = actualQty;
    _vessel = vessel;
  }

  Detail.fromJson(dynamic json) {
    _inspectionStagesId = json['inspection_stages_id'];
    _inspectionActivityId = json['inspection_activity_id'];
    _transDate = json['trans_date'];
    _startActivityTime = json['start_activity_time'];
    _endActivityTime = json['end_activity_time'];
    _activity = json['activity'];
    _actualQty = json['actual_qty'];
    _vessel = json['vessel'];
  }
  num? _inspectionStagesId;
  num? _inspectionActivityId;
  String? _transDate;
  dynamic _startActivityTime;
  dynamic _endActivityTime;
  String? _activity;
  num? _actualQty;
  String? _vessel;
  Detail copyWith({  num? inspectionStagesId,
    num? inspectionActivityId,
    String? transDate,
    dynamic startActivityTime,
    dynamic endActivityTime,
    String? activity,
    num? actualQty,
    String? vessel,
  }) => Detail(  inspectionStagesId: inspectionStagesId ?? _inspectionStagesId,
    inspectionActivityId: inspectionActivityId ?? _inspectionActivityId,
    transDate: transDate ?? _transDate,
    startActivityTime: startActivityTime ?? _startActivityTime,
    endActivityTime: endActivityTime ?? _endActivityTime,
    activity: activity ?? _activity,
    actualQty: actualQty ?? _actualQty,
    vessel: vessel ?? _vessel,
  );
  num? get inspectionStagesId => _inspectionStagesId;
  num? get inspectionActivityId => _inspectionActivityId;
  String? get transDate => _transDate;
  dynamic get startActivityTime => _startActivityTime;
  dynamic get endActivityTime => _endActivityTime;
  String? get activity => _activity;
  num? get actualQty => _actualQty;
  String? get vessel => _vessel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['inspection_stages_id'] = _inspectionStagesId;
    map['inspection_activity_id'] = _inspectionActivityId;
    map['trans_date'] = _transDate;
    map['start_activity_time'] = _startActivityTime;
    map['end_activity_time'] = _endActivityTime;
    map['activity'] = _activity;
    map['actual_qty'] = _actualQty;
    map['vessel'] = _vessel;
    return map;
  }

}