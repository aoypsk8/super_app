import 'dart:convert';

class ESIMPackage {
  final String data;
  final String time;
  final int price;
  final String freeCall;
  final int totalRecords;

  ESIMPackage({
    required this.data,
    required this.time,
    required this.price,
    required this.freeCall,
    required this.totalRecords,
  });

  factory ESIMPackage.fromJson(Map<String, dynamic> json) {
    return ESIMPackage(
      data: json['data'],
      time: json['time'],
      price: json['price'],
      freeCall: json['free_call'],
      totalRecords: json['total_records'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'time': time,
      'price': price,
      'free_call': freeCall,
      'total_records': totalRecords,
    };
  }
}

// Example usage:
List<ESIMPackage> parseESIMList(String responseBody) {
  final parsed = json.decode(responseBody)['data'] as List;
  return parsed.map((json) => ESIMPackage.fromJson(json)).toList();
}
