class KycModel {
  bool? status;
  int? resultCode;
  String? resultDesc;
  Data? data;

  KycModel({this.status, this.resultCode, this.resultDesc, this.data});

  KycModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['resultCode'] = this.resultCode;
    data['resultDesc'] = this.resultDesc;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? firstName;
  String? lastName;
  String? address;
  String? province;
  String? phone;
  String? gender;
  String? birthday;
  String? familyId;
  String? passport;
  String? email;
  String? idcard;
  String? simtype;
  String? photo;
  String? docImg;
  Null? registeredDate;

  Data(
      {this.firstName,
      this.lastName,
      this.address,
      this.province,
      this.phone,
      this.gender,
      this.birthday,
      this.familyId,
      this.passport,
      this.email,
      this.idcard,
      this.simtype,
      this.photo,
      this.docImg,
      this.registeredDate});

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    province = json['province'];
    phone = json['phone'];
    gender = json['gender'];
    birthday = json['birthday'];
    familyId = json['family_id'];
    passport = json['passport'];
    email = json['email'];
    idcard = json['idcard'];
    simtype = json['simtype'];
    photo = json['photo'];
    docImg = json['doc_img'];
    registeredDate = json['registered_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['address'] = this.address;
    data['province'] = this.province;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['birthday'] = this.birthday;
    data['family_id'] = this.familyId;
    data['passport'] = this.passport;
    data['email'] = this.email;
    data['idcard'] = this.idcard;
    data['simtype'] = this.simtype;
    data['photo'] = this.photo;
    data['doc_img'] = this.docImg;
    data['registered_date'] = this.registeredDate;
    return data;
  }
}
