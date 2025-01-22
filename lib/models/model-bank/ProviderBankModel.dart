class ProviderBankModel {
  String? code;
  String? title;
  int? bID;
  String? logo;
  String? requesterName;
  String? requesterID;
  int? min;
  int? max;

  ProviderBankModel(
      {this.code,
      this.title,
      this.bID,
      this.logo,
      this.requesterName,
      this.requesterID,
      this.min,
      this.max});

  ProviderBankModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    title = json['Title'];
    bID = json['BID'];
    logo = json['Logo'];
    requesterName = json['RequesterName'];
    requesterID = json['RequesterID'];
    min = json['Min'];
    max = json['Max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Code'] = code;
    data['Title'] = title;
    data['BID'] = bID;
    data['Logo'] = logo;
    data['RequesterName'] = requesterName;
    data['RequesterID'] = requesterID;
    data['Min'] = min;
    data['Max'] = max;
    return data;
  }
}
