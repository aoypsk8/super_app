class BankListModel {
  final int id;
  final String bankName;
  final String imageUrl;
  final String url;
  final String urlLinkApp;
  final String urlCheckTransction;
  final String urlCallBack;

  BankListModel({
    required this.id,
    required this.bankName,
    required this.imageUrl,
    required this.url,
    required this.urlLinkApp,
    required this.urlCheckTransction,
    required this.urlCallBack,
  });

  // Factory method to create a Bank object from JSON
  factory BankListModel.fromJson(Map<String, dynamic> json) {
    return BankListModel(
      id: json['id'],
      bankName: json['bank'],
      imageUrl: json['image'],
      url: json['url'],
      urlLinkApp: json['urlLinkApp'],
      urlCheckTransction: json['urlCheckTransction'],
      urlCallBack: json['urlCallBack'],
    );
  }

  // Convert a Bank object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bank': bankName,
      'image': imageUrl,
      'url': url,
      'urlLinkApp': urlLinkApp,
      'urlCheckTransction': urlCheckTransction,
      'urlCallBack': urlCallBack,
    };
  }
}
