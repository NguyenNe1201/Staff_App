
class CalLeaveModel {
  int? cLID;
  int? lEAVEID;
  int? eMPLOYEEID;
  int? kINDLEAVEID;
  String? lEAVESTARTDATE;
  double? t1;
  double? t2;
  double? t3;
  double? t4;
  double? t5;
  double? t6;
  double? t7;
  double? t8;
  double? t9;
  double? t10;
  double? t11;
  double? t12;
  double? tONGCONG;
  double? aNUALLEAVEDAY;
  double? lASTYEARAL;
  double? rEMAIN;

  CalLeaveModel(
      {this.cLID,
      this.lEAVEID,
      this.eMPLOYEEID,
      this.kINDLEAVEID,
      this.lEAVESTARTDATE,
      this.t1,
      this.t2,
      this.t3,
      this.t4,
      this.t5,
      this.t6,
      this.t7,
      this.t8,
      this.t9,
      this.t10,
      this.t11,
      this.t12,
      this.tONGCONG,
      this.aNUALLEAVEDAY,
      this.lASTYEARAL,
      this.rEMAIN});

  CalLeaveModel.fromJson(Map<String, dynamic> json) {
    cLID = json['CL_ID'];
    lEAVEID = json['LEAVE_ID'];
    eMPLOYEEID = json['EMPLOYEE_ID'];
    kINDLEAVEID = json['KINDLEAVE_ID'];
    lEAVESTARTDATE = json['LEAVE_STARTDATE'];
    t1 = json['T1'];
    t2 = json['T2'];
    t3 = json['T3'];
    t4 = json['T4'];
    t5 = json['T5'];
    t6 = json['T6'];
    t7 = json['T7'];
    t8 = json['T8'];
    t9 = json['T9'];
    t10 = json['T10'];
    t11 = json['T11'];
    t12 = json['T12'];
    tONGCONG = json['TONGCONG'];
    aNUALLEAVEDAY = json['ANUAL_LEAVE_DAY'];
    lASTYEARAL = json['LASTYEAR_AL'];
    rEMAIN = json['REMAIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CL_ID'] = this.cLID;
    data['LEAVE_ID'] = this.lEAVEID;
    data['EMPLOYEE_ID'] = this.eMPLOYEEID;
    data['KINDLEAVE_ID'] = this.kINDLEAVEID;
    data['LEAVE_STARTDATE'] = this.lEAVESTARTDATE;
    data['T1'] = this.t1;
    data['T2'] = this.t2;
    data['T3'] = this.t3;
    data['T4'] = this.t4;
    data['T5'] = this.t5;
    data['T6'] = this.t6;
    data['T7'] = this.t7;
    data['T8'] = this.t8;
    data['T9'] = this.t9;
    data['T10'] = this.t10;
    data['T11'] = this.t11;
    data['T12'] = this.t12;
    data['TONGCONG'] = this.tONGCONG;
    data['ANUAL_LEAVE_DAY'] = this.aNUALLEAVEDAY;
    data['LASTYEAR_AL'] = this.lASTYEARAL;
    data['REMAIN'] = this.rEMAIN;
    return data;
  }
}
// ----------------------- list leave moel employee -------------
class ListLeaveModel {
  int? lEAVEID;
  int? eMPLOYEEID;
  int? kINDLEAVEID;
  int? hOURS;
  String? lEAVESTARTDATE;
  String? lEAVEENDDATE;
  String? rEASON;
  int? aNNUALLEAVEUSED;
  String? cOMMONTH;
  String? cOMYEAR;
  String? cOMYEARMONTH;
  int? sTATUSL;
  String? fULLNAME;
  String? eMPCODE;
  int? sUPSTATUS;
  String? sUPDATETIME;
  int? mANSTATUS;
  String? mANDATETIME;
  int? dIRSTATUS;
  String? dIRDATETIME;
  bool? cHECKEDTODATE;
  String? nAMELEAVEVI;
  String? nAMELEAVEEN;

  ListLeaveModel(
      {this.lEAVEID,
      this.eMPLOYEEID,
      this.kINDLEAVEID,
      this.hOURS,
      this.lEAVESTARTDATE,
      this.lEAVEENDDATE,
      this.rEASON,
      this.aNNUALLEAVEUSED,
      this.cOMMONTH,
      this.cOMYEAR,
      this.cOMYEARMONTH,
      this.sTATUSL,
      this.fULLNAME,
      this.eMPCODE,
      this.sUPSTATUS,
      this.sUPDATETIME,
      this.mANSTATUS,
      this.mANDATETIME,
      this.dIRSTATUS,
      this.dIRDATETIME,
      this.cHECKEDTODATE,
      this.nAMELEAVEVI,
      this.nAMELEAVEEN});

  ListLeaveModel.fromJson(Map<String, dynamic> json) {
    lEAVEID = json['LEAVE_ID'];
    eMPLOYEEID = json['EMPLOYEE_ID'];
    kINDLEAVEID = json['KINDLEAVE_ID'];
    hOURS = json['HOURS'];
    lEAVESTARTDATE = json['LEAVE_STARTDATE'];
    lEAVEENDDATE = json['LEAVE_ENDDATE'];
    rEASON = json['REASON'];
    aNNUALLEAVEUSED = json['ANNUAL_LEAVE_USED'];
    cOMMONTH = json['COM_MONTH'];
    cOMYEAR = json['COM_YEAR'];
    cOMYEARMONTH = json['COM_YEAR_MONTH'];
    sTATUSL = json['STATUS_L'];
    fULLNAME = json['FULLNAME'];
    eMPCODE = json['EMP_CODE'];
    sUPSTATUS = json['SUP_STATUS'];
    sUPDATETIME = json['SUP_DATETIME'];
    mANSTATUS = json['MAN_STATUS'];
    mANDATETIME = json['MAN_DATETIME'];
    dIRSTATUS = json['DIR_STATUS'];
    dIRDATETIME = json['DIR_DATETIME'];
    cHECKEDTODATE = json['CHECKED_TODATE'];
    nAMELEAVEVI = json['NAMELEAVE_VI'];
    nAMELEAVEEN = json['NAMELEAVE_EN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LEAVE_ID'] = this.lEAVEID;
    data['EMPLOYEE_ID'] = this.eMPLOYEEID;
    data['KINDLEAVE_ID'] = this.kINDLEAVEID;
    data['HOURS'] = this.hOURS;
    data['LEAVE_STARTDATE'] = this.lEAVESTARTDATE;
    data['LEAVE_ENDDATE'] = this.lEAVEENDDATE;
    data['REASON'] = this.rEASON;
    data['ANNUAL_LEAVE_USED'] = this.aNNUALLEAVEUSED;
    data['COM_MONTH'] = this.cOMMONTH;
    data['COM_YEAR'] = this.cOMYEAR;
    data['COM_YEAR_MONTH'] = this.cOMYEARMONTH;
    data['STATUS_L'] = this.sTATUSL;
    data['FULLNAME'] = this.fULLNAME;
    data['EMP_CODE'] = this.eMPCODE;
    data['SUP_STATUS'] = this.sUPSTATUS;
    data['SUP_DATETIME'] = this.sUPDATETIME;
    data['MAN_STATUS'] = this.mANSTATUS;
    data['MAN_DATETIME'] = this.mANDATETIME;
    data['DIR_STATUS'] = this.dIRSTATUS;
    data['DIR_DATETIME'] = this.dIRDATETIME;
    data['CHECKED_TODATE'] = this.cHECKEDTODATE;
    data['NAMELEAVE_VI'] = this.nAMELEAVEVI;
    data['NAMELEAVE_EN'] = this.nAMELEAVEEN;
    return data;
  }
}
class KindLeaveModel {
  int? kINDLEAVEID;
  String? nAMELEAVEVI;
  String? nAMELEAVEEN;
  String? pAYROLL;

  KindLeaveModel(
      {this.kINDLEAVEID, this.nAMELEAVEVI, this.nAMELEAVEEN, this.pAYROLL});

  KindLeaveModel.fromJson(Map<String, dynamic> json) {
    kINDLEAVEID = json['KINDLEAVE_ID'];
    nAMELEAVEVI = json['NAMELEAVE_VI'];
    nAMELEAVEEN = json['NAMELEAVE_EN'];
    pAYROLL = json['PAYROLL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['KINDLEAVE_ID'] = this.kINDLEAVEID;
    data['NAMELEAVE_VI'] = this.nAMELEAVEVI;
    data['NAMELEAVE_EN'] = this.nAMELEAVEEN;
    data['PAYROLL'] = this.pAYROLL;
    return data;
  }
}