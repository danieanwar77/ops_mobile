/// id : 1
/// t_h_jo_id : 1
/// m_statusinpectionstages_id : 1
/// trans_date : ""
/// actual_qty : 1
/// uom_id : 1
/// remarks : ""
/// code : ""
/// is_active : ""
/// created_by : ""
/// updated_by : ""
/// created_at : ""
/// updated_at : ""

class TDJoInspectionAcitivityStages {
  TDJoInspectionAcitivityStages({
    this.id,
    this.tHJoId,
    this.mStatusinpectionstagesId,
    this.transDate,
    this.actualQty,
    this.uomId,
    this.remarks,
    this.code,
    this.isActive,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  TDJoInspectionAcitivityStages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tHJoId = json['t_h_jo_id'];
    mStatusinpectionstagesId = json['m_statusinpectionstages_id'];
    transDate = json['trans_date'];
    actualQty = json['actual_qty'];
    uomId = json['uom_id'];
    remarks = json['remarks'];
    code = json['code'];
    isActive = json['is_active'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  num? id;
  num? tHJoId;
  num? mStatusinpectionstagesId;
  String? transDate;
  num? actualQty;
  num? uomId;
  String? remarks;
  String? code;
  String? isActive;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;

  TDJoInspectionAcitivityStages copyWith({
    num? id,
    num? tHJoId,
    num? mStatusinpectionstagesId,
    String? transDate,
    num? actualQty,
    num? uomId,
    String? remarks,
    String? code,
    String? isActive,
    String? createdBy,
    String? updatedBy,
    String? createdAt,
    String? updatedAt,
  }) =>
      TDJoInspectionAcitivityStages(
        id: id ?? this.id,
        tHJoId: tHJoId ?? this.tHJoId,
        mStatusinpectionstagesId:
        mStatusinpectionstagesId ?? this.mStatusinpectionstagesId,
        transDate: transDate ?? this.transDate,
        actualQty: actualQty ?? this.actualQty,
        uomId: uomId ?? this.uomId,
        remarks: remarks ?? this.remarks,
        code: code ?? this.code,
        isActive: isActive ?? this.isActive,
        createdBy: createdBy ?? this.createdBy,
        updatedBy: updatedBy ?? this.updatedBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['t_h_jo_id'] = tHJoId;
    map['m_statusinpectionstages_id'] = mStatusinpectionstagesId;
    map['trans_date'] = transDate;
    map['actual_qty'] = actualQty;
    map['uom_id'] = uomId;
    map['remarks'] = remarks;
    map['code'] = code;
    map['is_active'] = isActive;
    map['created_by'] = createdBy;
    map['updated_by'] = updatedBy;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
