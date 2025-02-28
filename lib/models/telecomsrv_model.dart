class NetworktypeModel {
  String? resultCode;
  String? resultDesc;
  String? networkCode;
  String? networkName;

  NetworktypeModel(
      {this.resultCode, this.resultDesc, this.networkCode, this.networkName});

  NetworktypeModel.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    networkCode = json['networkCode'];
    networkName = json['networkName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultCode'] = this.resultCode;
    data['resultDesc'] = this.resultDesc;
    data['networkCode'] = this.networkCode;
    data['networkName'] = this.networkName;
    return data;
  }
}

class AirtimeModel {
  String? msisdn;
  List<Balances>? balances;
  String? networkType;
  String? resultCode;
  String? resultDesc;
  String? transferFee;

  AirtimeModel(
      {this.msisdn,
      this.balances,
      this.networkType,
      this.resultCode,
      this.resultDesc,
      this.transferFee});

  AirtimeModel.fromJson(Map<String, dynamic> json) {
    msisdn = json['msisdn'];
    if (json['balances'] != null) {
      balances = <Balances>[];
      json['balances'].forEach((v) {
        balances!.add(new Balances.fromJson(v));
      });
    }
    networkType = json['networkType'];
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    transferFee = json['transferFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msisdn'] = this.msisdn;
    if (this.balances != null) {
      data['balances'] = this.balances!.map((v) => v.toJson()).toList();
    }
    data['networkType'] = this.networkType;
    data['resultCode'] = this.resultCode;
    data['resultDesc'] = this.resultDesc;
    data['transferFee'] = this.transferFee;
    return data;
  }
}

class Balances {
  String? balance;
  String? balanceType;
  String? balanceName;

  Balances({this.balance, this.balanceType, this.balanceName});

  Balances.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    balanceType = json['balanceType'];
    balanceName = json['balanceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['balanceType'] = this.balanceType;
    data['balanceName'] = this.balanceName;
    return data;
  }
}

class PackageModel {
  String? packageName;
  String? qtaValue;
  String? qtaUsed;
  String? qtaRemaining;
  dynamic? doublePercent;
  String? stringPercent;
  String? dateStamp;
  String? tempDate;
  String? remainingDay;
  String? remainingDayPercent;
  String? internetData;
  int? priority;
  int? speed;
  bool? isCurrentNormal;

  PackageModel(
      {this.packageName,
      this.qtaValue,
      this.qtaUsed,
      this.qtaRemaining,
      this.doublePercent,
      this.stringPercent,
      this.dateStamp,
      this.tempDate,
      this.remainingDay,
      this.remainingDayPercent,
      this.internetData,
      this.priority,
      this.speed,
      this.isCurrentNormal});

  PackageModel.fromJson(Map<String, dynamic> json) {
    packageName = json['packageName'];
    qtaValue = json['qtaValue'];
    qtaUsed = json['qtaUsed'];
    qtaRemaining = json['qtaRemaining'];
    doublePercent = json['doublePercent'];
    stringPercent = json['stringPercent'];
    dateStamp = json['dateStamp'];
    tempDate = json['tempDate'];
    remainingDay = json['remainingDay'];
    remainingDayPercent = json['remainingDayPercent'];
    internetData = json['internetData'];
    priority = json['priority'];
    speed = json['speed'];
    isCurrentNormal = json['isCurrentNormal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packageName'] = this.packageName;
    data['qtaValue'] = this.qtaValue;
    data['qtaUsed'] = this.qtaUsed;
    data['qtaRemaining'] = this.qtaRemaining;
    data['doublePercent'] = this.doublePercent;
    data['stringPercent'] = this.stringPercent;
    data['dateStamp'] = this.dateStamp;
    data['tempDate'] = this.tempDate;
    data['remainingDay'] = this.remainingDay;
    data['remainingDayPercent'] = this.remainingDayPercent;
    data['internetData'] = this.internetData;
    data['priority'] = this.priority;
    data['speed'] = this.speed;
    data['isCurrentNormal'] = this.isCurrentNormal;
    return data;
  }
}

class PhoneListModel {
  String? phoneNumber;
  String? userId;
  String? phoneStatus;
  String? activeDate;
  String? networkType;

  PhoneListModel(
      {this.phoneNumber,
      this.userId,
      this.phoneStatus,
      this.activeDate,
      this.networkType});

  PhoneListModel.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    userId = json['userId'];
    phoneStatus = json['phoneStatus'];
    activeDate = json['activeDate'];
    networkType = json['networkType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['userId'] = this.userId;
    data['phoneStatus'] = this.phoneStatus;
    data['activeDate'] = this.activeDate;
    data['networkType'] = this.networkType;
    return data;
  }
}
