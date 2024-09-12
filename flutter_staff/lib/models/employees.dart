class EmployeeModel {
  int? eMPLOYEEID;
  String? eMPCODE;
  String? fULLNAME;
  String? pHONENUMBER;
  String? eMAIL;
  String? dATEOFBIRTH;

  EmployeeModel(
      {this.eMPLOYEEID,
      this.eMPCODE,
      this.fULLNAME,
      this.pHONENUMBER,
      this.eMAIL,
      this.dATEOFBIRTH});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    eMPLOYEEID = json['EMPLOYEE_ID'];
    eMPCODE = json['EMP_CODE'];
    fULLNAME = json['FULLNAME'];
    pHONENUMBER = json['PHONE_NUMBER'];
    eMAIL = json['EMAIL'];
    dATEOFBIRTH = json['DATE_OF_BIRTH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EMPLOYEE_ID'] = this.eMPLOYEEID;
    data['EMP_CODE'] = this.eMPCODE;
    data['FULLNAME'] = this.fULLNAME;
    data['PHONE_NUMBER'] = this.pHONENUMBER;
    data['EMAIL'] = this.eMAIL;
    data['DATE_OF_BIRTH'] = this.dATEOFBIRTH;
    return data;
  }
}