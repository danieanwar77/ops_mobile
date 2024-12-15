/// id : 55
/// so_code : "0005/SO/11/2024"
/// id_mobile : null
/// employee_id : 1042
/// trans_date : "2024-11-29"
/// notes : "noted"
/// so_category_id : 1
/// so_type_id : 2
/// company_acc_id : 38
/// client_category_id : 1
/// client_type_id : 1
/// company_type_id : 2
/// sbu_id : 1
/// pic_marketing_id : 1100
/// pic_marketing_co_id : 1010
/// commodity_id : 1
/// project_tittle : "okee nah"
/// grand_total : "0.00"
/// modules_id : 7
/// action_status_id : 6
/// status_approval_id : 3
/// level_approval_id : null
/// flag_final : 0
/// flag_escalation : 0
/// flag_active : 1
/// is_uploaded : 0
/// created_by : 43
/// created_at : "2024-11-29T00:56:49.000000Z"
/// updated_by : 43
/// updated_at : "2024-11-30T01:50:51.000000Z"
/// uploaded_at : null
/// approved_by : 43
/// approved_at : "2024-11-30 08:50:51"
/// lead_account : {"id":38,"id_mobile":null,"type_lead_id":2,"group_lead_id":1,"lead_code":"0004/Leads/03/2024","account_code":"A/2023/12/20/0002","account_created_at":null,"employee_id":1042,"trans_date":"2024-03-23","company_name":"PT Rifki Maju","account_sources_id":1,"account_info_id":1,"pic_marketing_id":1042,"company_info_id":1,"client_category_id":1,"client_segment_id":null,"client_type_id":1,"company_type_id":2,"industry_id":1,"notes":null,"modules_id":2,"action_status_id":6,"status_approval_id":3,"level_approval_id":null,"flag_final":0,"flag_escalation":0,"flag_active":1,"is_uploaded":0,"created_by":43,"created_at":"2024-03-22T17:48:05.000000Z","updated_by":43,"updated_at":"2024-11-29T03:41:29.000000Z","uploaded_at":null,"approved_by":null,"approved_at":null}

class TSo {
  TSo({
      num? id,
      String? soCode,
      dynamic idMobile, 
      num? employeeId,
      String? transDate,
      String? notes,
      num? soCategoryId,
      num? soTypeId,
      num? companyAccId,
      num? clientCategoryId,
      num? clientTypeId,
      num? companyTypeId,
      num? sbuId,
      num? picMarketingId,
      num? picMarketingCoId,
      num? commodityId,
      String? projectTittle,
      String? grandTotal,
      num? modulesId,
      num? actionStatusId,
      num? statusApprovalId,
      dynamic levelApprovalId, 
      num? flagFinal,
      num? flagEscalation,
      num? flagActive,
      num? isUploaded,
      num? createdBy,
      String? createdAt,
      num? updatedBy,
      String? updatedAt,
      dynamic uploadedAt, 
      num? approvedBy,
      String? approvedAt,
      LeadAccount? leadAccount,}){
    _id = id;
    _soCode = soCode;
    _idMobile = idMobile;
    _employeeId = employeeId;
    _transDate = transDate;
    _notes = notes;
    _soCategoryId = soCategoryId;
    _soTypeId = soTypeId;
    _companyAccId = companyAccId;
    _clientCategoryId = clientCategoryId;
    _clientTypeId = clientTypeId;
    _companyTypeId = companyTypeId;
    _sbuId = sbuId;
    _picMarketingId = picMarketingId;
    _picMarketingCoId = picMarketingCoId;
    _commodityId = commodityId;
    _projectTittle = projectTittle;
    _grandTotal = grandTotal;
    _modulesId = modulesId;
    _actionStatusId = actionStatusId;
    _statusApprovalId = statusApprovalId;
    _levelApprovalId = levelApprovalId;
    _flagFinal = flagFinal;
    _flagEscalation = flagEscalation;
    _flagActive = flagActive;
    _isUploaded = isUploaded;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
    _uploadedAt = uploadedAt;
    _approvedBy = approvedBy;
    _approvedAt = approvedAt;
    _leadAccount = leadAccount;
}

  TSo.fromJson(dynamic json) {
    _id = json['id'];
    _soCode = json['so_code'];
    _idMobile = json['id_mobile'];
    _employeeId = json['employee_id'];
    _transDate = json['trans_date'];
    _notes = json['notes'];
    _soCategoryId = json['so_category_id'];
    _soTypeId = json['so_type_id'];
    _companyAccId = json['company_acc_id'];
    _clientCategoryId = json['client_category_id'];
    _clientTypeId = json['client_type_id'];
    _companyTypeId = json['company_type_id'];
    _sbuId = json['sbu_id'];
    _picMarketingId = json['pic_marketing_id'];
    _picMarketingCoId = json['pic_marketing_co_id'];
    _commodityId = json['commodity_id'];
    _projectTittle = json['project_tittle'];
    _grandTotal = json['grand_total'];
    _modulesId = json['modules_id'];
    _actionStatusId = json['action_status_id'];
    _statusApprovalId = json['status_approval_id'];
    _levelApprovalId = json['level_approval_id'];
    _flagFinal = json['flag_final'];
    _flagEscalation = json['flag_escalation'];
    _flagActive = json['flag_active'];
    _isUploaded = json['is_uploaded'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
    _uploadedAt = json['uploaded_at'];
    _approvedBy = json['approved_by'];
    _approvedAt = json['approved_at'];
    _leadAccount = json['lead_account'] != null ? LeadAccount.fromJson(json['lead_account']) : null;
  }
  num? _id;
  String? _soCode;
  dynamic _idMobile;
  num? _employeeId;
  String? _transDate;
  String? _notes;
  num? _soCategoryId;
  num? _soTypeId;
  num? _companyAccId;
  num? _clientCategoryId;
  num? _clientTypeId;
  num? _companyTypeId;
  num? _sbuId;
  num? _picMarketingId;
  num? _picMarketingCoId;
  num? _commodityId;
  String? _projectTittle;
  String? _grandTotal;
  num? _modulesId;
  num? _actionStatusId;
  num? _statusApprovalId;
  dynamic _levelApprovalId;
  num? _flagFinal;
  num? _flagEscalation;
  num? _flagActive;
  num? _isUploaded;
  num? _createdBy;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
  dynamic _uploadedAt;
  num? _approvedBy;
  String? _approvedAt;
  LeadAccount? _leadAccount;
TSo copyWith({  num? id,
  String? soCode,
  dynamic idMobile,
  num? employeeId,
  String? transDate,
  String? notes,
  num? soCategoryId,
  num? soTypeId,
  num? companyAccId,
  num? clientCategoryId,
  num? clientTypeId,
  num? companyTypeId,
  num? sbuId,
  num? picMarketingId,
  num? picMarketingCoId,
  num? commodityId,
  String? projectTittle,
  String? grandTotal,
  num? modulesId,
  num? actionStatusId,
  num? statusApprovalId,
  dynamic levelApprovalId,
  num? flagFinal,
  num? flagEscalation,
  num? flagActive,
  num? isUploaded,
  num? createdBy,
  String? createdAt,
  num? updatedBy,
  String? updatedAt,
  dynamic uploadedAt,
  num? approvedBy,
  String? approvedAt,
  LeadAccount? leadAccount,
}) => TSo(  id: id ?? _id,
  soCode: soCode ?? _soCode,
  idMobile: idMobile ?? _idMobile,
  employeeId: employeeId ?? _employeeId,
  transDate: transDate ?? _transDate,
  notes: notes ?? _notes,
  soCategoryId: soCategoryId ?? _soCategoryId,
  soTypeId: soTypeId ?? _soTypeId,
  companyAccId: companyAccId ?? _companyAccId,
  clientCategoryId: clientCategoryId ?? _clientCategoryId,
  clientTypeId: clientTypeId ?? _clientTypeId,
  companyTypeId: companyTypeId ?? _companyTypeId,
  sbuId: sbuId ?? _sbuId,
  picMarketingId: picMarketingId ?? _picMarketingId,
  picMarketingCoId: picMarketingCoId ?? _picMarketingCoId,
  commodityId: commodityId ?? _commodityId,
  projectTittle: projectTittle ?? _projectTittle,
  grandTotal: grandTotal ?? _grandTotal,
  modulesId: modulesId ?? _modulesId,
  actionStatusId: actionStatusId ?? _actionStatusId,
  statusApprovalId: statusApprovalId ?? _statusApprovalId,
  levelApprovalId: levelApprovalId ?? _levelApprovalId,
  flagFinal: flagFinal ?? _flagFinal,
  flagEscalation: flagEscalation ?? _flagEscalation,
  flagActive: flagActive ?? _flagActive,
  isUploaded: isUploaded ?? _isUploaded,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
  uploadedAt: uploadedAt ?? _uploadedAt,
  approvedBy: approvedBy ?? _approvedBy,
  approvedAt: approvedAt ?? _approvedAt,
  leadAccount: leadAccount ?? _leadAccount,
);
  num? get id => _id;
  String? get soCode => _soCode;
  dynamic get idMobile => _idMobile;
  num? get employeeId => _employeeId;
  String? get transDate => _transDate;
  String? get notes => _notes;
  num? get soCategoryId => _soCategoryId;
  num? get soTypeId => _soTypeId;
  num? get companyAccId => _companyAccId;
  num? get clientCategoryId => _clientCategoryId;
  num? get clientTypeId => _clientTypeId;
  num? get companyTypeId => _companyTypeId;
  num? get sbuId => _sbuId;
  num? get picMarketingId => _picMarketingId;
  num? get picMarketingCoId => _picMarketingCoId;
  num? get commodityId => _commodityId;
  String? get projectTittle => _projectTittle;
  String? get grandTotal => _grandTotal;
  num? get modulesId => _modulesId;
  num? get actionStatusId => _actionStatusId;
  num? get statusApprovalId => _statusApprovalId;
  dynamic get levelApprovalId => _levelApprovalId;
  num? get flagFinal => _flagFinal;
  num? get flagEscalation => _flagEscalation;
  num? get flagActive => _flagActive;
  num? get isUploaded => _isUploaded;
  num? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;
  dynamic get uploadedAt => _uploadedAt;
  num? get approvedBy => _approvedBy;
  String? get approvedAt => _approvedAt;
  LeadAccount? get leadAccount => _leadAccount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['so_code'] = _soCode;
    map['id_mobile'] = _idMobile;
    map['employee_id'] = _employeeId;
    map['trans_date'] = _transDate;
    map['notes'] = _notes;
    map['so_category_id'] = _soCategoryId;
    map['so_type_id'] = _soTypeId;
    map['company_acc_id'] = _companyAccId;
    map['client_category_id'] = _clientCategoryId;
    map['client_type_id'] = _clientTypeId;
    map['company_type_id'] = _companyTypeId;
    map['sbu_id'] = _sbuId;
    map['pic_marketing_id'] = _picMarketingId;
    map['pic_marketing_co_id'] = _picMarketingCoId;
    map['commodity_id'] = _commodityId;
    map['project_tittle'] = _projectTittle;
    map['grand_total'] = _grandTotal;
    map['modules_id'] = _modulesId;
    map['action_status_id'] = _actionStatusId;
    map['status_approval_id'] = _statusApprovalId;
    map['level_approval_id'] = _levelApprovalId;
    map['flag_final'] = _flagFinal;
    map['flag_escalation'] = _flagEscalation;
    map['flag_active'] = _flagActive;
    map['is_uploaded'] = _isUploaded;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    map['uploaded_at'] = _uploadedAt;
    map['approved_by'] = _approvedBy;
    map['approved_at'] = _approvedAt;
    if (_leadAccount != null) {
      map['lead_account'] = _leadAccount?.toJson();
    }
    return map;
  }

  Map<String, dynamic> toInsert() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['so_code'] = _soCode;
    map['id_mobile'] = _idMobile;
    map['employee_id'] = _employeeId;
    map['trans_date'] = _transDate;
    map['notes'] = _notes;
    map['so_category_id'] = _soCategoryId;
    map['so_type_id'] = _soTypeId;
    map['company_acc_id'] = _companyAccId;
    map['client_category_id'] = _clientCategoryId;
    map['client_type_id'] = _clientTypeId;
    map['company_type_id'] = _companyTypeId;
    map['sbu_id'] = _sbuId;
    map['pic_marketing_id'] = _picMarketingId;
    map['pic_marketing_co_id'] = _picMarketingCoId;
    map['commodity_id'] = _commodityId;
    map['project_tittle'] = _projectTittle;
    map['grand_total'] = _grandTotal;
    map['modules_id'] = _modulesId;
    map['action_status_id'] = _actionStatusId;
    map['status_approval_id'] = _statusApprovalId;
    map['level_approval_id'] = _levelApprovalId;
    map['flag_final'] = _flagFinal;
    map['flag_escalation'] = _flagEscalation;
    map['flag_active'] = _flagActive;
    map['is_uploaded'] = _isUploaded;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    map['uploaded_at'] = _uploadedAt;
    map['approved_by'] = _approvedBy;
    map['approved_at'] = _approvedAt;
    return map;
  }

}

/// id : 38
/// id_mobile : null
/// type_lead_id : 2
/// group_lead_id : 1
/// lead_code : "0004/Leads/03/2024"
/// account_code : "A/2023/12/20/0002"
/// account_created_at : null
/// employee_id : 1042
/// trans_date : "2024-03-23"
/// company_name : "PT Rifki Maju"
/// account_sources_id : 1
/// account_info_id : 1
/// pic_marketing_id : 1042
/// company_info_id : 1
/// client_category_id : 1
/// client_segment_id : null
/// client_type_id : 1
/// company_type_id : 2
/// industry_id : 1
/// notes : null
/// modules_id : 2
/// action_status_id : 6
/// status_approval_id : 3
/// level_approval_id : null
/// flag_final : 0
/// flag_escalation : 0
/// flag_active : 1
/// is_uploaded : 0
/// created_by : 43
/// created_at : "2024-03-22T17:48:05.000000Z"
/// updated_by : 43
/// updated_at : "2024-11-29T03:41:29.000000Z"
/// uploaded_at : null
/// approved_by : null
/// approved_at : null

class LeadAccount {
  LeadAccount({
      num? id,
      dynamic idMobile, 
      num? typeLeadId,
      num? groupLeadId,
      String? leadCode,
      String? accountCode,
      dynamic accountCreatedAt, 
      num? employeeId,
      String? transDate,
      String? companyName,
      num? accountSourcesId,
      num? accountInfoId,
      num? picMarketingId,
      num? companyInfoId,
      num? clientCategoryId,
      dynamic clientSegmentId, 
      num? clientTypeId,
      num? companyTypeId,
      num? industryId,
      dynamic notes, 
      num? modulesId,
      num? actionStatusId,
      num? statusApprovalId,
      dynamic levelApprovalId, 
      num? flagFinal,
      num? flagEscalation,
      num? flagActive,
      num? isUploaded,
      num? createdBy,
      String? createdAt,
      num? updatedBy,
      String? updatedAt,
      dynamic uploadedAt, 
      dynamic approvedBy, 
      dynamic approvedAt,}){
    _id = id;
    _idMobile = idMobile;
    _typeLeadId = typeLeadId;
    _groupLeadId = groupLeadId;
    _leadCode = leadCode;
    _accountCode = accountCode;
    _accountCreatedAt = accountCreatedAt;
    _employeeId = employeeId;
    _transDate = transDate;
    _companyName = companyName;
    _accountSourcesId = accountSourcesId;
    _accountInfoId = accountInfoId;
    _picMarketingId = picMarketingId;
    _companyInfoId = companyInfoId;
    _clientCategoryId = clientCategoryId;
    _clientSegmentId = clientSegmentId;
    _clientTypeId = clientTypeId;
    _companyTypeId = companyTypeId;
    _industryId = industryId;
    _notes = notes;
    _modulesId = modulesId;
    _actionStatusId = actionStatusId;
    _statusApprovalId = statusApprovalId;
    _levelApprovalId = levelApprovalId;
    _flagFinal = flagFinal;
    _flagEscalation = flagEscalation;
    _flagActive = flagActive;
    _isUploaded = isUploaded;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _updatedBy = updatedBy;
    _updatedAt = updatedAt;
    _uploadedAt = uploadedAt;
    _approvedBy = approvedBy;
    _approvedAt = approvedAt;
}

  LeadAccount.fromJson(dynamic json) {
    _id = json['id'];
    _idMobile = json['id_mobile'];
    _typeLeadId = json['type_lead_id'];
    _groupLeadId = json['group_lead_id'];
    _leadCode = json['lead_code'];
    _accountCode = json['account_code'];
    _accountCreatedAt = json['account_created_at'];
    _employeeId = json['employee_id'];
    _transDate = json['trans_date'];
    _companyName = json['company_name'];
    _accountSourcesId = json['account_sources_id'];
    _accountInfoId = json['account_info_id'];
    _picMarketingId = json['pic_marketing_id'];
    _companyInfoId = json['company_info_id'];
    _clientCategoryId = json['client_category_id'];
    _clientSegmentId = json['client_segment_id'];
    _clientTypeId = json['client_type_id'];
    _companyTypeId = json['company_type_id'];
    _industryId = json['industry_id'];
    _notes = json['notes'];
    _modulesId = json['modules_id'];
    _actionStatusId = json['action_status_id'];
    _statusApprovalId = json['status_approval_id'];
    _levelApprovalId = json['level_approval_id'];
    _flagFinal = json['flag_final'];
    _flagEscalation = json['flag_escalation'];
    _flagActive = json['flag_active'];
    _isUploaded = json['is_uploaded'];
    _createdBy = json['created_by'];
    _createdAt = json['created_at'];
    _updatedBy = json['updated_by'];
    _updatedAt = json['updated_at'];
    _uploadedAt = json['uploaded_at'];
    _approvedBy = json['approved_by'];
    _approvedAt = json['approved_at'];
  }
  num? _id;
  dynamic _idMobile;
  num? _typeLeadId;
  num? _groupLeadId;
  String? _leadCode;
  String? _accountCode;
  dynamic _accountCreatedAt;
  num? _employeeId;
  String? _transDate;
  String? _companyName;
  num? _accountSourcesId;
  num? _accountInfoId;
  num? _picMarketingId;
  num? _companyInfoId;
  num? _clientCategoryId;
  dynamic _clientSegmentId;
  num? _clientTypeId;
  num? _companyTypeId;
  num? _industryId;
  dynamic _notes;
  num? _modulesId;
  num? _actionStatusId;
  num? _statusApprovalId;
  dynamic _levelApprovalId;
  num? _flagFinal;
  num? _flagEscalation;
  num? _flagActive;
  num? _isUploaded;
  num? _createdBy;
  String? _createdAt;
  num? _updatedBy;
  String? _updatedAt;
  dynamic _uploadedAt;
  dynamic _approvedBy;
  dynamic _approvedAt;
LeadAccount copyWith({  num? id,
  dynamic idMobile,
  num? typeLeadId,
  num? groupLeadId,
  String? leadCode,
  String? accountCode,
  dynamic accountCreatedAt,
  num? employeeId,
  String? transDate,
  String? companyName,
  num? accountSourcesId,
  num? accountInfoId,
  num? picMarketingId,
  num? companyInfoId,
  num? clientCategoryId,
  dynamic clientSegmentId,
  num? clientTypeId,
  num? companyTypeId,
  num? industryId,
  dynamic notes,
  num? modulesId,
  num? actionStatusId,
  num? statusApprovalId,
  dynamic levelApprovalId,
  num? flagFinal,
  num? flagEscalation,
  num? flagActive,
  num? isUploaded,
  num? createdBy,
  String? createdAt,
  num? updatedBy,
  String? updatedAt,
  dynamic uploadedAt,
  dynamic approvedBy,
  dynamic approvedAt,
}) => LeadAccount(  id: id ?? _id,
  idMobile: idMobile ?? _idMobile,
  typeLeadId: typeLeadId ?? _typeLeadId,
  groupLeadId: groupLeadId ?? _groupLeadId,
  leadCode: leadCode ?? _leadCode,
  accountCode: accountCode ?? _accountCode,
  accountCreatedAt: accountCreatedAt ?? _accountCreatedAt,
  employeeId: employeeId ?? _employeeId,
  transDate: transDate ?? _transDate,
  companyName: companyName ?? _companyName,
  accountSourcesId: accountSourcesId ?? _accountSourcesId,
  accountInfoId: accountInfoId ?? _accountInfoId,
  picMarketingId: picMarketingId ?? _picMarketingId,
  companyInfoId: companyInfoId ?? _companyInfoId,
  clientCategoryId: clientCategoryId ?? _clientCategoryId,
  clientSegmentId: clientSegmentId ?? _clientSegmentId,
  clientTypeId: clientTypeId ?? _clientTypeId,
  companyTypeId: companyTypeId ?? _companyTypeId,
  industryId: industryId ?? _industryId,
  notes: notes ?? _notes,
  modulesId: modulesId ?? _modulesId,
  actionStatusId: actionStatusId ?? _actionStatusId,
  statusApprovalId: statusApprovalId ?? _statusApprovalId,
  levelApprovalId: levelApprovalId ?? _levelApprovalId,
  flagFinal: flagFinal ?? _flagFinal,
  flagEscalation: flagEscalation ?? _flagEscalation,
  flagActive: flagActive ?? _flagActive,
  isUploaded: isUploaded ?? _isUploaded,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  updatedBy: updatedBy ?? _updatedBy,
  updatedAt: updatedAt ?? _updatedAt,
  uploadedAt: uploadedAt ?? _uploadedAt,
  approvedBy: approvedBy ?? _approvedBy,
  approvedAt: approvedAt ?? _approvedAt,
);
  num? get id => _id;
  dynamic get idMobile => _idMobile;
  num? get typeLeadId => _typeLeadId;
  num? get groupLeadId => _groupLeadId;
  String? get leadCode => _leadCode;
  String? get accountCode => _accountCode;
  dynamic get accountCreatedAt => _accountCreatedAt;
  num? get employeeId => _employeeId;
  String? get transDate => _transDate;
  String? get companyName => _companyName;
  num? get accountSourcesId => _accountSourcesId;
  num? get accountInfoId => _accountInfoId;
  num? get picMarketingId => _picMarketingId;
  num? get companyInfoId => _companyInfoId;
  num? get clientCategoryId => _clientCategoryId;
  dynamic get clientSegmentId => _clientSegmentId;
  num? get clientTypeId => _clientTypeId;
  num? get companyTypeId => _companyTypeId;
  num? get industryId => _industryId;
  dynamic get notes => _notes;
  num? get modulesId => _modulesId;
  num? get actionStatusId => _actionStatusId;
  num? get statusApprovalId => _statusApprovalId;
  dynamic get levelApprovalId => _levelApprovalId;
  num? get flagFinal => _flagFinal;
  num? get flagEscalation => _flagEscalation;
  num? get flagActive => _flagActive;
  num? get isUploaded => _isUploaded;
  num? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  num? get updatedBy => _updatedBy;
  String? get updatedAt => _updatedAt;
  dynamic get uploadedAt => _uploadedAt;
  dynamic get approvedBy => _approvedBy;
  dynamic get approvedAt => _approvedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['id_mobile'] = _idMobile;
    map['type_lead_id'] = _typeLeadId;
    map['group_lead_id'] = _groupLeadId;
    map['lead_code'] = _leadCode;
    map['account_code'] = _accountCode;
    map['account_created_at'] = _accountCreatedAt;
    map['employee_id'] = _employeeId;
    map['trans_date'] = _transDate;
    map['company_name'] = _companyName;
    map['account_sources_id'] = _accountSourcesId;
    map['account_info_id'] = _accountInfoId;
    map['pic_marketing_id'] = _picMarketingId;
    map['company_info_id'] = _companyInfoId;
    map['client_category_id'] = _clientCategoryId;
    map['client_segment_id'] = _clientSegmentId;
    map['client_type_id'] = _clientTypeId;
    map['company_type_id'] = _companyTypeId;
    map['industry_id'] = _industryId;
    map['notes'] = _notes;
    map['modules_id'] = _modulesId;
    map['action_status_id'] = _actionStatusId;
    map['status_approval_id'] = _statusApprovalId;
    map['level_approval_id'] = _levelApprovalId;
    map['flag_final'] = _flagFinal;
    map['flag_escalation'] = _flagEscalation;
    map['flag_active'] = _flagActive;
    map['is_uploaded'] = _isUploaded;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    map['uploaded_at'] = _uploadedAt;
    map['approved_by'] = _approvedBy;
    map['approved_at'] = _approvedAt;
    return map;
  }

  Map<String, dynamic> toInsert() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['id_mobile'] = _idMobile;
    map['type_lead_id'] = _typeLeadId;
    map['group_lead_id'] = _groupLeadId;
    map['lead_code'] = _leadCode;
    map['account_code'] = _accountCode;
    map['account_created_at'] = _accountCreatedAt;
    map['employee_id'] = _employeeId;
    map['trans_date'] = _transDate;
    map['company_name'] = _companyName;
    map['account_sources_id'] = _accountSourcesId;
    map['account_info_id'] = _accountInfoId;
    map['pic_marketing_id'] = _picMarketingId;
    map['company_info_id'] = _companyInfoId;
    map['client_category_id'] = _clientCategoryId;
    map['client_segment_id'] = _clientSegmentId;
    map['client_type_id'] = _clientTypeId;
    map['company_type_id'] = _companyTypeId;
    map['industry_id'] = _industryId;
    map['notes'] = _notes;
    map['modules_id'] = _modulesId;
    map['action_status_id'] = _actionStatusId;
    map['status_approval_id'] = _statusApprovalId;
    map['level_approval_id'] = _levelApprovalId;
    map['flag_final'] = _flagFinal;
    map['flag_escalation'] = _flagEscalation;
    map['flag_active'] = _flagActive;
    map['is_uploaded'] = _isUploaded;
    map['created_by'] = _createdBy;
    map['created_at'] = _createdAt;
    map['updated_by'] = _updatedBy;
    map['updated_at'] = _updatedAt;
    map['uploaded_at'] = _uploadedAt;
    map['approved_by'] = _approvedBy;
    map['approved_at'] = _approvedAt;
    return map;
  }

}