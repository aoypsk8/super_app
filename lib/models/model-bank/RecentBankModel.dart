class RecentBankModel {
  String? accNo;
  String? accName;
  String? id;
  int favorite = 0; // Default value is 0 (not favorite)

  RecentBankModel({this.accNo, this.accName, this.id, this.favorite = 0});

  RecentBankModel.fromJson(Map<String, dynamic> json) {
    accNo = json['AccNo'];
    accName = json['AccName'];
    id = json['id'];
    favorite =
        json['favorite'] ?? 0; // If no favorite field exists, default to 0
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AccNo'] = accNo;
    data['AccName'] = accName;
    data['id'] = id;
    data['favorite'] = favorite; // Add the favorite field to the JSON
    return data;
  }
}
