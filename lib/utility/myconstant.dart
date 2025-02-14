import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

final fn = NumberFormat('#,###', 'en_US');

class MyConstant {
  static NumberFormat fn = NumberFormat('#,###', 'en_US');
  static String urlSocketLtcdev = 'https://socket.ltcdev.la';

  // static String urlAddress = 'https://rank.mmoney.la';
  static String urlUser = '/Users';
  static String urlLtcdev = 'https://gateway.ltcdev.la';

  static String urlIcons = '/AppImage';

  // static String urlAddress = 'https://gateway.mmoney.la';
  // static String urlAddress = 'https://rank.mmoney.la';
  static String urlAddress = '/Menus';

// https://gateway.ltcdev.la/LoginLog/InsertLog
  static String urlInsertLog = '/LoginLog';

  static String urlLoginByEmail = '/LoginByEmail';

  // https://gateway.mmoney.la/noti/initDevice/
  // static String urlNoti = '/Noti';

  static String urlOther = '/Other';

  // static String urlAddressNotify = 'https://gateway.mmoney.la/front/'; /////////
  static String urlAddressNotify = '/Message';

  // static String urlGateway = 'https://gateway.mmoney.la';
  static String urlGateway = '/Login';

  // static String urlTransferX = 'https://transferx.mmoney.la';
  // static String urlTransferX = '/Transfer';
  // static String keyTransferX = "QG1vbmV5Z3JhbTojbTBuZXlncmFNQDIwMjQhcw==";

  //static String urlQR = 'https://qr.mmoney.la';  // seperate to 3 paths
  static String urlQR = '/QR';
// laos qr
  // static String urlLaoQR = '/GenerateLQR';

// generate DynamicQR

// gateway.ltcdev.la/GenerateLQR
  static String urlDynamicQR = '/GenerateLQR';

  static String urlHistory = '/History';
  static String urlConsumerInfo = '/ConsumerInfo';

  static String urlUserbalance = '/UserBalance';

  // static String urlProfile = 'https://profile.mmoney.la';
  static String urlProfile = '/Profile'; ///////////////////////////////////////
  static String urlProfileUpload = '/Image'; ///////////////////////////////////

  //static String urlPoint = 'https://point.mmoney.la';
  static String urlPoint = '/Point';

  static String urlRefcode = 'https://merchant.mmoney.la/uat'; /////////////////
  // static String urlActivity = 'https://activity.mmoney.la';
  static String urlActivity = '/Activity'; //

  // static String urlCashOut = 'http://172.28.26.8:2222';
  // static String urlCashOut = 'https://cashx.mmoney.la';
  static String urlCashOut = '/Cash';

  //! new url encode & decode
  // static String urlAppX = 'https://app.mmoney.la/static'; //remove
  // static String urlAppXdynamic = 'https://app.mmoney.la/dynamic'; //remove

  // static String urlBackup = 'https://backup.mmoney.la'; //remove
  // static String keyBackup = '9fc44ba9e3a91689bbc24755b7a842113017aa68';

  // static String urlVisa = 'https://visa.mmoney.la'; //! PROD - Credit card
  static String urlVisa = '/Visa'; //! PROD - Credit card
  // static String keyVisa =
  //     '1fc44ba9e3a91689bbc24755b7a842113017aa57'; //! PROD - Credit card

  // static String desRoute = 'UAT';
  static String desRoute = 'PRO';

  static int connectTimeout = 30000;
  static Duration get delayTime =>
      Duration(milliseconds: timeDilation.ceil() * 500);

  static String userKYC = 'Users';

  static String profile_default =
      'https://gateway.ltcdev.la/AppImage/AppLite/Users/mmoney.png';
  // static String mlitekey =
  //     'gUkXa2r5u8x/A?D(G+KbPeShVmYq3t6v9y\$B&E)H@McQfTjWnZr4u7x!z%C*F-JaNdRgUkXp2s5v8y/B?D(G+KbPeShVmYq3t6w9z\$C&F)H@McQfTjWnZr4u7x!A%D*G';
  // static String lmmkeyApp =
  //     'eyJhbGciOiJIUzI1NiJ9.eyJSb2xlIjoiQWRtaW4iLCJJc3N1ZXIiOiJNLU1vbmV5IiwiVXNlcm5hbWUiOiJNLU1vbmV5IFgiLCJleHAiOjE2OTIyMzk3ODAsImlhdCI6MTY5MjIzOTc4MH0.VUqTof1EQ8LSYjfSn6svaY7Pmn2NDLqlq5DMqjLnsro';
  // static String lmmkeyPro =
  //     "va157f35a50374ba3a07a5cfa1e7fd5d90e612fb50e3bca31661bf568dcaa5c17";
  // static String lmmkeyPoint =
  //     "eyJhbFciOiJIUzI1NiJ10.eyJSb2xlIjoiUGFydG5lciIsIklzc3VlciI6Iklzc3VlciIsIlVzZYJuYW1lIjoiS2JhbmsiLCJleHAiOjE2NzU2Njc3NjksImlhdCI6MTY3NTY2Nzc2OX0.7z-xJ7SIeKMqDiUTYiQvXLpFG8Rx-DCjT0zSR4XAs2U";

  // static String urlAddress = 'https://gateway.mmoney.la';
  static String urlBorrow = '/Borrowing';
}
