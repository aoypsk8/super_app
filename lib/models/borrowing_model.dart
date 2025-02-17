class BorrowingModel {
  final String path;
  final List<PackageData> data;
  BorrowingModel({required this.path, required this.data});

  factory BorrowingModel.fromJson(Map<String, dynamic> json) {
    return BorrowingModel(
      path: json['path'],
      data: (json['data'] as List)
          .map((item) => PackageData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class PackageData {
  final String packagename;
  final String amount;
  final String code;
  final String detail;
  final String type;

  PackageData({
    required this.packagename,
    required this.amount,
    required this.code,
    required this.detail,
    required this.type,
  });

  factory PackageData.fromJson(Map<String, dynamic> json) {
    return PackageData(
      packagename: json['Packagename'],
      amount: json['amount'],
      code: json['code'],
      detail: json['detail'] ?? '',
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Packagename': packagename,
      'amount': amount,
      'code': code,
      'detail': detail,
      'type': type,
    };
  }
}
