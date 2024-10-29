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

class TDJoFinalizeLaboratory {
  int? id;
  int? tDJoLabId;
  String noReport;
  String dateReport;
  String noBlankoCertificate;
  String lhvNumber;
  String lsNumber;
  String pathPdf;
  String code;
  int? isActive;
  int? isUpload;
  int? createdBy;
  int? updatedBy; // Nullable
  String createdAt;
  String? updatedAt; // Nullable

  // Constructor with required and optional fields
  TDJoFinalizeLaboratory({
    this.id, // Nullable
    required this.tDJoLabId,
    required this.noReport,
    required this.dateReport,
    required this.noBlankoCertificate,
    required this.lhvNumber,
    required this.lsNumber,
    required this.pathPdf,
    required this.code,
    required this.isActive,
    required this.isUpload,
    required this.createdBy,
    this.updatedBy, // Nullable
    required this.createdAt,
    this.updatedAt, // Nullable
  });

  // Create a TDJoFinalizeInspection from a JSON map
  factory TDJoFinalizeLaboratory.fromJson(Map<String, dynamic> json) {
    return TDJoFinalizeLaboratory(
      id: json['id'], // Nullable
      tDJoLabId: json['t_d_jo_laboratory_id'],
      noReport: json['no_report'],
      dateReport: json['date_report'],
      noBlankoCertificate: json['no_blanko_certificate'],
      lhvNumber: json['lhv_number'],
      lsNumber: json['ls_number'],
      pathPdf: json['path_pdf'],
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
      't_d_jo_laboratory_id': tDJoLabId,
      'no_report': noReport,
      'date_report': dateReport,
      'no_blanko_certificate': noBlankoCertificate,
      'lhv_number': lhvNumber,
      'ls_number': lsNumber,
      'path_pdf': pathPdf,
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
  TDJoFinalizeLaboratory copyWith({
    int? id,
    int? tDJoLabId,
    String? noReport,
    String? dateReport,
    String? noBlankoCertificate,
    String? lhvNumber,
    String? lsNumber,
    String? pathPdf,
    String? code,
    int? isActive,
    int? isUpload,
    int? createdBy,
    int? updatedBy,
    String? createdAt,
    String? updatedAt,
  }) {
    return TDJoFinalizeLaboratory(
      id: id ?? this.id, // Nullable
      tDJoLabId: tDJoLabId ?? this.tDJoLabId,
      noReport: noReport ?? this.noReport,
      dateReport: dateReport ?? this.dateReport,
      noBlankoCertificate: noBlankoCertificate ?? this.noBlankoCertificate,
      lhvNumber: lhvNumber ?? this.lhvNumber,
      lsNumber: lsNumber ?? this.lsNumber,
      pathPdf: pathPdf ?? this.pathPdf,
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

class TDJoFinalizeLaboratoryDocument {
  int? id;
  int? tDJoFLId;
  String pathFile;
  String fileName;
  String code;
  int? isActive;
  int? isUpload;
  int? createdBy;
  int? updatedBy; // Nullable
  String createdAt;
  String? updatedAt; // Nullable

  // Constructor with required and optional fields
  TDJoFinalizeLaboratoryDocument({
    this.id, // Nullable
    required this.tDJoFLId,
    required this.pathFile,
    required this.fileName,
    required this.code,
    required this.isActive,
    required this.isUpload,
    required this.createdBy,
    this.updatedBy, // Nullable
    required this.createdAt,
    this.updatedAt, // Nullable
  });

  // Create a TDJoFinalizeInspection from a JSON map
  factory TDJoFinalizeLaboratoryDocument.fromJson(Map<String, dynamic> json) {
    return TDJoFinalizeLaboratoryDocument(
      id: json['id'], // Nullable
      tDJoFLId: json['t_d_jo_finalize_laboratory_id'],
      pathFile: json['path_file'],
      fileName: json['file_name'],
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
      't_d_jo_finalize_laboratory_id': tDJoFLId,
      'path_file': pathFile,
      'file_name': fileName,
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
  TDJoFinalizeLaboratoryDocument copyWith({
    int? id,
    int? tDJoFLId,
    String? pathFile,
    String? fileName,
    String? code,
    int? isActive,
    int? isUpload,
    int? createdBy,
    int? updatedBy,
    String? createdAt,
    String? updatedAt,
  }) {
    return TDJoFinalizeLaboratoryDocument(
      id: id ?? this.id, // Nullable
      tDJoFLId: tDJoFLId ?? this.tDJoFLId,
      pathFile: pathFile ?? this.pathFile,
      fileName: fileName ?? this.fileName,
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
