class AppInfoModel {
  int? id;
  String? iosversion;
  String? androidversion;
  String? iosurl;
  String? androidurl;
  String? created;
  bool? forceupdate;
  String? bgimage;
  String? bgbill;

  AppInfoModel({this.id, this.iosversion, this.androidversion, this.iosurl, this.androidurl, this.created, this.forceupdate, this.bgimage});

  AppInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iosversion = json['iosversion'];
    androidversion = json['androidversion'];
    iosurl = json['iosurl'];
    androidurl = json['androidurl'];
    created = json['created'];
    forceupdate = json['forceupdate'];
    bgimage = json['bgimage'];
    bgbill = json['bgbill'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iosversion'] = this.iosversion;
    data['androidversion'] = this.androidversion;
    data['iosurl'] = this.iosurl;
    data['androidurl'] = this.androidurl;
    data['created'] = this.created;
    data['forceupdate'] = this.forceupdate;
    data['bgimage'] = this.bgimage;
    data['bgbill'] = this.bgbill;
    return data;
  }
}
