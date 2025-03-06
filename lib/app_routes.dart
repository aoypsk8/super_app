import 'package:get/get.dart';
import 'package:super_app/controllers/temp_b_controller.dart';
import 'package:super_app/home_screen.dart';
import 'package:super_app/views/cashIn/CashIn.dart';
import 'package:super_app/views/cashIn/ConfirmCashIn.dart';
import 'package:super_app/views/cashout/ConfirmCashOutScreen.dart';
import 'package:super_app/views/cashout/ListsProviderBankScreen.dart';
import 'package:super_app/views/finance_institution/ConfirmFinanceScreen.dart';
import 'package:super_app/views/finance_institution/ListsProviderFinance.dart';
import 'package:super_app/views/finance_institution/PaymentFinanceScreen.dart';
import 'package:super_app/views/finance_institution/ResultFinanceScree.dart';
import 'package:super_app/views/finance_institution/VerifyAccountFinanceScreen.dart';
import 'package:super_app/views/templateA/lists_province_tempA.dart';
import 'package:super_app/views/templateA/verify_account_tempA.dart';
import 'package:super_app/views/templateB/ListsProviderTempBScreen.dart';
import 'package:super_app/views/borrowing/lists_borrowing.dart';
import 'package:super_app/views/templateC/ListsProviderTempCScreen.dart';
import 'package:super_app/views/ticket/ListsTicketScreen.dart';
import 'package:super_app/views/transferwallet/OtpTransferEmailScreen.dart';
import 'package:super_app/views/transferwallet/OtpTransferScreen.dart';
import 'package:super_app/views/transferwallet/TransferScreen.dart';
import 'package:super_app/views/visa-mastercard/ListVisaMasterCard.dart';
import 'package:super_app/views/weTV/wetv_package_list.dart';
import 'package:super_app/views/x-jaidee/xjaidee.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => HomeScreen(),
    ),
    GetPage(
      name: '/transfer',
      page: () => TransferScreen(),
    ),
    // GetPage(
    //   name: '/confirmTransfer',
    //   page: () => ConfirmTranferScreen(),
    // ),
    GetPage(
      name: '/otpTransferEmail',
      page: () => OtpTransferEmailScreen(),
    ),
    GetPage(
      name: '/otpTransfer',
      page: () => OtpTransferScreen(),
    ),

    // Cash out here
    GetPage(
      name: '/bank',
      page: () => ListsProviderBankScreen(),
    ),
    // Institution
    GetPage(
      name: '/finance',
      page: () => ListsProviderFinance(),
    ),

    GetPage(
      name: '/vertifyAccountFinace',
      page: () => VerifyAccountFinanceScreen(),
    ),
    GetPage(
      name: '/paymentFinace',
      page: () => PaymentFinanceScreen(),
    ),

    GetPage(
      name: '/confirmFinance',
      page: () => ConfirmFinanceScreen(),
    ),
    GetPage(
      name: '/resultFinance',
      page: () => ResultFinanceScreen(),
    ),

    // cash IN
    GetPage(
      name: '/refill',
      page: () => CashInScreen(),
    ),
    GetPage(
      name: '/confirmCashIN',
      page: () => ConfirmCashInScreen(),
    ),

    // XJaidee
    GetPage(
      name: '/xjaidee',
      page: () => XJaidee(),
    ),

    GetPage(
      name: '/A',
      page: () => ListsProvinceTempA(),
      // transition: Transition.downToUp,
    ),
    GetPage(
      name: '/verifyAccTempA',
      page: () => VerifyAccountTempA(),
      // transition: Transition.downToUp,
    ),
    GetPage(
      name: '/proof',
      page: () => VerifyAccountTempA(),
    ),

    // Visa Master Card
    GetPage(
      name: '/visaMasterCard',
      page: () => VisaMasterCard(),
    ),

    // Visa Master Card
    GetPage(
      name: '/ticket',
      page: () => ListsTicketScreen(),
    ),

    // WETv
    GetPage(
      name: '/wetv',
      page: () => WeTvPackageList(),
    ),

    GetPage(
      name: '/B',
      page: () => ListProviderTempBScreen(),
    ),

    GetPage(
      name: '/airtimeborrowing',
      page: () => ListsBorrowing(),
    ),

    GetPage(
      name: '/databorrowing',
      page: () => ListsBorrowing(),
      // transition: Transition.downToUp,
    ),

    GetPage(
      name: '/C',
      page: () => ListProviderTempCScreen(),
    ),
  ];
}
