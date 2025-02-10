class HistoryModel {
  String? tranID;
  String? type;
  int? amount;
  String? channel;
  String? created;
  String? remark;

  HistoryModel({this.tranID, this.type, this.amount, this.channel, this.created});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    tranID = json['tranID'];
    type = json['type'];
    amount = json['amount'];
    channel = json['channel'];
    created = json['created'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tranID'] = tranID;
    data['type'] = type;
    data['amount'] = amount;
    data['channel'] = channel;
    data['created'] = created;
    data['remark'] = remark;
    return data;
  }
}
