/// code : 200
/// message : "Registrasi Device Berhasil"

class ResponseRegisterDevice {
  ResponseRegisterDevice({
      num? code,
      String? message,}){
    _code = code;
    _message = message;
}

  ResponseRegisterDevice.fromJson(dynamic json) {
    _code = json['code'];
    _message = json['message'];
  }
  num? _code;
  String? _message;
ResponseRegisterDevice copyWith({  num? code,
  String? message,
}) => ResponseRegisterDevice(  code: code ?? _code,
  message: message ?? _message,
);
  num? get code => _code;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['message'] = _message;
    return map;
  }

}