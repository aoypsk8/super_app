import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FakeCashoutData {
  // Function to generate and store fake cashout data
  static Future<void> generateAndStoreFakeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Fake history data
    final List<Map<String, dynamic>> historyData = [
      {
        "accNo": "00120010010092446",
        "accName": "AOY PHONGSAKOUN",
        "timeStamp":
            DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        "favorite": 1,
        "amount": "1,000,000",
        "bankLogo": "https://example.com/bank1-logo.png"
      },
      {
        "accNo": "00120010010087654",
        "accName": "SOUKSAVANH VONGPHACHANH",
        "timeStamp":
            DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
        "favorite": 0,
        "amount": "500,000",
        "bankLogo": "https://example.com/bank1-logo.png"
      },
      {
        "accNo": "00120010010065432",
        "accName": "BOUNMY SISOULITH",
        "timeStamp":
            DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
        "favorite": 1,
        "amount": "2,000,000",
        "bankLogo": "https://example.com/bank1-logo.png"
      },
      {
        "accNo": "00120010010043210",
        "accName": "THONGLOUN SISOULITH",
        "timeStamp":
            DateTime.now().subtract(Duration(days: 4)).toIso8601String(),
        "favorite": 0,
        "amount": "300,000",
        "bankLogo": "https://example.com/bank1-logo.png"
      },
      {
        "accNo": "00120010010012345",
        "accName": "PHONEPADITH XANGSAYARATH",
        "timeStamp":
            DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        "favorite": 1,
        "amount": "1,500,000",
        "bankLogo": "https://example.com/bank1-logo.png"
      }
    ];

    // Fake favorite data (subset of history with favorite = 1)
    final List<Map<String, dynamic>> favoriteData = historyData
        .where((item) => item['favorite'] == 1)
        .map((item) => {
              'accNo': item['accNo'],
              'accName': item['accName'],
              'timeStamp': item['timeStamp'],
              'amount': item['amount'],
              'bankLogo': item['bankLogo']
            })
        .toList();

    // Store the fake data
    await prefs.setString('historyCashout', json.encode(historyData));
    await prefs.setString('favoriteCashout', json.encode(favoriteData));

    print('Fake data stored successfully');
    print('History data: ${json.encode(historyData)}');
    print('Favorite data: ${json.encode(favoriteData)}');
  }

  // Function to clear fake data
  static Future<void> clearFakeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('historyCashout');
    await prefs.remove('favoriteCashout');
    print('Fake data cleared successfully');
  }

  // Function to read and display stored data
  static Future<void> displayStoredData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? historyData = prefs.getString('historyCashout');
    final String? favoriteData = prefs.getString('favoriteCashout');

    print('Stored History Data: $historyData');
    print('Stored Favorite Data: $favoriteData');
  }
}
