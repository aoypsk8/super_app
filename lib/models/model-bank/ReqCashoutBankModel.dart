class ReqCashoutBankModel {
  String? resultcode;
  String? resultdesc;
  String? amount;
  Data? data;

  ReqCashoutBankModel(
      {this.resultcode, this.resultdesc, this.amount, this.data});

  ReqCashoutBankModel.fromJson(Map<String, dynamic> json) {
    resultcode = json['resultcode'];
    resultdesc = json['resultdesc'];
    amount = json['Amount'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resultcode'] = resultcode;
    data['resultdesc'] = resultdesc;
    data['Amount'] = amount;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? apiToken;
  String? transID;
  String? requestorID;
  String? transCashOutID;
  String? otpRefCode;
  String? otpRefNo;
  String? otp;

  Data(
      {this.apiToken,
      this.transID,
      this.requestorID,
      this.transCashOutID,
      this.otpRefCode,
      this.otpRefNo,
      this.otp});

  Data.fromJson(Map<String, dynamic> json) {
    apiToken = json['apiToken'];
    transID = json['transID'];
    requestorID = json['requestorID'];
    transCashOutID = json['transCashOutID'];
    otpRefCode = json['otpRefCode'];
    otpRefNo = json['otpRefNo'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['apiToken'] = apiToken;
    data['transID'] = transID;
    data['requestorID'] = requestorID;
    data['transCashOutID'] = transCashOutID;
    data['otpRefCode'] = otpRefCode;
    data['otpRefNo'] = otpRefNo;
    data['otp'] = otp;
    return data;
  }
}
