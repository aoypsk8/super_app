class BalanceModel {
  int? resultCode;
  String? resultDesc;
  Data? data;

  BalanceModel({this.resultCode, this.resultDesc, this.data});

  BalanceModel.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resultCode'] = resultCode;
    data['resultDesc'] = resultDesc;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? resultCode;
  String? resultDesc;
  String? msisdn;
  int? amount;
  int? fiat;
  int? point;
  String? active;
  String? birthday;
  String? firstname;
  String? lastname;
  String? walletIds;
  int? limitBalance;
  int? limitPerday;
  bool? convert;

  Data({
    this.resultCode,
    this.resultDesc,
    this.msisdn,
    this.amount,
    this.fiat,
    this.point,
    this.active,
    this.birthday,
    this.firstname,
    this.lastname,
    this.walletIds,
    this.limitBalance,
    this.limitPerday,
    this.convert,
  });

  Data.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    msisdn = json['msisdn'];
    amount = json['amount'];
    fiat = json['fiat'];
    point = json['point'];
    active = json['active'];
    birthday = json['birthday'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    walletIds = json['wallet_ids'];
    limitBalance = json['limit_balance'];
    limitPerday = json['limit_perday'];
    convert = json['convert'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resultCode'] = resultCode;
    data['resultDesc'] = resultDesc;
    data['msisdn'] = msisdn;
    data['amount'] = amount;
    data['fiat'] = fiat;
    data['point'] = point;
    data['active'] = active;
    data['birthday'] = birthday;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['wallet_ids'] = walletIds;
    data['limit_balance'] = limitBalance;
    data['limit_perday'] = limitPerday;
    data['convert'] = convert;
    return data;
  }
}
