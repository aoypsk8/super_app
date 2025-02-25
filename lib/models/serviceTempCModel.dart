class ServiceTempCModel {
  String? name;
  bool? status;
  String? groupTelecom;
  String? groupLogo;
  String? logo;
  String? url;
  String? description;

  ServiceTempCModel(
      {this.name,
      this.status,
      this.groupTelecom,
      this.groupLogo,
      this.logo,
      this.url,
      this.description});

  ServiceTempCModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    status = json['Status'];
    groupTelecom = json['GroupTelecom'];
    groupLogo = json['GroupLogo'];
    logo = json['Logo'];
    // url = json['Url'];
    url = json['UrlNew'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Status'] = status;
    data['GroupTelecom'] = groupTelecom;
    data['GroupLogo'] = groupLogo;
    data['Logo'] = logo;
    // data['Url'] = url;
    data['UrlNew'] = url;
    data['Description'] = description;
    return data;
  }
}
