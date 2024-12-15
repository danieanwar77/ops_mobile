/// http_code : 200
/// data : {"detail":{"etta_vessel":"17-05-2024","start_date_of_attendance":"16-05-2024","end_date_of_attendance":"22-05-2024","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Pradibta Jayadi Agung","pic_inspector":"Aliastang"},"lab":[{"name":"Lab Evan Test Center"},{"name":"Lab o'riley"},{"name":"Lab Master Place"},{"name":"Lab UNISPA"},{"name":"Lab Evan Test Center"}],"assign_history":[{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"}]}
/// message : "Success detail JO"

class JoPicModel {
  JoPicModel({
      num? httpCode, 
      DataPIC? data, 
      String? message,}){
    _httpCode = httpCode;
    _data = data;
    _message = message;
}

  JoPicModel.fromJson(dynamic json) {
    _httpCode = json['http_code'];
    _data = json['data'] != null ? DataPIC.fromJson(json['data']) : null;
    _message = json['message'];
  }
  num? _httpCode;
  DataPIC? _data;
  String? _message;
JoPicModel copyWith({  num? httpCode,
  DataPIC? data,
  String? message,
}) => JoPicModel(  httpCode: httpCode ?? _httpCode,
  data: data ?? _data,
  message: message ?? _message,
);
  num? get httpCode => _httpCode;
  DataPIC? get data => _data;
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

/// detail : {"etta_vessel":"17-05-2024","start_date_of_attendance":"16-05-2024","end_date_of_attendance":"22-05-2024","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Pradibta Jayadi Agung","pic_inspector":"Aliastang"}
/// lab : [{"name":"Lab Evan Test Center"},{"name":"Lab o'riley"},{"name":"Lab Master Place"},{"name":"Lab UNISPA"},{"name":"Lab Evan Test Center"}]
/// assign_history : [{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"}]

class DataPIC {
  DataPIC({
      Detail? detail, 
      List<Lab>? lab, 
      List<AssignHistory>? assignHistory,}){
    _detail = detail;
    _lab = lab;
    _assignHistory = assignHistory;
}

  DataPIC.fromJson(dynamic json) {
    if(json['detail'] != null){
      _detail = Detail.fromJson(json['detail']);
    }else{
      _detail = null;
    }
    if (json['lab'] != null) {
      _lab = [];
      json['lab'].forEach((v) {
        _lab?.add(Lab.fromJson(v));
      });
    }
    if (json['assign_history'] != null) {
      _assignHistory = [];
      json['assign_history'].forEach((v) {
        _assignHistory?.add(AssignHistory.fromJson(v));
      });
    }
  }
  Detail? _detail;
  List<Lab>? _lab;
  List<AssignHistory>? _assignHistory;
DataPIC copyWith({  Detail? detail,
  List<Lab>? lab,
  List<AssignHistory>? assignHistory,
}) => DataPIC(  detail: detail ?? _detail,
  lab: lab ?? _lab,
  assignHistory: assignHistory ?? _assignHistory,
);
  Detail? get detail => _detail;
  List<Lab>? get lab => _lab;
  List<AssignHistory>? get assignHistory => _assignHistory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_detail != null) {
      map['detail'] = _detail?.toJson();
    }
    if (_lab != null) {
      map['lab'] = _lab?.map((v) => v.toJson()).toList();
    }
    if (_assignHistory != null) {
      map['assign_history'] = _assignHistory?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// assigned_date : "2024-07-10 09:33:22"
/// assign_by : "Mitha Robiatul Adawiyah"
/// remarks : "Testing inject by evan 3"
/// etta_vessel : "2024-05-17"
/// start_date_of_attendance : "2024-05-16"
/// end_date_of_attendance : "2024-05-22"
/// lokasi_kerja : "Palembang"
/// pic_laboratory : "Lara Fiona Rizki"
/// pic_inspector : "Ted Hariman Misor"

class AssignHistory {
  AssignHistory({
      String? assignedDate, 
      String? assignBy, 
      String? remarks, 
      String? ettaVessel, 
      String? startDateOfAttendance, 
      String? endDateOfAttendance, 
      String? lokasiKerja, 
      String? picLaboratory, 
      String? picInspector,}){
    _assignedDate = assignedDate;
    _assignBy = assignBy;
    _remarks = remarks;
    _ettaVessel = ettaVessel;
    _startDateOfAttendance = startDateOfAttendance;
    _endDateOfAttendance = endDateOfAttendance;
    _lokasiKerja = lokasiKerja;
    _picLaboratory = picLaboratory;
    _picInspector = picInspector;
}

  AssignHistory.fromJson(dynamic json) {
    _assignedDate = json['assigned_date'];
    _assignBy = json['assign_by'];
    _remarks = json['remarks'];
    _ettaVessel = json['etta_vessel'];
    _startDateOfAttendance = json['start_date_of_attendance'];
    _endDateOfAttendance = json['end_date_of_attendance'];
    _lokasiKerja = json['lokasi_kerja'];
    _picLaboratory = json['pic_laboratory'];
    _picInspector = json['pic_inspector'];
  }
  String? _assignedDate;
  String? _assignBy;
  String? _remarks;
  String? _ettaVessel;
  String? _startDateOfAttendance;
  String? _endDateOfAttendance;
  String? _lokasiKerja;
  String? _picLaboratory;
  String? _picInspector;
AssignHistory copyWith({  String? assignedDate,
  String? assignBy,
  String? remarks,
  String? ettaVessel,
  String? startDateOfAttendance,
  String? endDateOfAttendance,
  String? lokasiKerja,
  String? picLaboratory,
  String? picInspector,
}) => AssignHistory(  assignedDate: assignedDate ?? _assignedDate,
  assignBy: assignBy ?? _assignBy,
  remarks: remarks ?? _remarks,
  ettaVessel: ettaVessel ?? _ettaVessel,
  startDateOfAttendance: startDateOfAttendance ?? _startDateOfAttendance,
  endDateOfAttendance: endDateOfAttendance ?? _endDateOfAttendance,
  lokasiKerja: lokasiKerja ?? _lokasiKerja,
  picLaboratory: picLaboratory ?? _picLaboratory,
  picInspector: picInspector ?? _picInspector,
);
  String? get assignedDate => _assignedDate;
  String? get assignBy => _assignBy;
  String? get remarks => _remarks;
  String? get ettaVessel => _ettaVessel;
  String? get startDateOfAttendance => _startDateOfAttendance;
  String? get endDateOfAttendance => _endDateOfAttendance;
  String? get lokasiKerja => _lokasiKerja;
  String? get picLaboratory => _picLaboratory;
  String? get picInspector => _picInspector;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['assigned_date'] = _assignedDate;
    map['assign_by'] = _assignBy;
    map['remarks'] = _remarks;
    map['etta_vessel'] = _ettaVessel;
    map['start_date_of_attendance'] = _startDateOfAttendance;
    map['end_date_of_attendance'] = _endDateOfAttendance;
    map['lokasi_kerja'] = _lokasiKerja;
    map['pic_laboratory'] = _picLaboratory;
    map['pic_inspector'] = _picInspector;
    return map;
  }

}

/// name : "Lab Evan Test Center"

class Lab {
  Lab({
      String? name,}){
    _name = name;
}

  Lab.fromJson(dynamic json) {
    _name = json['name'];
  }
  String? _name;
Lab copyWith({  String? name,
}) => Lab(  name: name ?? _name,
);
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    return map;
  }

}

/// etta_vessel : "17-05-2024"
/// start_date_of_attendance : "16-05-2024"
/// end_date_of_attendance : "22-05-2024"
/// lokasi_kerja : "Tanjung Selor"
/// pic_laboratory : "Pradibta Jayadi Agung"
/// pic_inspector : "Aliastang"

class Detail {
  Detail({
      String? ettaVessel, 
      String? startDateOfAttendance, 
      String? endDateOfAttendance, 
      String? lokasiKerja, 
      String? picLaboratory, 
      String? picInspector,}){
    _ettaVessel = ettaVessel;
    _startDateOfAttendance = startDateOfAttendance;
    _endDateOfAttendance = endDateOfAttendance;
    _lokasiKerja = lokasiKerja;
    _picLaboratory = picLaboratory;
    _picInspector = picInspector;
}

  Detail.fromJson(dynamic json) {
    _ettaVessel = json['etta_vessel'];
    _startDateOfAttendance = json['start_date_of_attendance'];
    _endDateOfAttendance = json['end_date_of_attendance'];
    _lokasiKerja = json['lokasi_kerja'];
    _picLaboratory = json['pic_laboratory'];
    _picInspector = json['pic_inspector'];
  }
  String? _ettaVessel;
  String? _startDateOfAttendance;
  String? _endDateOfAttendance;
  String? _lokasiKerja;
  String? _picLaboratory;
  String? _picInspector;
Detail copyWith({  String? ettaVessel,
  String? startDateOfAttendance,
  String? endDateOfAttendance,
  String? lokasiKerja,
  String? picLaboratory,
  String? picInspector,
}) => Detail(  ettaVessel: ettaVessel ?? _ettaVessel,
  startDateOfAttendance: startDateOfAttendance ?? _startDateOfAttendance,
  endDateOfAttendance: endDateOfAttendance ?? _endDateOfAttendance,
  lokasiKerja: lokasiKerja ?? _lokasiKerja,
  picLaboratory: picLaboratory ?? _picLaboratory,
  picInspector: picInspector ?? _picInspector,
);
  String? get ettaVessel => _ettaVessel;
  String? get startDateOfAttendance => _startDateOfAttendance;
  String? get endDateOfAttendance => _endDateOfAttendance;
  String? get lokasiKerja => _lokasiKerja;
  String? get picLaboratory => _picLaboratory;
  String? get picInspector => _picInspector;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['etta_vessel'] = _ettaVessel;
    map['start_date_of_attendance'] = _startDateOfAttendance;
    map['end_date_of_attendance'] = _endDateOfAttendance;
    map['lokasi_kerja'] = _lokasiKerja;
    map['pic_laboratory'] = _picLaboratory;
    map['pic_inspector'] = _picInspector;
    return map;
  }

}