class TicketHistoryModel {
  int? id;
  String? tranid;
  String? code;
  int? price;
  int? day;
  String? created;
  String? logo;
  String? title;
  String? location;

  TicketHistoryModel({
    this.id,
    this.tranid,
    this.code,
    this.price,
    this.day,
    this.created,
    this.logo,
    this.title,
    this.location,
  });

  TicketHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tranid = json['tranid'];
    code = json['code'];
    price = json['price'];
    day = json['day'];
    created = json['created'];
    logo = json['Logo'];
    title = json['Title'];
    location = json['Location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tranid'] = tranid;
    data['code'] = code;
    data['price'] = price;
    data['day'] = day;
    data['created'] = created;
    data['Logo'] = logo;
    data['Title'] = title;
    data['Location'] = location;
    return data;
  }
}
