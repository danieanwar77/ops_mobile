/// message : "Laboratory berhasil ditambahkan."

class ResponseJoInsertActivity5Lab {
  ResponseJoInsertActivity5Lab({
      String? message,}){
    _message = message;
}

  ResponseJoInsertActivity5Lab.fromJson(dynamic json) {
    _message = json['message'];
  }
  String? _message;
ResponseJoInsertActivity5Lab copyWith({  String? message,
}) => ResponseJoInsertActivity5Lab(  message: message ?? _message,
);
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    return map;
  }

}