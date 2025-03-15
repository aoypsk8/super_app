class PaymentMethod {
  final int id;
  final String paymentType;
  final bool status;
  final int order;
  final String logo;
  final String title;
  final String description;
  final String owner;
  final String accname;
  final bool maincard;
  final String uuid;

  PaymentMethod({
    required this.id,
    required this.paymentType,
    required this.status,
    required this.order,
    required this.logo,
    required this.title,
    required this.description,
    required this.owner,
    required this.accname,
    required this.maincard,
    required this.uuid,
  });

  // Factory method to create a PaymentMethod object from JSON
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      paymentType: json['payment_type'],
      status: json['status'],
      order: json['order'],
      logo: json['logo'],
      title: json['title'],
      description: json['description'],
      owner: json['owner'],
      accname: json['accname'] ?? "",
      maincard: json['maincard'],
      uuid: json['uuid'] ?? "",
    );
  }

  // Method to convert PaymentMethod object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_type': paymentType,
      'status': status,
      'order': order,
      'logo': logo,
      'title': title,
      'description': description,
      'owner': owner,
      'accname': accname,
      'maincard': maincard,
      'uuid': uuid,
    };
  }
}
