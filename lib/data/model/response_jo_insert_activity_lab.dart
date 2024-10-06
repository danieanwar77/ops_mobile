/// message : "Laboratory berhasil ditambahkan."

class ResponseJoInsertActivityLab {
  ResponseJoInsertActivityLab({
      String? message,}){
    _message = message;
}

  ResponseJoInsertActivityLab.fromJson(dynamic json) {
    _message = json['message'];
  }
  String? _message;
  ResponseJoInsertActivityLab copyWith({  String? message,
}) => ResponseJoInsertActivityLab(  message: message ?? _message,
);
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    return map;
  }

}