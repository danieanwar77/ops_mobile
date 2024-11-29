/// inspection_photos : [{"code":"","t_h_jo_id":0,"file":"","keterangan":"","is_active":0,"is_upload":0,"created_at":"","updated_at":""}]

class JoInspectionPhotosSendManualModel {
  JoInspectionPhotosSendManualModel({
      List<InspectionPhotos>? inspectionPhotos,}){
    _inspectionPhotos = inspectionPhotos ?? [];
}

  JoInspectionPhotosSendManualModel.fromJson(dynamic json) {
    if (json['inspection_photos'] != null) {
      _inspectionPhotos = [];
      json['inspection_photos'].forEach((v) {
        _inspectionPhotos?.add(InspectionPhotos.fromJson(v));
      });
    }
  }
  List<InspectionPhotos>? _inspectionPhotos;
JoInspectionPhotosSendManualModel copyWith({  List<InspectionPhotos>? inspectionPhotos,
}) => JoInspectionPhotosSendManualModel(  inspectionPhotos: inspectionPhotos ?? _inspectionPhotos,
);
  List<InspectionPhotos> get inspectionPhotos => _inspectionPhotos ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_inspectionPhotos != null) {
      map['inspection_photos'] = _inspectionPhotos?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// code : ""
/// t_h_jo_id : 0
/// file : ""
/// keterangan : ""
/// is_active : 0
/// is_upload : 0
/// created_at : ""
/// updated_at : ""

class InspectionPhotos {
  InspectionPhotos({
      String? code,
      num? tHJoId,
      String? file,
      String? keterangan,
      num? isActive,
      num? isUpload,
      String? createdAt,
      String? updatedAt,}){
    _code = code;
    _tHJoId = tHJoId;
    _file = file;
    _keterangan = keterangan;
    _isActive = isActive;
    _isUpload = isUpload;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  InspectionPhotos.fromJson(dynamic json) {
    _code = json['code'];
    _tHJoId = json['t_h_jo_id'];
    _file = json['file'];
    _keterangan = json['keterangan'];
    _isActive = json['is_active'];
    _isUpload = json['is_upload'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  String? _code;
  num? _tHJoId;
  String? _file;
  String? _keterangan;
  num? _isActive;
  num? _isUpload;
  String? _createdAt;
  String? _updatedAt;
InspectionPhotos copyWith({  String? code,
  num? tHJoId,
  String? file,
  String? keterangan,
  num? isActive,
  num? isUpload,
  String? createdAt,
  String? updatedAt,
}) => InspectionPhotos(  code: code ?? _code,
  tHJoId: tHJoId ?? _tHJoId,
  file: file ?? _file,
  keterangan: keterangan ?? _keterangan,
  isActive: isActive ?? _isActive,
  isUpload: isUpload ?? _isUpload,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  String? get code => _code;
  num? get tHJoId => _tHJoId;
  String? get file => _file;
  String? get keterangan => _keterangan;
  num? get isActive => _isActive;
  num? get isUpload => _isUpload;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['t_h_jo_id'] = _tHJoId;
    map['file'] = _file;
    map['keterangan'] = _keterangan;
    map['is_active'] = _isActive;
    map['is_upload'] = _isUpload;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}