import 'package:ops_mobile/data/Datatabase2.dart';

/// etta_vessel : "2024-01-01"
/// date_attendance : "2024-01-01 sd 2023-02-12"
/// pic_inspector : "012 - indo - 1234"
/// pic_laboratory : "02 - indo - 123213"

class EttaVessel {
  EttaVessel({
      String? ettaVessel,
      String? dateAttendance,
      String? lokasiKerja,
      String? picInspector,
      String? picLaboratory,
  }){
    _ettaVessel = ettaVessel;
    _dateAttendance = dateAttendance;
    _picInspector = picInspector;
    _picLaboratory = picLaboratory;
}

  EttaVessel.fromJson(dynamic json) {
    _ettaVessel = json['etta_vessel'];
    _dateAttendance = json['date_attendance'];
    _lokasiKerja = json['lokasi_kerja'];
    _picInspector = json['pic_inspector'];
    _picLaboratory = json['pic_laboratory'];
  }
  String? _ettaVessel;
  String? _dateAttendance;
  String? _lokasiKerja;
  String? _picInspector;
  String? _picLaboratory;
EttaVessel copyWith({  String? ettaVessel,
  String? dateAttendance,
  String? lokasiKerja,
  String? picInspector,
  String? picLaboratory,
}) => EttaVessel(  ettaVessel: ettaVessel ?? _ettaVessel,
  dateAttendance: dateAttendance ?? _dateAttendance,
  picInspector: picInspector ?? _picInspector,
  lokasiKerja: lokasiKerja ?? _lokasiKerja,
  picLaboratory: picLaboratory ?? _picLaboratory,
);
  String? get ettaVessel => _ettaVessel;
  String? get dateAttendance => _dateAttendance;
  String? get picInspector => _picInspector;
  String? get picLaboratory => _picLaboratory;
  String? get lokasiKerja => _lokasiKerja;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['etta_vessel'] = _ettaVessel;
    map['lokasi_kerja'] = _lokasiKerja;
    map['date_attendance'] = _dateAttendance;
    map['pic_inspector'] = _picInspector;
    map['pic_laboratory'] = _picLaboratory;
    return map;
  }

  static Future<EttaVessel> getDataByIdJo(int id) async{
    final db = await SqlHelperV2().database;
    var detail = await db.rawQuery('''
          SELECT 
          etta_vessel,
          start_date_of_attendance || ' - ' || end_date_of_attendance as date_attendance,
          s.site_office as lokasi_kerja,
          i.e_number || ' - ' ||  i.fullname || ' - ' || ji.jabatan as pic_inspector,
          p.e_number || ' - ' ||  p.fullname || ' - '|| jp.jabatan as  pic_laboratory 
        from 
          t_h_jo as a
          left join employee as i on a.pic_inspector  = i.id 
          left join employee as p on a.pic_laboratory = p.id 
          left join site_office as s on a.lokasi_kerja = s.id 
          left join jabatan as ji on ji.id = i.jabatan_id
          left join jabatan as jp on jp.id = p.jabatan_id 
        where a.id= ?
            ''',[id]);
    if(detail.length > 0){
      return EttaVessel.fromJson(detail[0]);
    }else{
      return EttaVessel();
    }

  }

}