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
import 'package:super_app/views/transferwallet/ConfirmTranferScreen.dart';
import 'package:super_app/views/transferwallet/ResultTransferScreen.dart';
import 'package:super_app/views/transferwallet/TransferScreen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => HomeScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/transfer',
      page: () => TransferScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/confirmTransfer',
      page: () => ConfirmTranferScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/restultTransfer',
      page: () => Resulttransferscreen(),
      transition: Transition.downToUp,
    ),

    // Cash out here
    GetPage(
      name: '/cashOut',
      page: () => ListsProviderBankScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/cashOutConfirm',
      page: () => ConfirmCashOutScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/resultCashOut',
      page: () => ResultCashOutscreen(),
      transition: Transition.downToUp,
    ),

    // Institution
    GetPage(
      name: '/finance',
      page: () => ListsProviderFinance(),
      transition: Transition.downToUp,
    ),

    GetPage(
      name: '/vertifyAccountFinace',
      page: () => VerifyAccountFinanceScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/paymentFinace',
      page: () => PaymentFinanceScreen(),
      transition: Transition.downToUp,
    ),

    GetPage(
      name: '/confirmFinance',
      page: () => ConfirmFinanceScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/resultFinance',
      page: () => ResultFinanceScreen(),
      transition: Transition.downToUp,
    ),

    // cash IN
    GetPage(
      name: '/cashInPage',
      page: () => CashInScreen(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/confirmCashIN',
      page: () => ConfirmCashInScreen(),
      transition: Transition.downToUp,
    ),

    GetPage(
      name: '/templateA',
      page: () => ListsProvinceTempA(),
      transition: Transition.downToUp,
    ),
  ];
}
