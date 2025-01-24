class MenuModel {
  int? index;
  String? title;
  List<Menulists>? menulists;

  MenuModel({this.index, this.title, this.menulists});

  MenuModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    title = json['title'];
    if (json['menulists'] != null) {
      menulists = <Menulists>[];
      json['menulists'].forEach((v) {
        menulists!.add(Menulists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['title'] = title;
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

  Menulists(
      {this.appid,
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
      this.point});

  Menulists.fromJson(Map<String, dynamic> json) {
    appid = json['appid'];
    groupNameEN = json['GroupName_EN'];
    groupNameLA = json['GroupName_LA'];
    groupNameVT = json['GroupName_VT'];
    groupNameCH = json['GroupName_CH'];
    status = json['Status'];
    description = json['Description'];
    // url = json['Url'];
    url = json['UrlNew'];
    logo = json['Logo'];
    indexs = json['Indexs'];
    mainGroup = json['MainGroup'];
    template = json['Template'];
    quick = json['Quick'];
    point = json['Point'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appid'] = appid;
    data['GroupName_EN'] = groupNameEN;
    data['GroupName_LA'] = groupNameLA;
    data['GroupName_VT'] = groupNameVT;
    data['GroupName_CH'] = groupNameCH;
    data['Status'] = status;
    data['Description'] = description;
    // data['Url'] = url;
    data['UrlNew'] = url;
    data['Logo'] = logo;
    data['Indexs'] = indexs;
    data['MainGroup'] = mainGroup;
    data['Template'] = template;
    data['Quick'] = quick;
    data['Point'] = point;
    return data;
  }
}
