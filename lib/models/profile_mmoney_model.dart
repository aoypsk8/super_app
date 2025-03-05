class ProfileMmoneyModel {
  bool? status;
  int? resultCode;
  String? resultDesc;
  Data? data;

  ProfileMmoneyModel({this.status, this.resultCode, this.resultDesc, this.data});

  ProfileMmoneyModel.fromJson(Map<String, dynamic> json) {
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
  String? walletNumber;
  Info? info;
  Doc? doc;

  Data({this.walletNumber, this.info, this.doc});

  Data.fromJson(Map<String, dynamic> json) {
    walletNumber = json['wallet_number'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    doc = json['doc'] != null ? new Doc.fromJson(json['doc']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wallet_number'] = this.walletNumber;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    if (this.doc != null) {
      data['doc'] = this.doc!.toJson();
    }
    return data;
  }
}

class Info {
  String? name;
  String? type;
  String? gender;
  String? status;
  String? verify;
  String? cardId;
  String? surname;
  String? updated;
  String? village;
  String? district;
  String? birthdate;
  String? provinceCode;
  String? provinceDesc;

  Info(
      {this.name,
      this.type,
      this.gender,
      this.status,
      this.verify,
      this.cardId,
      this.surname,
      this.updated,
      this.village,
      this.district,
      this.birthdate,
      this.provinceCode,
      this.provinceDesc});

  Info.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    gender = json['gender'];
    status = json['status'];
    verify = json['verify'];
    cardId = json['card_id'];
    surname = json['surname'];
    updated = json['updated'];
    village = json['village'];
    district = json['district'];
    birthdate = json['birthdate'];
    provinceCode = json['provinceCode'];
    provinceDesc = json['provinceDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['gender'] = this.gender;
    data['status'] = this.status;
    data['verify'] = this.verify;
    data['card_id'] = this.cardId;
    data['surname'] = this.surname;
    data['updated'] = this.updated;
    data['village'] = this.village;
    data['district'] = this.district;
    data['birthdate'] = this.birthdate;
    data['provinceCode'] = this.provinceCode;
    data['provinceDesc'] = this.provinceDesc;
    return data;
  }
}

class Doc {
  String? docImg;
  String? verifyImg;
  String? profileImg;

  Doc({this.docImg, this.verifyImg, this.profileImg});

  Doc.fromJson(Map<String, dynamic> json) {
    docImg = json['doc_img'];
    verifyImg = json['verify_img'];
    profileImg = json['profile_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doc_img'] = this.docImg;
    data['verify_img'] = this.verifyImg;
    data['profile_img'] = this.profileImg;
    return data;
  }
}
