/// id : "1"
/// t_h_jo_id : "1"
/// no_report : "1"
/// date_report : "1"
/// no_blanko_certificate : "1"
/// lhv_number : "1"
/// ls_number : "1"
/// code : "1"
/// is_active : "0"
/// is_upload : "0"
/// created_by : "1"
/// updated_by : "1"
/// created_at : "1"
/// updated_at : "1"

class TMNotif {
  int? id;
  int joId;
  int mStatusjoId;
  String? idTrans;
  String message;
  int employeeId;
  String? link;
  int flagActive;
  int flagRead;
  int createdBy;
  String? updatedBy; // Nullable
  String createdAt;
  String? updatedAt; // Nullable
  String? code;

  // Constructor with required and optional fields
  TMNotif({
    this.id, // Nullable
    required this.joId,
    required this.mStatusjoId,
    this.idTrans,
    required this.message,
    required this.employeeId,
    this.link,
    required this.flagActive,
    required this.flagRead,
    required this.createdBy,
    this.updatedBy, // Nullable
    required this.createdAt,
    this.updatedAt, // Nullable
    this.code,
  });

  // Create a TDJoFinalizeInspection from a JSON map
  factory TMNotif.fromJson(Map<String, dynamic> json) {
    return TMNotif(
      id: json['id'], // Nullable
      joId: json['jo_id'],
      mStatusjoId: json['m_statusjo_id'],
      idTrans: json['id_trans'],
      message: json['message'],
      employeeId: json['employee_id'],
      link: json['link'],
      flagActive: json['flag_active'],
      flagRead: json['flag_read'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'], // Nullable
      createdAt: json['created_at'],
      updatedAt: json['updated_at'], // Nullable
      code: json['code'],
    );
  }

  // Convert TDJoFinalizeInspection to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Nullable
      'jo_id': joId,
      'm_statusjo_id' : mStatusjoId,
      'id_trans': idTrans,
      'message': message,
      'employee_id': employeeId,
      'link': link,
      'flag_active': flagActive,
      'flag_read': flagRead,
      'created_by': createdBy,
      'updated_by': updatedBy, // Nullable
      'created_at': createdAt,
      'updated_at': updatedAt, // Nullable
      'code': code,
    };
  }

  // Copy method for creating a new instance with updated values
  TMNotif copyWith({
    int? id,
    int? joId,
    int? mStatusJoId,
    String? idTrans,
    String? message,
    int? employeeId,
    String? link,
    int? flagActive,
    int? flagRead,
    int? createdBy,
    String? updatedBy, // Nullable
    String? createdAt,
    String? updatedAt,
  }) {
    return TMNotif(
      id: id ?? this.id, // Nullable
      joId: joId ?? this.joId,
      mStatusjoId: mStatusJoId ?? this.mStatusjoId,
      idTrans: idTrans ?? this.idTrans,
      message: message ?? this.message,
      employeeId: employeeId ?? this.employeeId,
      link: link ?? this.link,
      flagActive: flagActive ?? this.flagActive,
      flagRead: flagRead ?? this.flagRead,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy, // Nullable
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt, // Nullable
    );
  }
}