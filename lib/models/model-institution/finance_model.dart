class FinanceModel {
  String? id;
  String? title;
  String? description;
  String? logo;
  bool? status;
  String? fee;

  FinanceModel(
      {this.id,
      this.title,
      this.description,
      this.logo,
      this.status,
      this.fee});

  FinanceModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    description = json['Description'];
    logo = json['Logo'];
    status = json['Status'];
    fee = json['Fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Title'] = this.title;
    data['Description'] = this.description;
    data['Logo'] = this.logo;
    data['Status'] = this.status;
    data['Fee'] = this.fee;
    return data;
  }
}
