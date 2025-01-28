import 'package:get/get.dart';
import 'package:super_app/home_screen.dart';
import 'package:super_app/views/cashIn/CashIn.dart';
import 'package:super_app/views/cashIn/ConfirmCashIn.dart';
import 'package:super_app/views/cashout/ConfirmCashOutScreen.dart';
import 'package:super_app/views/cashout/ListsProviderBankScreen.dart';
import 'package:super_app/views/cashout/ResultCashOutScreen.dart';
import 'package:super_app/views/finance_institution/ConfirmFinanceScreen.dart';
import 'package:super_app/views/finance_institution/ListsProviderFinance.dart';
import 'package:super_app/views/finance_institution/PaymentFinanceScreen.dart';
import 'package:super_app/views/finance_institution/ResultFinanceScree.dart';
import 'package:super_app/views/finance_institution/VerifyAccountFinanceScreen.dart';
import 'package:super_app/views/templateA/lists_province_tempA.dart';
import 'package:super_app/views/templateA/verify_account_tempA.dart';
import 'package:super_app/views/transferwallet/ConfirmTranferScreen.dart';
import 'package:super_app/views/transferwallet/ResultTransferScreen.dart';
import 'package:super_app/views/transferwallet/TransferScreen.dart';
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
    GetPage(
      name: '/confirmTransfer',
      page: () => ConfirmTranferScreen(),
    ),
    GetPage(
      name: '/restultTransfer',
      page: () => Resulttransferscreen(),
    ),

    // Cash out here
    GetPage(
      name: '/cashOut',
      page: () => ListsProviderBankScreen(),
    ),
    GetPage(
      name: '/cashOutConfirm',
      page: () => ConfirmCashOutScreen(),
    ),
    GetPage(
      name: '/resultCashOut',
      page: () => ResultCashOutscreen(),
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
      name: '/cashInPage',
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
      name: '/templateA',
      page: () => ListsProvinceTempA(),
      // transition: Transition.downToUp,
    ),
    GetPage(
      name: '/verifyAccTempA',
      page: () => VerifyAccountTempA(),
      // transition: Transition.downToUp,
    ),
  ];
}
