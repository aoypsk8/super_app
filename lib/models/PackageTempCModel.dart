class PackageTempCModel {
  String? resultCode;
  String? resultDesc;
  List<Packages>? packages;

  PackageTempCModel({this.resultCode, this.resultDesc, this.packages});

  PackageTempCModel.fromJson(Map<String, dynamic> json) {
    resultCode = json['ResultCode'];
    resultDesc = json['ResultDesc'];
    if (json['Packages'] != null) {
      packages = <Packages>[];
      json['Packages'].forEach((v) {
        packages!.add(Packages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResultCode'] = resultCode;
    data['ResultDesc'] = resultDesc;
    if (packages != null) {
      data['Packages'] = packages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Packages {
  String? operator;
  String? typeName;
  String? listName;
  int? amount;
  int? userDay;
  String? pKCode;
  String? sPNV;
  String? description;
  String? crateDate;
  String? packageName;
  String? packageValue;
  bool? popular;
  int? discount;

  Packages({this.operator, this.typeName, this.listName, this.amount, this.userDay, this.pKCode, this.sPNV, this.description, this.packageValue, this.crateDate, this.popular});

  Packages.fromJson(Map<String, dynamic> json) {
    operator = json['Operator'];
    typeName = json['TypeName'];
    listName = json['ListName'];
    amount = json['Amount'];
    userDay = json['UserDay'];
    pKCode = json['PK_code'];
    sPNV = json['SPNV'];
    description = json['Description'];
    crateDate = json['CrateDate'];
    packageName = listName.toString().split("/")[0].toString().split('=')[0].toString();
    packageValue = listName.toString().split("/")[0].toString().split('=')[1].toString();
    popular = json['Popular'];
    discount = json['Discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Operator'] = operator;
    data['TypeName'] = typeName;
    data['ListName'] = listName;
    data['Amount'] = amount;
    data['UserDay'] = userDay;
    data['PK_code'] = pKCode;
    data['SPNV'] = sPNV;
    data['Description'] = description;
    data['CrateDate'] = crateDate;
    data['Popular'] = popular;
    data['Discount'] = discount;
    return data;
  }
}
