// class t_d_jo_inspection_activity_stages {
//     int? actual_qty;
//     String code;
//     String created_at;
//     String created_by;
//     int? id;
//     String is_active;
//     int m_statusinpectionstages_id;
//     String? remarks;
//     int t_h_jo_id;
//     String trans_date;
//     int? uom_id;
//     String? updated_at;
//     String? updated_by;
//
//     t_d_jo_inspection_activity_stages({this.actual_qty, required this.code, required this.created_at, required this.created_by, this.id, required this.is_active, required this.m_statusinpectionstages_id, this.remarks, required this.t_h_jo_id, required this.trans_date, this.uom_id, this.updated_at, this.updated_by});
//
//     factory t_d_jo_inspection_activity_stages.fromJson(Map<String, dynamic> json) {
//         return t_d_jo_inspection_activity_stages(
//             actual_qty: json['actual_qty'],
//             code: json['code'],
//             created_at: json['created_at'],
//             created_by: json['created_by'],
//             id: json['id'],
//             is_active: json['is_active'],
//             m_statusinpectionstages_id: json['m_statusinpectionstages_id'],
//             remarks: json['remarks'],
//             t_h_jo_id: json['t_h_jo_id'],
//             trans_date: json['trans_date'],
//             uom_id: json['uom_id'],
//             updated_at: json['updated_at'],
//             updated_by: json['updated_by'],
//         );
//     }
//
//     Map<String, dynamic> toJson() {
//         final Map<String, dynamic> data = new Map<String, dynamic>();
//         data['actual_qty'] = this.actual_qty;
//         data['code'] = this.code;
//         data['created_at'] = this.created_at;
//         data['created_by'] = this.created_by;
//         data['id'] = this.id;
//         data['is_active'] = this.is_active;
//         data['m_statusinpectionstages_id'] = this.m_statusinpectionstages_id;
//         data['remarks'] = this.remarks;
//         data['t_h_jo_id'] = this.t_h_jo_id;
//         data['trans_date'] = this.trans_date;
//         data['uom_id'] = this.uom_id;
//         data['updated_at'] = this.updated_at;
//         data['updated_by'] = this.updated_by;
//         return data;
//     }
// }