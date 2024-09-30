/// http_code : 200
/// success : true
/// message : "Images uploaded successfully"
/// images : [{"path":"images/66f2803c6ebd4.png"}]

class ResponseJoActivityPhoto {
  ResponseJoActivityPhoto({
      num? httpCode, 
      bool? success, 
      String? message, 
      List<Images>? images,}){
    _httpCode = httpCode;
    _success = success;
    _message = message;
    _images = images;
}

  ResponseJoActivityPhoto.fromJson(dynamic json) {
    _httpCode = json['http_code'];
    _success = json['success'];
    _message = json['message'];
    if (json['images'] != null) {
      _images = [];
      json['images'].forEach((v) {
        _images?.add(Images.fromJson(v));
      });
    }
  }
  num? _httpCode;
  bool? _success;
  String? _message;
  List<Images>? _images;
ResponseJoActivityPhoto copyWith({  num? httpCode,
  bool? success,
  String? message,
  List<Images>? images,
}) => ResponseJoActivityPhoto(  httpCode: httpCode ?? _httpCode,
  success: success ?? _success,
  message: message ?? _message,
  images: images ?? _images,
);
  num? get httpCode => _httpCode;
  bool? get success => _success;
  String? get message => _message;
  List<Images>? get images => _images;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['http_code'] = _httpCode;
    map['success'] = _success;
    map['message'] = _message;
    if (_images != null) {
      map['images'] = _images?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// path : "images/66f2803c6ebd4.png"

class Images {
  Images({
      String? path,}){
    _path = path;
}

  Images.fromJson(dynamic json) {
    _path = json['path'];
  }
  String? _path;
Images copyWith({  String? path,
}) => Images(  path: path ?? _path,
);
  String? get path => _path;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['path'] = _path;
    return map;
  }

}