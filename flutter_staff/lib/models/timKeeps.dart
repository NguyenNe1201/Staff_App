class TimeKeepModel {
  int? eMPLOYEEID;
  String? eMPCODE;
  String? dATENAME;
  String? dATEOFMONTH;
  String? tIMECHECKIN;
  String? tIMECHECKOUT;
  double? hOURWORK;
  double? oTWORK;
  double? oT200WORK;
  double? nIGHTTIME;
  double? aNUALLEAVE;
  double? wEDFULLEAVE;
  double? oTHERLEAVE;
  double? oTHOLIDAY;
  String? rEMARK;
  double? dAYOFF;

  TimeKeepModel(
      {this.eMPLOYEEID,
      this.eMPCODE,
      this.dATENAME,
      this.dATEOFMONTH,
      this.tIMECHECKIN,
      this.tIMECHECKOUT,
      this.hOURWORK,
      this.oTWORK,
      this.oT200WORK,
      this.nIGHTTIME,
      this.aNUALLEAVE,
      this.wEDFULLEAVE,
      this.oTHERLEAVE,
      this.oTHOLIDAY,
      this.rEMARK,
      this.dAYOFF});

  TimeKeepModel.fromJson(Map<String, dynamic> json) {
    eMPLOYEEID = json['EMPLOYEE_ID'] as int?;
    eMPCODE = json['EMP_CODE'] as String?;
    dATENAME = json['DATENAME'] as String?;
    dATEOFMONTH = json['DATEOFMONTH'] as String?;
    tIMECHECKIN = json['TIME_CHECKIN'] as String?;
    tIMECHECKOUT = json['TIME_CHECKOUT'] as String?;
    hOURWORK = (json['HOUR_WORK'] as num?)?.toDouble();
    oTWORK = (json['OT_WORK'] as num?)?.toDouble();
    oT200WORK = (json['OT200_WORK'] as num?)?.toDouble();
    nIGHTTIME = (json['NIGHT_TIME'] as num?)?.toDouble();
    aNUALLEAVE = (json['ANUAL_LEAVE'] as num?)?.toDouble();
    wEDFULLEAVE = (json['WED_FUL_LEAVE'] as num?)?.toDouble();
    oTHERLEAVE = (json['OTHER_LEAVE'] as num?)?.toDouble();
    oTHOLIDAY = (json['OT_HOLIDAY'] as num?)?.toDouble();
    rEMARK = json['REMARK'] as String?;
    dAYOFF = (json['DAYOFF'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EMPLOYEE_ID'] = this.eMPLOYEEID;
    data['EMP_CODE'] = this.eMPCODE;
    data['DATENAME'] = this.dATENAME;
    data['DATEOFMONTH'] = this.dATEOFMONTH;
    data['TIME_CHECKIN'] = this.tIMECHECKIN;
    data['TIME_CHECKOUT'] = this.tIMECHECKOUT;
    data['HOUR_WORK'] = this.hOURWORK;
    data['OT_WORK'] = this.oTWORK;
    data['OT200_WORK'] = this.oT200WORK;
    data['NIGHT_TIME'] = this.nIGHTTIME;
    data['ANUAL_LEAVE'] = this.aNUALLEAVE;
    data['WED_FUL_LEAVE'] = this.wEDFULLEAVE;
    data['OTHER_LEAVE'] = this.oTHERLEAVE;
    data['OT_HOLIDAY'] = this.oTHOLIDAY;
    data['REMARK'] = this.rEMARK;
    data['DAYOFF'] = this.dAYOFF;
    return data;
  }
}
   double? _convertToDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return null;
  }