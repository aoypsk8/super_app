import 'dart:convert';

class ESIMPackage {
  final int id;
  final String title;
  final String phoneNumber;
  final String data;
  final String time;
  final int price;
  final int status;
  final DateTime createdAt;
  final DateTime expiryDate;

  ESIMPackage({
    required this.id,
    required this.title,
    required this.phoneNumber,
    required this.data,
    required this.time,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.expiryDate,
  });

  factory ESIMPackage.fromJson(Map<String, dynamic> json) {
    return ESIMPackage(
      id: json['id'],
      title: json['title'],
      phoneNumber: json['phone_number'],
      data: json['data'],
      time: json['time'],
      price: json['price'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      expiryDate: DateTime.parse(json['expiry_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'phone_number': phoneNumber,
      'data': data,
      'time': time,
      'price': price,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'expiry_date': expiryDate.toIso8601String(),
    };
  }
}

// Example usage:
List<ESIMPackage> parseESIMList(String responseBody) {
  final parsed = json.decode(responseBody)['data'] as List;
  return parsed.map((json) => ESIMPackage.fromJson(json)).toList();
}
