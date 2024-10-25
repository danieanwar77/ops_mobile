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

class TDJoFinalizeInspection {
  int? id;
  String tHJoId;
  String noReport;
  String dateReport;
  String noBlankoCertificate;
  String lhvNumber;
  String lsNumber;
  String code;
  String isActive;
  String isUpload;
  String createdBy;
  String? updatedBy; // Nullable
  String createdAt;
  String? updatedAt; // Nullable

  // Constructor with required and optional fields
  TDJoFinalizeInspection({
    this.id, // Nullable
    required this.tHJoId,
    required this.noReport,
    required this.dateReport,
    required this.noBlankoCertificate,
    required this.lhvNumber,
    required this.lsNumber,
    required this.code,
    required this.isActive,
    required this.isUpload,
    required this.createdBy,
    this.updatedBy, // Nullable
    required this.createdAt,
    this.updatedAt, // Nullable
  });

  // Create a TDJoFinalizeInspection from a JSON map
  factory TDJoFinalizeInspection.fromJson(Map<String, dynamic> json) {
    return TDJoFinalizeInspection(
      id: json['id'], // Nullable
      tHJoId: json['t_h_jo_id'],
      noReport: json['no_report'],
      dateReport: json['date_report'],
      noBlankoCertificate: json['no_blanko_certificate'],
      lhvNumber: json['lhv_number'],
      lsNumber: json['ls_number'],
      code: json['code'],
      isActive: json['is_active'],
      isUpload: json['is_upload'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'], // Nullable
      createdAt: json['created_at'],
      updatedAt: json['updated_at'], // Nullable
    );
  }

  // Convert TDJoFinalizeInspection to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Nullable
      't_h_jo_id': tHJoId,
      'no_report': noReport,
      'date_report': dateReport,
      'no_blanko_certificate': noBlankoCertificate,
      'lhv_number': lhvNumber,
      'ls_number': lsNumber,
      'code': code,
      'is_active': isActive,
      'is_upload': isUpload,
      'created_by': createdBy,
      'updated_by': updatedBy, // Nullable
      'created_at': createdAt,
      'updated_at': updatedAt, // Nullable
    };
  }

  // Copy method for creating a new instance with updated values
  TDJoFinalizeInspection copyWith({
    int? id,
    String? tHJoId,
    String? noReport,
    String? dateReport,
    String? noBlankoCertificate,
    String? lhvNumber,
    String? lsNumber,
    String? code,
    String? isActive,
    String? isUpload,
    String? createdBy,
    String? updatedBy,
    String? createdAt,
    String? updatedAt,
  }) {
    return TDJoFinalizeInspection(
      id: id ?? this.id, // Nullable
      tHJoId: tHJoId ?? this.tHJoId,
      noReport: noReport ?? this.noReport,
      dateReport: dateReport ?? this.dateReport,
      noBlankoCertificate: noBlankoCertificate ?? this.noBlankoCertificate,
      lhvNumber: lhvNumber ?? this.lhvNumber,
      lsNumber: lsNumber ?? this.lsNumber,
      code: code ?? this.code,
      isActive: isActive ?? this.isActive,
      isUpload: isUpload ?? this.isUpload,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy, // Nullable
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt, // Nullable
    );
  }
}
