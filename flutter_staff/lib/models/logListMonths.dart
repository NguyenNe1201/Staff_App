
class LogListMonthModel {
  String? eMPCODE;
  String? fULLNAME;
  String? dATECHECK;
  String? tIMECHECK;
  String? tIMETEMP;
  String? nM;
  String? eVENTTYPE;
  int? tNAKEY;

  LogListMonthModel(
    {
      this.eMPCODE,
      this.fULLNAME,
      this.dATECHECK,
      this.tIMECHECK,
      this.tIMETEMP,
      this.nM,
      this.eVENTTYPE,
      this.tNAKEY
    });
  LogListMonthModel.fromJson(Map<String, dynamic> json) {
    eMPCODE = json['EMP_CODE'];
    fULLNAME = json['FULLNAME'];
    dATECHECK = json['DATECHECK'];
    tIMECHECK = json['TIMECHECK'];
    tIMETEMP = json['TIME_TEMP'];
    nM = json['NM'];
    eVENTTYPE = json['EVENT_TYPE'];
    tNAKEY = json['TNAKEY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EMP_CODE'] = this.eMPCODE;
    data['FULLNAME'] = this.fULLNAME;
    data['DATECHECK'] = this.dATECHECK;
    data['TIMECHECK'] = this.tIMECHECK;
    data['TIME_TEMP'] = this.tIMETEMP;
    data['NM'] = this.nM;
    data['EVENT_TYPE'] = this.eVENTTYPE;
    data['TNAKEY'] = this.tNAKEY;
    return data;
  }
}