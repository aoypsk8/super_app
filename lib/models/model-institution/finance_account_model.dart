class FinanceAccountModel {
  int? code;
  String? msg;
  String? accno;
  String? name;
  String? custid;
  double? balance;

  FinanceAccountModel(
      {this.code, this.msg, this.accno, this.name, this.custid, this.balance});

  FinanceAccountModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    accno = json['accno'];
    name = json['name'];
    custid = json['custid'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['accno'] = this.accno;
    data['name'] = this.name;
    data['custid'] = this.custid;
    data['balance'] = this.balance;
    return data;
  }
}
