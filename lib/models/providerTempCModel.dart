class ProviderTempCModel {
  String? groupTelecom;
  String? groupLogo;
  int? discount;

  ProviderTempCModel({this.groupTelecom, this.groupLogo, this.discount});

  ProviderTempCModel.fromJson(Map<String, dynamic> json) {
    groupTelecom = json['GroupTelecom'];
    groupLogo = json['GroupLogo'];
    discount = json['Discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GroupTelecom'] = groupTelecom;
    data['GroupLogo'] = groupLogo;
    data['Discount'] = discount;
    return data;
  }
}
