// /// id : 1
// /// name : "MT"
// /// flag_active : 1
// /// created_by : 1
// /// created_at : "2023-12-12 00:00:00.0"
// /// updated_by : null
// /// updated_at : null
//
// class MUom {
//   MUom({
//       num id,
//       String name,
//       num flagActive,
//       num createdBy,
//       String createdAt,
//       dynamic updatedBy,
//       dynamic updatedAt,}){
//     _id = id;
//     _name = name;
//     _flagActive = flagActive;
//     _createdBy = createdBy;
//     _createdAt = createdAt;
//     _updatedBy = updatedBy;
//     _updatedAt = updatedAt;
// }
//
//   MUom.fromJson(dynamic json) {
//     _id = json['id'];
//     _name = json['name'];
//     _flagActive = json['flag_active'];
//     _createdBy = json['created_by'];
//     _createdAt = json['created_at'];
//     _updatedBy = json['updated_by'];
//     _updatedAt = json['updated_at'];
//   }
//   num _id;
//   String _name;
//   num _flagActive;
//   num _createdBy;
//   String _createdAt;
//   dynamic _updatedBy;
//   dynamic _updatedAt;
// MUom copyWith({  num id,
//   String name,
//   num flagActive,
//   num createdBy,
//   String createdAt,
//   dynamic updatedBy,
//   dynamic updatedAt,
// }) => MUom(  id: id ?? _id,
//   name: name ?? _name,
//   flagActive: flagActive ?? _flagActive,
//   createdBy: createdBy ?? _createdBy,
//   createdAt: createdAt ?? _createdAt,
//   updatedBy: updatedBy ?? _updatedBy,
//   updatedAt: updatedAt ?? _updatedAt,
// );
//   num get id => _id;
//   String get name => _name;
//   num get flagActive => _flagActive;
//   num get createdBy => _createdBy;
//   String get createdAt => _createdAt;
//   dynamic get updatedBy => _updatedBy;
//   dynamic get updatedAt => _updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['name'] = _name;
//     map['flag_active'] = _flagActive;
//     map['created_by'] = _createdBy;
//     map['created_at'] = _createdAt;
//     map['updated_by'] = _updatedBy;
//     map['updated_at'] = _updatedAt;
//     return map;
//   }
//
// }