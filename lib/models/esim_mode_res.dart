import 'dart:convert';

class ESIMPackageRes {
  final int id;
  final String phoneNumber;
  final String data;
  final String time;
  final int price;
  final String freeCall;
  final String qr;

  ESIMPackageRes({
    required this.id,
    required this.phoneNumber,
    required this.data,
    required this.time,
    required this.price,
    required this.freeCall,
    required this.qr,
  });

  factory ESIMPackageRes.fromJson(Map<String, dynamic> json) {
    return ESIMPackageRes(
      id: json['id'],
      phoneNumber: json['phone_number'],
      data: json['data'],
      time: json['time'],
      price: json['price'],
      freeCall: json['free_call'],
      qr: json['qr'] ?? "", // Default to empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'data': data,
      'time': time,
      'price': price,
      'free_call': freeCall,
      'qr': qr,
    };
  }
}

// Example usage:
List<ESIMPackageRes> parseESIMList(String responseBody) {
  final parsed = json.decode(responseBody)['data'] as List;
  return parsed.map((json) => ESIMPackageRes.fromJson(json)).toList();
}
