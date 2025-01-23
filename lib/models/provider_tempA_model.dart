class ProviderTempAModel {
  String? code;
  String? title;
  int? eWid;
  String? logo;
  String? part;
  String? fee;
  String? partId;

  ProviderTempAModel({this.code, this.title, this.eWid, this.logo, this.part, this.partId});

  ProviderTempAModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    title = json['Title'];
    eWid = json['EWid'];
    logo = json['Logo'];
    part = json['Part'];
    fee = json['Fee'];
    partId = json['PartId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Code'] = code;
    data['Title'] = title;
    data['EWid'] = eWid;
    data['Logo'] = logo;
    data['Part'] = part;
    data['Fee'] = fee;
    data['PartId'] = partId;
    return data;
  }
}

class Provseperate {
  String? name;
  List<ProviderTempAModel>? lists;
  Provseperate({this.name, this.lists});
}

class RecentTempAModel {
  String? accNo;
  String? accName;

  RecentTempAModel({this.accNo, this.accName});

  RecentTempAModel.fromJson(Map<String, dynamic> json) {
    accNo = json['AccNo'];
    accName = json['AccName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AccNo'] = accNo;
    data['AccName'] = accName;
    return data;
  }
}
