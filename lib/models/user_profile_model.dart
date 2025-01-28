class UserProfileModel {
  String? resultCode;
  String? resultDesc;
  String? msisdn;
  int? id;
  String? created;
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
  String? docImg;
  String? verifyImg;
  String? profileImg;
  String? ref;

  UserProfileModel(
      {this.resultCode,
      this.resultDesc,
      this.msisdn,
      this.id,
      this.created,
      this.name,
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
      this.provinceDesc,
      this.docImg,
      this.verifyImg,
      this.profileImg,
      this.ref});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    resultDesc = json['resultDesc'];
    msisdn = json['msisdn'];
    id = json['id'];
    created = json['created'];
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
    docImg = json['doc_img'];
    verifyImg = json['verify_img'];
    profileImg = json['profile_img'];
    ref = json['ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resultCode'] = this.resultCode;
    data['resultDesc'] = this.resultDesc;
    data['msisdn'] = this.msisdn;
    data['id'] = this.id;
    data['created'] = this.created;
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
    data['doc_img'] = this.docImg;
    data['verify_img'] = this.verifyImg;
    data['profile_img'] = this.profileImg;
    data['ref'] = this.ref;
    return data;
  }
}
