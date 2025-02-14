// ignore_for_file: prefer_collection_literals, unnecessary_new

class HistoryDetailModel {
  String? id;
  String? timestamp;
  String? chanel;
  String? transid;
  String? logo;
  String? provider;
  String? fromAcc;
  String? fromAccName;
  String? toAcc;
  String? toAccName;
  String? amount;
  String? point;
  String? fee;
  String? ramark;

  HistoryDetailModel(
      {this.id,
      this.timestamp,
      this.chanel,
      this.transid,
      this.logo,
      this.provider,
      this.fromAcc,
      this.fromAccName,
      this.toAcc,
      this.toAccName,
      this.amount,
      this.point,
      this.fee,
      this.ramark});

  HistoryDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    chanel = json['chanel'];
    transid = json['transid'];
    logo = json['logo'];
    provider = json['provider'];
    fromAcc = json['from_acc'];
    fromAccName = json['from_acc_name'];
    toAcc = json['to_acc'];
    toAccName = json['to_acc_name'];
    amount = json['amount'].toString();
    point = json['point'].toString();
    fee = json['fee'].toString();
    ramark = json['ramark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['timestamp'] = timestamp;
    data['chanel'] = chanel;
    data['transid'] = transid;
    data['logo'] = logo;
    data['provider'] = provider;
    data['from_acc'] = fromAcc;
    data['from_acc_name'] = fromAccName;
    data['to_acc'] = toAcc;
    data['to_acc_name'] = toAccName;
    data['amount'] = amount;
    data['point'] = point;
    data['fee'] = fee;
    data['ramark'] = ramark;
    return data;
  }
}
