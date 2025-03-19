class LoanModel {
  String? employeeID;
  String? name;
  String? surname;
  String? msisdn;
  String? msisdnSms;
  String? tel;
  String? msisdnMmoney;
  String? department;
  String? section;
  String? dob;
  String? swd;
  String? img;
  String? balance;

  LoanModel({
    this.employeeID,
    this.name,
    this.surname,
    this.msisdn,
    this.msisdnSms,
    this.tel,
    this.msisdnMmoney,
    this.department,
    this.section,
    this.dob,
    this.swd,
    this.img,
    this.balance,
  });

  /// Convert JSON to Dart object
  LoanModel.fromJson(Map<String, dynamic> json) {
    employeeID = json['emp_id'];
    name = json['name'];
    surname = json['surname'];
    msisdn = json['msisdn'];
    msisdnSms = json['msisdn_sms'];
    tel = json['tel'];
    msisdnMmoney = json['msisdn_mmoney'];
    department = json['department'];
    section = json['section'];
    dob = json['date_of_birth'];
    swd = json['start_work_date'];
    img = json['img'];
    balance = json['balance'];
  }

  /// Convert Dart object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emp_id'] = employeeID;
    data['name'] = name;
    data['surname'] = surname;
    data['msisdn'] = msisdn;
    data['msisdn_sms'] = msisdnSms;
    data['tel'] = tel;
    data['msisdn_mmoney'] = msisdnMmoney;
    data['department'] = department;
    data['section'] = section;
    data['date_of_birth'] = dob;
    data['start_work_date'] = swd;
    data['img'] = img;
    data['balance'] = balance;
    return data;
  }
}
