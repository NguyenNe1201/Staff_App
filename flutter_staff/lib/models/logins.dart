class RequestOTP {
  String? emp_code;
  int? emp_id;
  String? gmail;
  String? phone;
  String? otp;

  RequestOTP({this.emp_code,this.emp_id,this.gmail,this.phone,this.otp});

  RequestOTP.fromJson(Map<String, dynamic> json) {
    emp_code = json['Emp_code'];
      emp_id = json['Emp_id'];
    gmail = json['Gmail'];
    phone = json['Phone'];
    otp = json['Otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Emp_code'] = this.emp_code;
    data['Emp_id'] = this.emp_id;
    
    data['Gmail'] = this.gmail;
    data['Phone'] = this.phone;
    data['Otp'] = this.otp;
    return data;
  }
}
class RequestByAccount {
  String? emp_code;
  int? emp_id;

  RequestByAccount({this.emp_code,this.emp_id});

  RequestByAccount.fromJson(Map<String, dynamic> json) {
    emp_code = json['emp_code'];
   emp_id = json['emp_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emp_code'] = this.emp_code;
    data['emp_id'] = this.emp_id;
    return data;
  }
}

