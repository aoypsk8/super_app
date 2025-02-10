class ProviderTempBModel {
  int? leasID;
  String? nameCode;
  String? nameEn;
  String? nameLa;
  String? logo;
  String? prefixTranID;
  String? fee;
  int? providerID;
  int? eWid;

  ProviderTempBModel(
      {this.leasID,
      this.nameCode,
      this.nameEn,
      this.nameLa,
      this.logo,
      this.prefixTranID,
      this.fee,
      this.providerID});

  ProviderTempBModel.fromJson(Map<String, dynamic> json) {
    leasID = json['leasid'];
    nameCode = json['Name_code'];
    nameEn = json['Name_en'];
    nameLa = json['Name_la'];
    logo = json['Logo'];
    prefixTranID = json['PrefixTranID'];
    fee = json['Fee'];
    providerID = json['ProviderID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leasid'] = leasID;
    data['Name_code'] = nameCode;
    data['Name_en'] = nameEn;
    data['Name_la'] = nameLa;
    data['Logo'] = logo;
    data['PrefixTranID'] = prefixTranID;
    data['Fee'] = fee;
    data['ProviderID'] = providerID;
    return data;
  }
}

class RecentTempBModel {
  String? telephone;
  String? serviceNumber;

  String? accName;
  String? accNo;

  RecentTempBModel(
      {this.telephone, this.serviceNumber, this.accNo, this.accName});

  RecentTempBModel.fromJson(Map<String, dynamic> json) {
    telephone = json['Telephone'];
    serviceNumber = json['ServiceNumber'];
    accNo = json['AccNo'];
    accName = json['AccName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Telephone'] = telephone;
    data['ServiceNumber'] = serviceNumber;
    data['AccNo'] = accNo;
    data['AccName'] = accName;
    return data;
  }
}
