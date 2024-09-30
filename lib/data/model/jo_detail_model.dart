/// http_code : 200
/// data : {"detail":{"id":7,"so_code":"0005/SO/04/2024","code":"JO7","canceled_date":"2024-07-10","so_created_at":"2024-04-05 15:45:23","jo_created_at":"2024-05-15 12:44:05","status_jo":"On Progres","company_name":"Bumi Nusantara Jaya","m_client_category_name":"Existing Client","project_tittle":"Master protect","region":"Jawa","branch":"Jakarta","site_office":null,"survey_location":"Port of Vanaheim","country_survey":"Indonesia","province_survey":"Jakarta Utara\t","city_survey":"Penjaringan","loading_port":"Port of Midgard","loading_port_country":"Indonesia","loading_port_province":"Jakarta Utara\t","loading_port_city":"Penjaringan","discharge_port":"Port of Jotun","discharge_port_country":"Indonesia","discharge_port_province":"Jakarta Utara\t","discharge_port_city":"Penjaringan","supplier_name":null,"trader1_name":"Bumi Nusantara Jaya","trader2_name":"PT Evan Bersama","trader3_name":"PT Evan Bersama","end_buyer_name":"PT Suara Sembar Jaya","notes":null,"sbu_name":"Agri","commodity_name":"Cooking coal","etta_vessel":"17-05-2024","start_date_of_attendance":"16-05-2024","end_date_of_attendance":"22-05-2024","lokasi_kerja":null,"pic_laboratory":"Pradibta Jayadi Agung","pic_inspector":"Aliastang","destination_country":"Indonesia","destination_category_name":"Domestic","job_category_name":"Domestic Contract","kos_name":"Quantity Control Management of stockpile","vessel":"Utama Bersama","qty":5,"uom_name":"Case","jo_created_date":"2024-05-15 12:44:05","barge":"Barge Bersama 1|Barge Bersama 2|Barge Deh","market_segment_name":"NICKEL","sub_market_segment_name":"Fero Nickel"},"sow":[{"name":"To report physical condition of cargo and provide continuous daily updates detailing all relevant loading activities, including photographs","id":9},{"name":"To report physical condition of cargo and provide continuous daily updates detailing all relevant loading activities, including photographs","id":9}],"oos":[{"name":"Certificate of Quality","id":9},{"name":"Certificate of Quality","id":9}],"lap":[{"name":"Ash Analysis","id":9},{"name":"Ash Analysis","id":9}],"std_method":[{"name":"AOCS Ca 3a-46","id":25}],"pic_hist":[{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"}]}
/// message : "Success detail JO"

class JoDetailModel {
  JoDetailModel({
      num? httpCode, 
      DataDetail? data, 
      String? message,}){
    _httpCode = httpCode;
    _data = data;
    _message = message;
}

  JoDetailModel.fromJson(dynamic json) {
    _httpCode = json['http_code'];
    _data = json['data'] != null ? DataDetail.fromJson(json['data']) : null;
    _message = json['message'];
  }
  num? _httpCode;
  DataDetail? _data;
  String? _message;
JoDetailModel copyWith({  num? httpCode,
  DataDetail? data,
  String? message,
}) => JoDetailModel(  httpCode: httpCode ?? _httpCode,
  data: data ?? _data,
  message: message ?? _message,
);
  num? get httpCode => _httpCode;
  DataDetail? get data => _data;
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

/// detail : {"id":7,"so_code":"0005/SO/04/2024","code":"JO7","canceled_date":"2024-07-10","so_created_at":"2024-04-05 15:45:23","jo_created_at":"2024-05-15 12:44:05","status_jo":"On Progres","company_name":"Bumi Nusantara Jaya","m_client_category_name":"Existing Client","project_tittle":"Master protect","region":"Jawa","branch":"Jakarta","site_office":null,"survey_location":"Port of Vanaheim","country_survey":"Indonesia","province_survey":"Jakarta Utara\t","city_survey":"Penjaringan","loading_port":"Port of Midgard","loading_port_country":"Indonesia","loading_port_province":"Jakarta Utara\t","loading_port_city":"Penjaringan","discharge_port":"Port of Jotun","discharge_port_country":"Indonesia","discharge_port_province":"Jakarta Utara\t","discharge_port_city":"Penjaringan","supplier_name":null,"trader1_name":"Bumi Nusantara Jaya","trader2_name":"PT Evan Bersama","trader3_name":"PT Evan Bersama","end_buyer_name":"PT Suara Sembar Jaya","notes":null,"sbu_name":"Agri","commodity_name":"Cooking coal","etta_vessel":"17-05-2024","start_date_of_attendance":"16-05-2024","end_date_of_attendance":"22-05-2024","lokasi_kerja":null,"pic_laboratory":"Pradibta Jayadi Agung","pic_inspector":"Aliastang","destination_country":"Indonesia","destination_category_name":"Domestic","job_category_name":"Domestic Contract","kos_name":"Quantity Control Management of stockpile","vessel":"Utama Bersama","qty":5,"uom_name":"Case","jo_created_date":"2024-05-15 12:44:05","barge":"Barge Bersama 1|Barge Bersama 2|Barge Deh","market_segment_name":"NICKEL","sub_market_segment_name":"Fero Nickel"}
/// sow : [{"name":"To report physical condition of cargo and provide continuous daily updates detailing all relevant loading activities, including photographs","id":9},{"name":"To report physical condition of cargo and provide continuous daily updates detailing all relevant loading activities, including photographs","id":9}]
/// oos : [{"name":"Certificate of Quality","id":9},{"name":"Certificate of Quality","id":9}]
/// lap : [{"name":"Ash Analysis","id":9},{"name":"Ash Analysis","id":9}]
/// std_method : [{"name":"AOCS Ca 3a-46","id":25}]
/// pic_hist : [{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-10 09:33:22","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Palembang","pic_laboratory":"Lara Fiona Rizki","pic_inspector":"Ted Hariman Misor"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"},{"assigned_date":"2024-07-12 16:57:31","assign_by":"Mitha Robiatul Adawiyah","remarks":"Testing inject by evan 3","etta_vessel":"2024-05-17","start_date_of_attendance":"2024-05-16","end_date_of_attendance":"2024-05-22","lokasi_kerja":"Tanjung Selor","pic_laboratory":"Nur Rohmad","pic_inspector":"Muhammad Alwy Zulham"}]

class DataDetail {
  DataDetail({
      Detail? detail, 
      List<Sow>? sow, 
      List<Oos>? oos, 
      List<Lap>? lap, 
      List<StdMethod>? stdMethod, 
      List<PicHist>? picHist,}){
    _detail = detail;
    _sow = sow;
    _oos = oos;
    _lap = lap;
    _stdMethod = stdMethod;
    _picHist = picHist;
}

  DataDetail.fromJson(dynamic json) {
    _detail = json['detail'] != null ? Detail.fromJson(json['detail']) : null;
    if (json['sow'] != null) {
      _sow = [];
      json['sow'].forEach((v) {
        _sow?.add(Sow.fromJson(v));
      });
    }
    if (json['oos'] != null) {
      _oos = [];
      json['oos'].forEach((v) {
        _oos?.add(Oos.fromJson(v));
      });
    }
    if (json['lap'] != null) {
      _lap = [];
      json['lap'].forEach((v) {
        _lap?.add(Lap.fromJson(v));
      });
    }
    if (json['std_method'] != null) {
      _stdMethod = [];
      json['std_method'].forEach((v) {
        _stdMethod?.add(StdMethod.fromJson(v));
      });
    }
    if (json['pic_hist'] != null) {
      _picHist = [];
      json['pic_hist'].forEach((v) {
        _picHist?.add(PicHist.fromJson(v));
      });
    }
  }
  Detail? _detail;
  List<Sow>? _sow;
  List<Oos>? _oos;
  List<Lap>? _lap;
  List<StdMethod>? _stdMethod;
  List<PicHist>? _picHist;
DataDetail copyWith({  Detail? detail,
  List<Sow>? sow,
  List<Oos>? oos,
  List<Lap>? lap,
  List<StdMethod>? stdMethod,
  List<PicHist>? picHist,
}) => DataDetail(  detail: detail ?? _detail,
  sow: sow ?? _sow,
  oos: oos ?? _oos,
  lap: lap ?? _lap,
  stdMethod: stdMethod ?? _stdMethod,
  picHist: picHist ?? _picHist,
);
  Detail? get detail => _detail;
  List<Sow>? get sow => _sow;
  List<Oos>? get oos => _oos;
  List<Lap>? get lap => _lap;
  List<StdMethod>? get stdMethod => _stdMethod;
  List<PicHist>? get picHist => _picHist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_detail != null) {
      map['detail'] = _detail?.toJson();
    }
    if (_sow != null) {
      map['sow'] = _sow?.map((v) => v.toJson()).toList();
    }
    if (_oos != null) {
      map['oos'] = _oos?.map((v) => v.toJson()).toList();
    }
    if (_lap != null) {
      map['lap'] = _lap?.map((v) => v.toJson()).toList();
    }
    if (_stdMethod != null) {
      map['std_method'] = _stdMethod?.map((v) => v.toJson()).toList();
    }
    if (_picHist != null) {
      map['pic_hist'] = _picHist?.map((v) => v.toJson()).toList();
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

class PicHist {
  PicHist({
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

  PicHist.fromJson(dynamic json) {
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
PicHist copyWith({  String? assignedDate,
  String? assignBy,
  String? remarks,
  String? ettaVessel,
  String? startDateOfAttendance,
  String? endDateOfAttendance,
  String? lokasiKerja,
  String? picLaboratory,
  String? picInspector,
}) => PicHist(  assignedDate: assignedDate ?? _assignedDate,
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

/// name : "AOCS Ca 3a-46"
/// id : 25

class StdMethod {
  StdMethod({
      String? name, 
      num? id,}){
    _name = name;
    _id = id;
}

  StdMethod.fromJson(dynamic json) {
    _name = json['name'];
    _id = json['id'];
  }
  String? _name;
  num? _id;
StdMethod copyWith({  String? name,
  num? id,
}) => StdMethod(  name: name ?? _name,
  id: id ?? _id,
);
  String? get name => _name;
  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['id'] = _id;
    return map;
  }

}

/// name : "Ash Analysis"
/// id : 9

class Lap {
  Lap({
      String? name, 
      num? id,}){
    _name = name;
    _id = id;
}

  Lap.fromJson(dynamic json) {
    _name = json['name'];
    _id = json['id'];
  }
  String? _name;
  num? _id;
Lap copyWith({  String? name,
  num? id,
}) => Lap(  name: name ?? _name,
  id: id ?? _id,
);
  String? get name => _name;
  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['id'] = _id;
    return map;
  }

}

/// name : "Certificate of Quality"
/// id : 9

class Oos {
  Oos({
      String? name, 
      num? id,}){
    _name = name;
    _id = id;
}

  Oos.fromJson(dynamic json) {
    _name = json['name'];
    _id = json['id'];
  }
  String? _name;
  num? _id;
Oos copyWith({  String? name,
  num? id,
}) => Oos(  name: name ?? _name,
  id: id ?? _id,
);
  String? get name => _name;
  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['id'] = _id;
    return map;
  }

}

/// name : "To report physical condition of cargo and provide continuous daily updates detailing all relevant loading activities, including photographs"
/// id : 9

class Sow {
  Sow({
      String? name, 
      num? id,}){
    _name = name;
    _id = id;
}

  Sow.fromJson(dynamic json) {
    _name = json['name'];
    _id = json['id'];
  }
  String? _name;
  num? _id;
Sow copyWith({  String? name,
  num? id,
}) => Sow(  name: name ?? _name,
  id: id ?? _id,
);
  String? get name => _name;
  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['id'] = _id;
    return map;
  }

}

/// id : 7
/// so_code : "0005/SO/04/2024"
/// code : "JO7"
/// canceled_date : "2024-07-10"
/// so_created_at : "2024-04-05 15:45:23"
/// jo_created_at : "2024-05-15 12:44:05"
/// status_jo : "On Progres"
/// company_name : "Bumi Nusantara Jaya"
/// m_client_category_name : "Existing Client"
/// project_tittle : "Master protect"
/// region : "Jawa"
/// branch : "Jakarta"
/// site_office : null
/// survey_location : "Port of Vanaheim"
/// country_survey : "Indonesia"
/// province_survey : "Jakarta Utara\t"
/// city_survey : "Penjaringan"
/// loading_port : "Port of Midgard"
/// loading_port_country : "Indonesia"
/// loading_port_province : "Jakarta Utara\t"
/// loading_port_city : "Penjaringan"
/// discharge_port : "Port of Jotun"
/// discharge_port_country : "Indonesia"
/// discharge_port_province : "Jakarta Utara\t"
/// discharge_port_city : "Penjaringan"
/// supplier_name : null
/// trader1_name : "Bumi Nusantara Jaya"
/// trader2_name : "PT Evan Bersama"
/// trader3_name : "PT Evan Bersama"
/// end_buyer_name : "PT Suara Sembar Jaya"
/// notes : null
/// sbu_name : "Agri"
/// commodity_name : "Cooking coal"
/// etta_vessel : "17-05-2024"
/// start_date_of_attendance : "16-05-2024"
/// end_date_of_attendance : "22-05-2024"
/// lokasi_kerja : null
/// pic_laboratory : "Pradibta Jayadi Agung"
/// pic_inspector : "Aliastang"
/// destination_country : "Indonesia"
/// destination_category_name : "Domestic"
/// job_category_name : "Domestic Contract"
/// kos_name : "Quantity Control Management of stockpile"
/// vessel : "Utama Bersama"
/// qty : 5
/// uom_name : "Case"
/// jo_created_date : "2024-05-15 12:44:05"
/// barge : "Barge Bersama 1|Barge Bersama 2|Barge Deh"
/// market_segment_name : "NICKEL"
/// sub_market_segment_name : "Fero Nickel"

class Detail {
  Detail({
      num? id, 
      String? soCode, 
      String? code, 
      String? canceledDate, 
      String? soCreatedAt, 
      String? joCreatedAt, 
      String? statusJo, 
      String? companyName, 
      String? mClientCategoryName, 
      String? projectTittle, 
      String? region, 
      String? branch, 
      dynamic siteOffice, 
      String? surveyLocation, 
      String? countrySurvey, 
      String? provinceSurvey, 
      String? citySurvey, 
      String? loadingPort, 
      String? loadingPortCountry, 
      String? loadingPortProvince, 
      String? loadingPortCity, 
      String? dischargePort, 
      String? dischargePortCountry, 
      String? dischargePortProvince, 
      String? dischargePortCity, 
      dynamic supplierName, 
      String? trader1Name, 
      String? trader2Name, 
      String? trader3Name, 
      String? endBuyerName, 
      dynamic notes, 
      String? sbuName, 
      String? commodityName, 
      String? ettaVessel, 
      String? startDateOfAttendance, 
      String? endDateOfAttendance, 
      dynamic lokasiKerja, 
      String? picLaboratory, 
      String? picInspector, 
      String? destinationCountry, 
      String? destinationCategoryName, 
      String? jobCategoryName, 
      String? kosName, 
      String? vessel, 
      num? qty, 
      String? uomName, 
      String? joCreatedDate, 
      String? barge, 
      String? marketSegmentName, 
      String? subMarketSegmentName,}){
    _id = id;
    _soCode = soCode;
    _code = code;
    _canceledDate = canceledDate;
    _soCreatedAt = soCreatedAt;
    _joCreatedAt = joCreatedAt;
    _statusJo = statusJo;
    _companyName = companyName;
    _mClientCategoryName = mClientCategoryName;
    _projectTittle = projectTittle;
    _region = region;
    _branch = branch;
    _siteOffice = siteOffice;
    _surveyLocation = surveyLocation;
    _countrySurvey = countrySurvey;
    _provinceSurvey = provinceSurvey;
    _citySurvey = citySurvey;
    _loadingPort = loadingPort;
    _loadingPortCountry = loadingPortCountry;
    _loadingPortProvince = loadingPortProvince;
    _loadingPortCity = loadingPortCity;
    _dischargePort = dischargePort;
    _dischargePortCountry = dischargePortCountry;
    _dischargePortProvince = dischargePortProvince;
    _dischargePortCity = dischargePortCity;
    _supplierName = supplierName;
    _trader1Name = trader1Name;
    _trader2Name = trader2Name;
    _trader3Name = trader3Name;
    _endBuyerName = endBuyerName;
    _notes = notes;
    _sbuName = sbuName;
    _commodityName = commodityName;
    _ettaVessel = ettaVessel;
    _startDateOfAttendance = startDateOfAttendance;
    _endDateOfAttendance = endDateOfAttendance;
    _lokasiKerja = lokasiKerja;
    _picLaboratory = picLaboratory;
    _picInspector = picInspector;
    _destinationCountry = destinationCountry;
    _destinationCategoryName = destinationCategoryName;
    _jobCategoryName = jobCategoryName;
    _kosName = kosName;
    _vessel = vessel;
    _qty = qty;
    _uomName = uomName;
    _joCreatedDate = joCreatedDate;
    _barge = barge;
    _marketSegmentName = marketSegmentName;
    _subMarketSegmentName = subMarketSegmentName;
}

  Detail.fromJson(dynamic json) {
    _id = json['id'];
    _soCode = json['so_code'];
    _code = json['code'];
    _canceledDate = json['canceled_date'];
    _soCreatedAt = json['so_created_at'];
    _joCreatedAt = json['jo_created_at'];
    _statusJo = json['status_jo'];
    _companyName = json['company_name'];
    _mClientCategoryName = json['m_client_category_name'];
    _projectTittle = json['project_tittle'];
    _region = json['region'];
    _branch = json['branch'];
    _siteOffice = json['site_office'];
    _surveyLocation = json['survey_location'];
    _countrySurvey = json['country_survey'];
    _provinceSurvey = json['province_survey'];
    _citySurvey = json['city_survey'];
    _loadingPort = json['loading_port'];
    _loadingPortCountry = json['loading_port_country'];
    _loadingPortProvince = json['loading_port_province'];
    _loadingPortCity = json['loading_port_city'];
    _dischargePort = json['discharge_port'];
    _dischargePortCountry = json['discharge_port_country'];
    _dischargePortProvince = json['discharge_port_province'];
    _dischargePortCity = json['discharge_port_city'];
    _supplierName = json['supplier_name'];
    _trader1Name = json['trader1_name'];
    _trader2Name = json['trader2_name'];
    _trader3Name = json['trader3_name'];
    _endBuyerName = json['end_buyer_name'];
    _notes = json['notes'];
    _sbuName = json['sbu_name'];
    _commodityName = json['commodity_name'];
    _ettaVessel = json['etta_vessel'];
    _startDateOfAttendance = json['start_date_of_attendance'];
    _endDateOfAttendance = json['end_date_of_attendance'];
    _lokasiKerja = json['lokasi_kerja'];
    _picLaboratory = json['pic_laboratory'];
    _picInspector = json['pic_inspector'];
    _destinationCountry = json['destination_country'];
    _destinationCategoryName = json['destination_category_name'];
    _jobCategoryName = json['job_category_name'];
    _kosName = json['kos_name'];
    _vessel = json['vessel'];
    _qty = json['qty'];
    _uomName = json['uom_name'];
    _joCreatedDate = json['jo_created_date'];
    _barge = json['barge'];
    _marketSegmentName = json['market_segment_name'];
    _subMarketSegmentName = json['sub_market_segment_name'];
  }
  num? _id;
  String? _soCode;
  String? _code;
  String? _canceledDate;
  String? _soCreatedAt;
  String? _joCreatedAt;
  String? _statusJo;
  String? _companyName;
  String? _mClientCategoryName;
  String? _projectTittle;
  String? _region;
  String? _branch;
  dynamic _siteOffice;
  String? _surveyLocation;
  String? _countrySurvey;
  String? _provinceSurvey;
  String? _citySurvey;
  String? _loadingPort;
  String? _loadingPortCountry;
  String? _loadingPortProvince;
  String? _loadingPortCity;
  String? _dischargePort;
  String? _dischargePortCountry;
  String? _dischargePortProvince;
  String? _dischargePortCity;
  dynamic _supplierName;
  String? _trader1Name;
  String? _trader2Name;
  String? _trader3Name;
  String? _endBuyerName;
  dynamic _notes;
  String? _sbuName;
  String? _commodityName;
  String? _ettaVessel;
  String? _startDateOfAttendance;
  String? _endDateOfAttendance;
  dynamic _lokasiKerja;
  String? _picLaboratory;
  String? _picInspector;
  String? _destinationCountry;
  String? _destinationCategoryName;
  String? _jobCategoryName;
  String? _kosName;
  String? _vessel;
  num? _qty;
  String? _uomName;
  String? _joCreatedDate;
  String? _barge;
  String? _marketSegmentName;
  String? _subMarketSegmentName;
Detail copyWith({  num? id,
  String? soCode,
  String? code,
  String? canceledDate,
  String? soCreatedAt,
  String? joCreatedAt,
  String? statusJo,
  String? companyName,
  String? mClientCategoryName,
  String? projectTittle,
  String? region,
  String? branch,
  dynamic siteOffice,
  String? surveyLocation,
  String? countrySurvey,
  String? provinceSurvey,
  String? citySurvey,
  String? loadingPort,
  String? loadingPortCountry,
  String? loadingPortProvince,
  String? loadingPortCity,
  String? dischargePort,
  String? dischargePortCountry,
  String? dischargePortProvince,
  String? dischargePortCity,
  dynamic supplierName,
  String? trader1Name,
  String? trader2Name,
  String? trader3Name,
  String? endBuyerName,
  dynamic notes,
  String? sbuName,
  String? commodityName,
  String? ettaVessel,
  String? startDateOfAttendance,
  String? endDateOfAttendance,
  dynamic lokasiKerja,
  String? picLaboratory,
  String? picInspector,
  String? destinationCountry,
  String? destinationCategoryName,
  String? jobCategoryName,
  String? kosName,
  String? vessel,
  num? qty,
  String? uomName,
  String? joCreatedDate,
  String? barge,
  String? marketSegmentName,
  String? subMarketSegmentName,
}) => Detail(  id: id ?? _id,
  soCode: soCode ?? _soCode,
  code: code ?? _code,
  canceledDate: canceledDate ?? _canceledDate,
  soCreatedAt: soCreatedAt ?? _soCreatedAt,
  joCreatedAt: joCreatedAt ?? _joCreatedAt,
  statusJo: statusJo ?? _statusJo,
  companyName: companyName ?? _companyName,
  mClientCategoryName: mClientCategoryName ?? _mClientCategoryName,
  projectTittle: projectTittle ?? _projectTittle,
  region: region ?? _region,
  branch: branch ?? _branch,
  siteOffice: siteOffice ?? _siteOffice,
  surveyLocation: surveyLocation ?? _surveyLocation,
  countrySurvey: countrySurvey ?? _countrySurvey,
  provinceSurvey: provinceSurvey ?? _provinceSurvey,
  citySurvey: citySurvey ?? _citySurvey,
  loadingPort: loadingPort ?? _loadingPort,
  loadingPortCountry: loadingPortCountry ?? _loadingPortCountry,
  loadingPortProvince: loadingPortProvince ?? _loadingPortProvince,
  loadingPortCity: loadingPortCity ?? _loadingPortCity,
  dischargePort: dischargePort ?? _dischargePort,
  dischargePortCountry: dischargePortCountry ?? _dischargePortCountry,
  dischargePortProvince: dischargePortProvince ?? _dischargePortProvince,
  dischargePortCity: dischargePortCity ?? _dischargePortCity,
  supplierName: supplierName ?? _supplierName,
  trader1Name: trader1Name ?? _trader1Name,
  trader2Name: trader2Name ?? _trader2Name,
  trader3Name: trader3Name ?? _trader3Name,
  endBuyerName: endBuyerName ?? _endBuyerName,
  notes: notes ?? _notes,
  sbuName: sbuName ?? _sbuName,
  commodityName: commodityName ?? _commodityName,
  ettaVessel: ettaVessel ?? _ettaVessel,
  startDateOfAttendance: startDateOfAttendance ?? _startDateOfAttendance,
  endDateOfAttendance: endDateOfAttendance ?? _endDateOfAttendance,
  lokasiKerja: lokasiKerja ?? _lokasiKerja,
  picLaboratory: picLaboratory ?? _picLaboratory,
  picInspector: picInspector ?? _picInspector,
  destinationCountry: destinationCountry ?? _destinationCountry,
  destinationCategoryName: destinationCategoryName ?? _destinationCategoryName,
  jobCategoryName: jobCategoryName ?? _jobCategoryName,
  kosName: kosName ?? _kosName,
  vessel: vessel ?? _vessel,
  qty: qty ?? _qty,
  uomName: uomName ?? _uomName,
  joCreatedDate: joCreatedDate ?? _joCreatedDate,
  barge: barge ?? _barge,
  marketSegmentName: marketSegmentName ?? _marketSegmentName,
  subMarketSegmentName: subMarketSegmentName ?? _subMarketSegmentName,
);
  num? get id => _id;
  String? get soCode => _soCode;
  String? get code => _code;
  String? get canceledDate => _canceledDate;
  String? get soCreatedAt => _soCreatedAt;
  String? get joCreatedAt => _joCreatedAt;
  String? get statusJo => _statusJo;
  String? get companyName => _companyName;
  String? get mClientCategoryName => _mClientCategoryName;
  String? get projectTittle => _projectTittle;
  String? get region => _region;
  String? get branch => _branch;
  dynamic get siteOffice => _siteOffice;
  String? get surveyLocation => _surveyLocation;
  String? get countrySurvey => _countrySurvey;
  String? get provinceSurvey => _provinceSurvey;
  String? get citySurvey => _citySurvey;
  String? get loadingPort => _loadingPort;
  String? get loadingPortCountry => _loadingPortCountry;
  String? get loadingPortProvince => _loadingPortProvince;
  String? get loadingPortCity => _loadingPortCity;
  String? get dischargePort => _dischargePort;
  String? get dischargePortCountry => _dischargePortCountry;
  String? get dischargePortProvince => _dischargePortProvince;
  String? get dischargePortCity => _dischargePortCity;
  dynamic get supplierName => _supplierName;
  String? get trader1Name => _trader1Name;
  String? get trader2Name => _trader2Name;
  String? get trader3Name => _trader3Name;
  String? get endBuyerName => _endBuyerName;
  dynamic get notes => _notes;
  String? get sbuName => _sbuName;
  String? get commodityName => _commodityName;
  String? get ettaVessel => _ettaVessel;
  String? get startDateOfAttendance => _startDateOfAttendance;
  String? get endDateOfAttendance => _endDateOfAttendance;
  dynamic get lokasiKerja => _lokasiKerja;
  String? get picLaboratory => _picLaboratory;
  String? get picInspector => _picInspector;
  String? get destinationCountry => _destinationCountry;
  String? get destinationCategoryName => _destinationCategoryName;
  String? get jobCategoryName => _jobCategoryName;
  String? get kosName => _kosName;
  String? get vessel => _vessel;
  num? get qty => _qty;
  String? get uomName => _uomName;
  String? get joCreatedDate => _joCreatedDate;
  String? get barge => _barge;
  String? get marketSegmentName => _marketSegmentName;
  String? get subMarketSegmentName => _subMarketSegmentName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['so_code'] = _soCode;
    map['code'] = _code;
    map['canceled_date'] = _canceledDate;
    map['so_created_at'] = _soCreatedAt;
    map['jo_created_at'] = _joCreatedAt;
    map['status_jo'] = _statusJo;
    map['company_name'] = _companyName;
    map['m_client_category_name'] = _mClientCategoryName;
    map['project_tittle'] = _projectTittle;
    map['region'] = _region;
    map['branch'] = _branch;
    map['site_office'] = _siteOffice;
    map['survey_location'] = _surveyLocation;
    map['country_survey'] = _countrySurvey;
    map['province_survey'] = _provinceSurvey;
    map['city_survey'] = _citySurvey;
    map['loading_port'] = _loadingPort;
    map['loading_port_country'] = _loadingPortCountry;
    map['loading_port_province'] = _loadingPortProvince;
    map['loading_port_city'] = _loadingPortCity;
    map['discharge_port'] = _dischargePort;
    map['discharge_port_country'] = _dischargePortCountry;
    map['discharge_port_province'] = _dischargePortProvince;
    map['discharge_port_city'] = _dischargePortCity;
    map['supplier_name'] = _supplierName;
    map['trader1_name'] = _trader1Name;
    map['trader2_name'] = _trader2Name;
    map['trader3_name'] = _trader3Name;
    map['end_buyer_name'] = _endBuyerName;
    map['notes'] = _notes;
    map['sbu_name'] = _sbuName;
    map['commodity_name'] = _commodityName;
    map['etta_vessel'] = _ettaVessel;
    map['start_date_of_attendance'] = _startDateOfAttendance;
    map['end_date_of_attendance'] = _endDateOfAttendance;
    map['lokasi_kerja'] = _lokasiKerja;
    map['pic_laboratory'] = _picLaboratory;
    map['pic_inspector'] = _picInspector;
    map['destination_country'] = _destinationCountry;
    map['destination_category_name'] = _destinationCategoryName;
    map['job_category_name'] = _jobCategoryName;
    map['kos_name'] = _kosName;
    map['vessel'] = _vessel;
    map['qty'] = _qty;
    map['uom_name'] = _uomName;
    map['jo_created_date'] = _joCreatedDate;
    map['barge'] = _barge;
    map['market_segment_name'] = _marketSegmentName;
    map['sub_market_segment_name'] = _subMarketSegmentName;
    return map;
  }

}