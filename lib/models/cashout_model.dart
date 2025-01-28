class RequestCashoutModel {
  String? apiToken;
  String? transID;
  String? requestorID;
  String? transCashOutID;
  String? otpRefNo;
  String? otpRefCode;
  String? transAmount;
  String? transRemark;

  RequestCashoutModel({this.apiToken, this.transID, this.requestorID, this.transCashOutID, this.otpRefNo, this.otpRefCode, this.transAmount, this.transRemark});

  RequestCashoutModel.fromJson(Map<String, dynamic> json) {
    apiToken = json['apiToken'];
    transID = json['transID'];
    requestorID = json['requestorID'];
    transCashOutID = json['transCashOutID'];
    otpRefNo = json['otpRefNo'];
    otpRefCode = json['otpRefCode'];
    transAmount = json['transAmount'].toString();
    transRemark = json['transRemark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apiToken'] = this.apiToken;
    data['transID'] = this.transID;
    data['requestorID'] = this.requestorID;
    data['transCashOutID'] = this.transCashOutID;
    data['otpRefNo'] = this.otpRefNo;
    data['otpRefCode'] = this.otpRefCode;
    data['transAmount'] = this.transAmount;
    data['transRemark'] = this.transRemark;
    return data;
  }
}
