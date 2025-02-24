class WeTvList {
  int? weid;
  int? day;
  int? price;
  int? stock;
  String? logo;
  String? description;

  WeTvList(
      {this.weid,
      this.day,
      this.price,
      this.stock,
      this.logo,
      this.description});

  WeTvList.fromJson(Map<String, dynamic> json) {
    weid = json['weid'];
    day = json['Day'];
    price = json['Price'];
    stock = json['Stock'];
    logo = json['Logo'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weid'] = weid;
    data['Day'] = day;
    data['Price'] = price;
    data['Stock'] = stock;
    data['Logo'] = logo;
    data['Description'] = description;
    return data;
  }
}

class WeTvHistory {
  int? id;
  String? tranid;
  String? code;
  int? price;
  int? day;
  String? created;

  WeTvHistory(
      {this.id, this.tranid, this.code, this.price, this.day, this.created});

  WeTvHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tranid = json['tranid'];
    code = json['code'];
    price = json['price'];
    day = json['day'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tranid'] = tranid;
    data['code'] = code;
    data['price'] = price;
    data['day'] = day;
    data['created'] = created;
    return data;
  }
}

class WeTvModel {
  String? image;
  String? price;
  String? duration;
  bool? isSelected;

  WeTvModel({this.image, this.isSelected = false, this.price, this.duration});
}
