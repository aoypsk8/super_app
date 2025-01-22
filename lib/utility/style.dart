import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  // Color
  //***************************************************************** */
  // static Color primary = const Color(0xffef3025);
  // // static Color primary = const Color(0xffDEA500);
  // static Color dark = const Color(0xffb40000);
  // static Color light = const Color(0xffff6a50);

  static Color primary = const Color(0xffED1C29);
  // static Color dark = const Color(0xff92160B);
  static Color dark = const Color(0xffB71C0E);
  static Color light = const Color.fromARGB(255, 244, 82, 67);

  static Color background = const Color(0xffC4C4C4);
  static Color primary1 = const Color(0xffF14D58);

  // Images
  //***************************************************************** */
  static String imgOTP = 'images/otp.png';
  static String imgProfile = 'images/profile.png';
  static String imgAvatarProfile = 'images/avatarProfile.png';
  static String imgBg = 'images/bg.jpg';
  static String imgLogoElec = 'images/logo_electric.svg';
  static String imgLogo = 'images/logo_mmoney.svg';
  static String imgLogoPng = 'images/logo_mmoney.png';
  static String imgLogoCircle = 'images/logo_mmoney_circle.png';
  static String imgLogoMerchant = 'images/logo_merchant.svg';
  static String imglogoMerchantCircle = 'images/logo_merchant_circle.png';
  static String imgLoadingLogo = 'images/loading.gif';
  static String banner00 = 'images/banner00.jpg';
  static String banner01 = 'images/banner01.jpg';
  static String banner02 = 'images/banner02.jpg';
  static String banner03 = 'images/banner03.jpg';

  // SVG Images
  //***************************************************************** */
  static String svgLogoMmoney = 'images/logo_mmoney1.svg';
  static String svgLogoEaon = 'images/eaon.svg';
  static String svgOTP = 'images/otp.svg';
  static String svgTV = 'images/tv.svg';

  // Text Sylte
  //***************************************************************** */
  static Color textColor = Colors.white;
  // static Color textColorBlack = const Color.fromARGB(255, 32, 32, 32);
  static Color textColorBlack = const Color(0xff2D3436);

  static TextStyle textLaoStyle = GoogleFonts.notoSansLao(fontSize: 14, fontWeight: FontWeight.w500, color: textColor);
  static TextStyle textStyle = GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500, color: textColor);

  static TextStyle headLineLaoStyle1 = GoogleFonts.notoSansLao(fontSize: 26, fontWeight: FontWeight.bold, color: textColor);
  static TextStyle headLineStyle1 = GoogleFonts.lato(fontSize: 26, fontWeight: FontWeight.bold, color: textColor);
  static TextStyle headLineLaoStyle1Red = GoogleFonts.notoSansLao(fontSize: 26, fontWeight: FontWeight.bold, color: dark);
  static TextStyle headLineStyle1Red = GoogleFonts.lato(fontSize: 26, fontWeight: FontWeight.bold, color: dark);
  static TextStyle headLineLaoStyle2 = GoogleFonts.notoSansLao(fontSize: 21, fontWeight: FontWeight.bold, color: textColor);
  static TextStyle headLineStyle2 = GoogleFonts.lato(fontSize: 21, fontWeight: FontWeight.bold, color: textColor);
  static TextStyle headLineLaoStyle2Red = GoogleFonts.notoSansLao(fontSize: 21, fontWeight: FontWeight.bold, color: dark);
  static TextStyle headLineStyle2Red = GoogleFonts.lato(fontSize: 21, fontWeight: FontWeight.bold, color: dark);
  static TextStyle headLineLaoStyle3 = GoogleFonts.notoSansLao(fontSize: 18, fontWeight: FontWeight.w700, color: textColor);
  static TextStyle headLineStyle3 = GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w700, color: textColor);
  static TextStyle headLineLaoStyle4 = GoogleFonts.notoSansLao(fontSize: 18, fontWeight: FontWeight.w500, color: textColor);
  static TextStyle headLineStyle4 = GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w500, color: textColor);
  static TextStyle textLaoStyleBlack = GoogleFonts.notoSansLao(fontSize: 14, fontWeight: FontWeight.w500, color: textColorBlack);
  static TextStyle textStyleBlack = GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500, color: textColorBlack);
  static TextStyle textStyleBlackBold = GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold, color: textColorBlack);
  static TextStyle headLineLaoStyle1Black =
      GoogleFonts.notoSansLao(fontSize: 26, fontWeight: FontWeight.bold, color: textColorBlack);
  static TextStyle headLineStyle1Black = GoogleFonts.lato(fontSize: 26, fontWeight: FontWeight.bold, color: textColorBlack);
  static TextStyle headLineLaoStyle2Black =
      GoogleFonts.notoSansLao(fontSize: 21, fontWeight: FontWeight.bold, color: textColorBlack);
  static TextStyle headLineStyle2Black = GoogleFonts.lato(fontSize: 21, fontWeight: FontWeight.bold, color: textColorBlack);
  static TextStyle headLineLaoStyle3Black =
      GoogleFonts.notoSansLao(fontSize: 18, fontWeight: FontWeight.w700, color: textColorBlack);
  static TextStyle headLineStyle3Black = GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w700, color: textColorBlack);
  static TextStyle headLineLaoStyle4Black =
      GoogleFonts.notoSansLao(fontSize: 18, fontWeight: FontWeight.w500, color: textColorBlack);
  static TextStyle headLineStyle4Black = GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w500, color: textColorBlack);
  static TextStyle headLineStyle5 =
      GoogleFonts.notoSansLao(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500);

  //
  // TextForm
  //***************************************************************** */
  static OutlineInputBorder outlineInputBorder() =>
      OutlineInputBorder(borderSide: BorderSide(color: Style.textColorBlack), borderRadius: BorderRadius.circular(20));
  OutlineInputBorder focusOutlineInputBorder() =>
      OutlineInputBorder(borderSide: BorderSide(color: Style.dark), borderRadius: BorderRadius.circular(20));
  OutlineInputBorder errOutlineInputBorder() =>
      OutlineInputBorder(borderSide: BorderSide(color: Style.light), borderRadius: BorderRadius.circular(20));
}
