class GenerateQrModel {
  String? transID;
  String? qrType;
  String? qrstr;
  String? resultCode;
  String? resultDesc;
  String? provider;
  String? target;

  GenerateQrModel(
      {this.transID,
      this.qrType,
      this.qrstr,
      this.resultCode,
      this.resultDesc,
      this.provider,
      this.target});

  GenerateQrModel.fromJson(Map<String, dynamic> json) {
    transID = json['transID'];
    qrType = json['qrType'];
    qrstr = json['qrstr'];
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    provider = json['Provider'];
    target = json['Target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transID'] = transID;
    data['qrType'] = qrType;
    data['qrstr'] = qrstr;
    data['resultCode'] = resultCode;
    data['resultDesc'] = resultDesc;
    data['Provider'] = provider;
    data['Target'] = target;
    return data;
  }
}
