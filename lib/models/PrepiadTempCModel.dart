class PrepaidTempCModel {
  String? resultCode;
  String? resultDesc;
  List<Topup>? topup;

  PrepaidTempCModel({this.resultCode, this.resultDesc, this.topup});

  PrepaidTempCModel.fromJson(Map<String, dynamic> json) {
    resultCode = json['ResultCode'];
    resultDesc = json['ResultDesc'];
    if (json['Topup'] != null) {
      topup = <Topup>[];
      json['Topup'].forEach((v) {
        topup!.add(Topup.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResultCode'] = resultCode;
    data['ResultDesc'] = resultDesc;
    if (topup != null) {
      data['Topup'] = topup!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Topup {
  String? title;
  int? amount;
  String? description;
  String? color;

  Topup({this.title, this.amount, this.description, this.color});

  Topup.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    amount = json['Amount'];
    description = json['Description'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Title'] = title;
    data['Amount'] = amount;
    data['Description'] = description;
    data['Description'] = color;
    return data;
  }
}
