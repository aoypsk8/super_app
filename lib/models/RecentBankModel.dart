class RecentBankModel {
  String? accNo;
  String? accName;
  String? id;

  RecentBankModel({this.accNo, this.accName, this.id});

  RecentBankModel.fromJson(Map<String, dynamic> json) {
    accNo = json['AccNo'];
    accName = json['AccName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AccNo'] = accNo;
    data['AccName'] = accName;
    data['id'] = id;
    return data;
  }
}
