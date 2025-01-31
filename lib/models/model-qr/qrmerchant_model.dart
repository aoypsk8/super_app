class QrModel {
  String? transID;
  String? logoUrl;
  String? qrType;
  String? shopName;
  String? merchantName;
  String? merchantMobile;
  String? transAmount;
  String? fee;
  String? resultCode;
  String? phoneUser;
  String? target;
  String? resultDesc;
  String? provider;
  String? remark;
  String? billNumber;
  String? paymentTypeId;
  String? refNo;
  String? feeAmountConsumer;

  QrModel(
      {this.transID,
      this.logoUrl,
      this.qrType,
      this.shopName,
      this.merchantName,
      this.merchantMobile,
      this.transAmount,
      this.fee,
      this.resultCode,
      this.phoneUser,
      this.target,
      this.resultDesc,
      this.provider,
      this.remark,
      this.billNumber,
      this.paymentTypeId,
      this.refNo,
      this.feeAmountConsumer});

  QrModel.fromJson(Map<String, dynamic> json) {
    transID = json['transID'];
    logoUrl = json['logo_url'];
    qrType = json['qrType'];
    shopName = json['shopName'];
    merchantName = json['merchantName'];
    merchantMobile = json['merchantMobile'];
    transAmount = json['transAmount'];
    fee = json['fee'];
    resultCode = json['resultCode'];
    phoneUser = json['PhoneUser'];
    target = json['Target'];
    resultDesc = json['resultDesc'];
    provider = json['Provider'];
    remark = json['Remark'];
    billNumber = json['billNumber'];
    paymentTypeId = json['paymentTypeId'];
    refNo = json['refNo'];
    feeAmountConsumer = json['FeeAmount_Consumer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transID'] = this.transID;
    data['logo_url'] = this.logoUrl;
    data['qrType'] = this.qrType;
    data['shopName'] = this.shopName;
    data['merchantName'] = this.merchantName;
    data['merchantMobile'] = this.merchantMobile;
    data['transAmount'] = this.transAmount;
    data['fee'] = this.fee;
    data['resultCode'] = this.resultCode;
    data['PhoneUser'] = this.phoneUser;
    data['Target'] = this.target;
    data['resultDesc'] = this.resultDesc;
    data['Provider'] = this.provider;
    data['Remark'] = this.remark;
    data['billNumber'] = this.billNumber;
    data['paymentTypeId'] = this.paymentTypeId;
    data['refNo'] = this.refNo;
    data['FeeAmount_Consumer'] = this.feeAmountConsumer;
    return data;
  }
}
