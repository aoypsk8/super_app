class TicketListsModel {
  int? tickid;
  int? day;
  int? price;
  int? stock;
  String? logo;
  String? title;
  String? description;
  String? location;
  String? dateEvent;
  String? groups;
  int? orderNo;

  TicketListsModel(
      {this.tickid,
      this.day,
      this.price,
      this.stock,
      this.logo,
      this.title,
      this.description,
      this.location,
      this.dateEvent,
      this.groups,
      this.orderNo});

  TicketListsModel.fromJson(Map<String, dynamic> json) {
    tickid = json['tickid'];
    day = json['Day'];
    price = json['Price'];
    stock = json['Stock'];
    logo = json['Logo'];
    title = json['Title'];
    description = json['Description'];
    location = json['Location'];
    dateEvent = json['DateEvent'];
    groups = json['Groups'];
    orderNo = json['OrderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tickid'] = tickid;
    data['Day'] = day;
    data['Price'] = price;
    data['Stock'] = stock;
    data['Logo'] = logo;
    data['Title'] = title;
    data['Description'] = description;
    data['Location'] = location;
    data['DateEvent'] = dateEvent;
    data['Groups'] = groups;
    data['OrderNo'] = orderNo;
    return data;
  }
}
