class EmployeeViewModel {
  int? eMPLOYEEID;
  String? eMPCODE;
  String? fULLNAME;
  String? pHONENUMBER;
  String? eMAIL;
  String? dATEOFBIRTH;
  int? dEPARTMENTID;
  String? dEPARTMENTNAMEVI;
  String? dEPARTMENTNAMEEN;
  String? titleNameVi;
  String? titleNameEn;
  String? sECTIONNAMEEN;
  String? sECTIONNAMEVI;
  String? uSERNAME;
  String? pASSWORD;
  String? sEX;

  EmployeeViewModel(
      {this.eMPLOYEEID,
      this.eMPCODE,
      this.fULLNAME,
      this.pHONENUMBER,
      this.eMAIL,
      this.dATEOFBIRTH,
      this.dEPARTMENTID,
      this.dEPARTMENTNAMEVI,
      this.dEPARTMENTNAMEEN,
      this.titleNameVi,
      this.titleNameEn,
      this.sECTIONNAMEEN,
      this.sECTIONNAMEVI,
      this.uSERNAME,
      this.pASSWORD,
      this.sEX});

  EmployeeViewModel.fromJson(Map<String, dynamic> json) {
    eMPLOYEEID = json['EMPLOYEE_ID'];
    eMPCODE = json['EMP_CODE'];
    fULLNAME = json['FULLNAME'];
    pHONENUMBER = json['PHONE_NUMBER'];
    eMAIL = json['EMAIL'];
    dATEOFBIRTH = json['DATE_OF_BIRTH'];
    dEPARTMENTID = json['DEPARTMENT_ID'];
    dEPARTMENTNAMEVI = json['DEPARTMENT_NAME_VI'];
    dEPARTMENTNAMEEN = json['DEPARTMENT_NAME_EN'];
    titleNameVi = json['TitleName_vi'];
    titleNameEn = json['TitleName_en'];
    sECTIONNAMEEN = json['SECTION_NAME_EN'];
    sECTIONNAMEVI = json['SECTION_NAME_VI'];
    uSERNAME = json['USERNAME'];
    pASSWORD = json['PASS_WORD'];
    sEX = json['SEX'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EMPLOYEE_ID'] = this.eMPLOYEEID;
    data['EMP_CODE'] = this.eMPCODE;
    data['FULLNAME'] = this.fULLNAME;
    data['PHONE_NUMBER'] = this.pHONENUMBER;
    data['EMAIL'] = this.eMAIL;
    data['DATE_OF_BIRTH'] = this.dATEOFBIRTH;
    data['DEPARTMENT_ID'] = this.dEPARTMENTID;
    data['DEPARTMENT_NAME_VI'] = this.dEPARTMENTNAMEVI;
    data['DEPARTMENT_NAME_EN'] = this.dEPARTMENTNAMEEN;
    data['TitleName_vi'] = this.titleNameVi;
    data['TitleName_en'] = this.titleNameEn;
    data['SECTION_NAME_EN'] = this.sECTIONNAMEEN;
    data['SECTION_NAME_VI'] = this.sECTIONNAMEVI;
    data['USERNAME'] = this.uSERNAME;
    data['PASS_WORD'] = this.pASSWORD;
    data['SEX'] = this.sEX;
    return data;
  }
}
