/// message : "Inspection Stage 5 berhasil ditambahkan."

class ResponseJoInsertActivity5 {
  ResponseJoInsertActivity5({
      String? message,}){
    _message = message;
}

  ResponseJoInsertActivity5.fromJson(dynamic json) {
    _message = json['message'];
  }
  String? _message;
ResponseJoInsertActivity5 copyWith({  String? message,
}) => ResponseJoInsertActivity5(  message: message ?? _message,
);
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    return map;
  }

}