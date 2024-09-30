/// formDataArray : [{"t_h_jo_id":6,"m_statusinspectionstages_id":5,"uom_id":2,"trans_date":"2024-08-31","actual_qty":"10","created_by":0,"vessel":"Vessel 1","barge":[{"barge":"Barge 11"},{"barge":"Barge 2"}],"transhipment":[{"jetty":"Testing Alam","initial_date":"2024-09-01","final_date":"2024-09-02","delivery_qty":"3"}]}]

class JoActivity5 {
  JoActivity5({
      List<FormDataArray>? formDataArray,}){
    _formDataArray = formDataArray;
}

  JoActivity5.fromJson(dynamic json) {
    if (json['formDataArray'] != null) {
      _formDataArray = [];
      json['formDataArray'].forEach((v) {
        _formDataArray?.add(FormDataArray.fromJson(v));
      });
    }
  }
  List<FormDataArray>? _formDataArray;
JoActivity5 copyWith({  List<FormDataArray>? formDataArray,
}) => JoActivity5(  formDataArray: formDataArray ?? _formDataArray,
);
  List<FormDataArray>? get formDataArray => _formDataArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_formDataArray != null) {
      map['formDataArray'] = _formDataArray?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// t_h_jo_id : 6
/// m_statusinspectionstages_id : 5
/// uom_id : 2
/// trans_date : "2024-08-31"
/// actual_qty : "10"
/// created_by : 0
/// vessel : "Vessel 1"
/// barge : [{"barge":"Barge 11"},{"barge":"Barge 2"}]
/// transhipment : [{"jetty":"Testing Alam","initial_date":"2024-09-01","final_date":"2024-09-02","delivery_qty":"3"}]

class FormDataArray {
  FormDataArray({
      num? tHJoId, 
      num? mStatusinspectionstagesId, 
      num? uomId, 
      String? transDate, 
      String? actualQty, 
      num? createdBy, 
      String? vessel, 
      List<Barge>? barge, 
      List<Transhipment>? transhipment,}){
    _tHJoId = tHJoId;
    _mStatusinspectionstagesId = mStatusinspectionstagesId;
    _uomId = uomId;
    _transDate = transDate;
    _actualQty = actualQty;
    _createdBy = createdBy;
    _vessel = vessel;
    _barge = barge;
    _transhipment = transhipment;
}

  FormDataArray.fromJson(dynamic json) {
    _tHJoId = json['t_h_jo_id'];
    _mStatusinspectionstagesId = json['m_statusinspectionstages_id'];
    _uomId = json['uom_id'];
    _transDate = json['trans_date'];
    _actualQty = json['actual_qty'];
    _createdBy = json['created_by'];
    _vessel = json['vessel'];
    if (json['barge'] != null) {
      _barge = [];
      json['barge'].forEach((v) {
        _barge?.add(Barge.fromJson(v));
      });
    }
    if (json['transhipment'] != null) {
      _transhipment = [];
      json['transhipment'].forEach((v) {
        _transhipment?.add(Transhipment.fromJson(v));
      });
    }
  }
  num? _tHJoId;
  num? _mStatusinspectionstagesId;
  num? _uomId;
  String? _transDate;
  String? _actualQty;
  num? _createdBy;
  String? _vessel;
  List<Barge>? _barge;
  List<Transhipment>? _transhipment;
FormDataArray copyWith({  num? tHJoId,
  num? mStatusinspectionstagesId,
  num? uomId,
  String? transDate,
  String? actualQty,
  num? createdBy,
  String? vessel,
  List<Barge>? barge,
  List<Transhipment>? transhipment,
}) => FormDataArray(  tHJoId: tHJoId ?? _tHJoId,
  mStatusinspectionstagesId: mStatusinspectionstagesId ?? _mStatusinspectionstagesId,
  uomId: uomId ?? _uomId,
  transDate: transDate ?? _transDate,
  actualQty: actualQty ?? _actualQty,
  createdBy: createdBy ?? _createdBy,
  vessel: vessel ?? _vessel,
  barge: barge ?? _barge,
  transhipment: transhipment ?? _transhipment,
);
  num? get tHJoId => _tHJoId;
  num? get mStatusinspectionstagesId => _mStatusinspectionstagesId;
  num? get uomId => _uomId;
  String? get transDate => _transDate;
  String? get actualQty => _actualQty;
  num? get createdBy => _createdBy;
  String? get vessel => _vessel;
  List<Barge>? get barge => _barge;
  List<Transhipment>? get transhipment => _transhipment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['t_h_jo_id'] = _tHJoId;
    map['m_statusinspectionstages_id'] = _mStatusinspectionstagesId;
    map['uom_id'] = _uomId;
    map['trans_date'] = _transDate;
    map['actual_qty'] = _actualQty;
    map['created_by'] = _createdBy;
    map['vessel'] = _vessel;
    if (_barge != null) {
      map['barge'] = _barge?.map((v) => v.toJson()).toList();
    }
    if (_transhipment != null) {
      map['transhipment'] = _transhipment?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// jetty : "Testing Alam"
/// initial_date : "2024-09-01"
/// final_date : "2024-09-02"
/// delivery_qty : "3"

class Transhipment {
  Transhipment({
      String? jetty, 
      String? initialDate, 
      String? finalDate, 
      String? deliveryQty,}){
    _jetty = jetty;
    _initialDate = initialDate;
    _finalDate = finalDate;
    _deliveryQty = deliveryQty;
}

  Transhipment.fromJson(dynamic json) {
    _jetty = json['jetty'];
    _initialDate = json['initial_date'];
    _finalDate = json['final_date'];
    _deliveryQty = json['delivery_qty'];
  }
  String? _jetty;
  String? _initialDate;
  String? _finalDate;
  String? _deliveryQty;
Transhipment copyWith({  String? jetty,
  String? initialDate,
  String? finalDate,
  String? deliveryQty,
}) => Transhipment(  jetty: jetty ?? _jetty,
  initialDate: initialDate ?? _initialDate,
  finalDate: finalDate ?? _finalDate,
  deliveryQty: deliveryQty ?? _deliveryQty,
);
  String? get jetty => _jetty;
  String? get initialDate => _initialDate;
  String? get finalDate => _finalDate;
  String? get deliveryQty => _deliveryQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['jetty'] = _jetty;
    map['initial_date'] = _initialDate;
    map['final_date'] = _finalDate;
    map['delivery_qty'] = _deliveryQty;
    return map;
  }

}

/// barge : "Barge 11"

class Barge {
  Barge({
      String? barge,}){
    _barge = barge;
}

  Barge.fromJson(dynamic json) {
    _barge = json['barge'];
  }
  String? _barge;
Barge copyWith({  String? barge,
}) => Barge(  barge: barge ?? _barge,
);
  String? get barge => _barge;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['barge'] = _barge;
    return map;
  }

}