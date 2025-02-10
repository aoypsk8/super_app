class MenuModel {
  String? title;
  List<Menulists>? menulists;
  MenuModel({this.title, this.menulists});
  MenuModel.fromJson(Map json) {
    title = json['Title'];
    if (json['Dashboards'] != null) {
      menulists = [];
      json['Dashboards'].forEach((dashboard) {
        if (dashboard['menulists'] != null) {
          dashboard['menulists'].forEach((v) {
            menulists!.add(Menulists.fromJson(v));
          });
        }
      });
    }
  }

  Map toJson() {
    final Map data = {};
    data['Title'] = title;
    if (menulists != null) {
      data['menulists'] = menulists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Menulists {
  int? appid;
  String? groupNameEN;
  String? groupNameLA;
  String? groupNameVT;
  String? groupNameCH;
  bool? status;
  String? description;
  String? url;
  String? logo;
  int? indexs;
  String? mainGroup;
  String? template;
  bool? quick;
  bool? point;
  String? dashboard;

  Menulists({
    this.appid,
    this.groupNameEN,
    this.groupNameLA,
    this.groupNameVT,
    this.groupNameCH,
    this.status,
    this.description,
    this.url,
    this.logo,
    this.indexs,
    this.mainGroup,
    this.template,
    this.quick,
    this.point,
    this.dashboard,
  });

  Menulists.fromJson(Map json) {
    appid = json['appid'];
    groupNameEN = json['GroupName_EN'];
    groupNameLA = json['GroupName_LA'];
    groupNameVT = json['GroupName_VT'];
    groupNameCH = json['GroupName_CH'];
    status = json['Status'];
    description = json['Description'];
    url = json['UrlNew'];
    logo = json['Logo'];
    indexs = json['Indexs'];
    mainGroup = json['MainGroup'];
    template = json['Template'];
    quick = json['Quick'];
    point = json['Point'];
    dashboard = json['Dashboard'];
  }

  Map toJson() {
    final Map data = {};
    data['appid'] = appid;
    data['GroupName_EN'] = groupNameEN;
    data['GroupName_LA'] = groupNameLA;
    data['GroupName_VT'] = groupNameVT;
    data['GroupName_CH'] = groupNameCH;
    data['Status'] = status;
    data['Description'] = description;
    data['UrlNew'] = url;
    data['Logo'] = logo;
    data['Indexs'] = indexs;
    data['MainGroup'] = mainGroup;
    data['Template'] = template;
    data['Quick'] = quick;
    data['Point'] = point;
    data['Dashboard'] = dashboard;
    return data;
  }
}
