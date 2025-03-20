class HomeModel {
  int? id;
  String? title;
  String? group;
  String? status;
  String? created;
  ImageBand? imageBand;

  HomeModel(
      {this.id,
      this.title,
      this.group,
      this.status,
      this.created,
      this.imageBand});

  HomeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['Title'];
    group = json['Group'];
    status = json['Status'];
    created = json['Created'];
    imageBand = json['ImageBand'] != null
        ? ImageBand.fromJson(json['ImageBand'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Title'] = title;
    data['Group'] = group;
    data['Status'] = status;
    data['Created'] = created;
    if (imageBand != null) {
      data['ImageBand'] = imageBand!.toJson();
    }
    return data;
  }
}

class ImageBand {
  String? url;

  ImageBand({this.url});

  ImageBand.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}

class AdsList {
  String? index;
  String? title;
  List<Detail>? detail;

  AdsList({this.index, this.title, this.detail});

  AdsList.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    title = json['title'];
    if (json['detail'] != null) {
      detail = <Detail>[];
      json['detail'].forEach((v) {
        detail!.add(Detail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['title'] = title;
    if (detail != null) {
      data['detail'] = detail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Detail {
  int? id;
  String? title;
  String? type;
  String? imgUrl;
  String? groups;
  String? groupKey;

  Detail(
      {this.id,
      this.title,
      this.type,
      this.imgUrl,
      this.groups,
      this.groupKey});

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    imgUrl = json['imgUrl'];
    groups = json['groups'];
    groupKey = json['groupKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['imgUrl'] = imgUrl;
    data['groups'] = groups;
    data['groupKey'] = groupKey;
    return data;
  }
}
