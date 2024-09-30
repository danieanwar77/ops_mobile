/// http_code : 200
/// message : "Status Jo berhasil Dirubah Ke onProgress."

class ResponseJoChangeStatus {
  ResponseJoChangeStatus({
      num? httpCode, 
      String? message,}){
    _httpCode = httpCode;
    _message = message;
}

  ResponseJoChangeStatus.fromJson(dynamic json) {
    _httpCode = json['http_code'];
    _message = json['message'];
  }
  num? _httpCode;
  String? _message;
ResponseJoChangeStatus copyWith({  num? httpCode,
  String? message,
}) => ResponseJoChangeStatus(  httpCode: httpCode ?? _httpCode,
  message: message ?? _message,
);
  num? get httpCode => _httpCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['http_code'] = _httpCode;
    map['message'] = _message;
    return map;
  }

}