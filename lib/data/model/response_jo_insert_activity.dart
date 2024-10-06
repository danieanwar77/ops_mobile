/// message : "Inspection berhasil ditambahkan."

class ResponseJoInsertActivity {
  ResponseJoInsertActivity({
      String? message,}){
    _message = message;
}

  ResponseJoInsertActivity.fromJson(dynamic json) {
    _message = json['message'];
  }
  String? _message;
ResponseJoInsertActivity copyWith({  String? message,
}) => ResponseJoInsertActivity(  message: message ?? _message,
);
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    return map;
  }

}