/// message : "Photo berhasil Dihapus."

class JoResponseDeleteActivityPhoto {
  JoResponseDeleteActivityPhoto({
      String? message,}){
    _message = message;
}

  JoResponseDeleteActivityPhoto.fromJson(dynamic json) {
    _message = json['message'];
  }
  String? _message;
JoResponseDeleteActivityPhoto copyWith({  String? message,
}) => JoResponseDeleteActivityPhoto(  message: message ?? _message,
);
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    return map;
  }

}