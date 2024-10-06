/// status : 100
/// message : "login success"
/// token : "MHgRgj31HEx-fKeqGxrAD4KAafUjCLwx"

class LoginModel {
  LoginModel({
      num? status, 
      String? message, 
      String? token,}){
    _status = status;
    _message = message;
    _token = token;
}

  LoginModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _token = json['token'];
  }
  num? _status;
  String? _message;
  String? _token;
LoginModel copyWith({  num? status,
  String? message,
  String? token,
}) => LoginModel(  status: status ?? _status,
  message: message ?? _message,
  token: token ?? _token,
);
  num? get status => _status;
  String? get message => _message;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['token'] = _token;
    return map;
  }

}