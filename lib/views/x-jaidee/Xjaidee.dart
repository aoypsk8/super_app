import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/controllers/xjaidee_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/views/x-jaidee/input_amountScreen.dart';
import 'package:super_app/views/x-jaidee/xjaidee_approve.dart';
import 'package:super_app/views/x-jaidee/xjaidee_paymentScreen.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:intl/intl.dart';

class XJaidee extends StatefulWidget {
  const XJaidee({super.key});

  @override
  State<XJaidee> createState() => _XJaideeState();
}

class _XJaideeState extends State<XJaidee> {
  final XjaideeController controller = Get.put(XjaideeController());
  final UserController userController =
      Get.find<UserController>(); // Get userController
  bool isApproveVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkApprovalVisibility(); // Ensures it runs after the first frame is built
      controller.FetchHistory();
    });
  }

  Future<void> checkApprovalVisibility() async {
    bool result = await controller.ShowMenu();
    setState(() {
      isApproveVisible = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Positioned(
            child: Container(
              height: 26.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 2),
                  colors: [Color(0xffF14D58), Color(0xFFED1C29)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: SvgPicture.asset(
                      MyIcon.bg_gradient2,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // appbar
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: color_fff,
                          size: 16.sp,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      TextFont(
                        fontSize: 12.sp,
                        text: 'ເອັກໃຈດີ',
                        color: color_fff,
                        noto: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // GridView
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: color_fff,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildButton(
                            icon: MyIcon.ic_load_xjaidee,
                            ontap: () async {
                              await controller.CheckPayment();
                            },
                            title: 'ຢືມສິນເຊື່ອ',
                          ),
                          if (isApproveVisible)
                            buildButton(
                              icon: MyIcon.ic_load_approve,
                              title: 'ອານຸມັດສິນເຊື່ອ',
                              ontap: () {
                                Get.to(() => XjaideeApproveScreen());
                              },
                            ),
                          buildButton(
                            icon: MyIcon.ic_load_cancel,
                            ontap: () {
                              if (controller.loanHistory.isNotEmpty) {
                                var lastLoan = controller
                                    .loanHistory.last; // Get last history entry

                                Get.to(() => XjaideePaymentscreen(),
                                    arguments: {
                                      "creditID": lastLoan["credit_id"],
                                      "creditAmount": lastLoan["credit_amount"],
                                      "monthToRepay":
                                          lastLoan["month_to_repay"],
                                      "percentage": lastLoan["percentage"],
                                      "monthlyPayment":
                                          lastLoan["monthly_payment"],
                                      "dateOfBorrow":
                                          lastLoan["date_of_borrow"],
                                      "status": lastLoan["status"],
                                      "total":
                                          lastLoan["total_transaction_amount"],
                                      "debt": lastLoan["debt"],
                                      "transactions":
                                          lastLoan["transactions"] ?? [],
                                    });
                              } else {
                                DialogHelper.showErrorDialogNew(
                                    description: "ບໍ່ມີປະຫວັດສິນເຊື່ອ");
                              }
                            },
                            title: 'ປິດສິນເຊື່ອ',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFont(
                    text: 'history_load',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Obx(() {
                      return controller.loanHistory.isEmpty
                          ? Center(child: Text("No loan history found"))
                          : ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: controller.loanHistory.length,
                              itemBuilder: (context, index) {
                                var loan = controller.loanHistory.reversed
                                    .toList()[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: BuildHistoryLoad(
                                    creditID: loan["credit_id"],
                                    creditAmount: loan["credit_amount"],
                                    monthToRepay: loan["month_to_repay"],
                                    percentage: loan["percentage"],
                                    monthlyPayment: loan["monthly_payment"],
                                    dateOfBorrow: loan["date_of_borrow"],
                                    status: loan["status"],
                                    total: loan["total_transaction_amount"],
                                    debt: loan["debt"],
                                    transactions: loan["transactions"] ?? "",
                                  ),
                                );
                              },
                            );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildHistoryLoad extends StatelessWidget {
  final int creditID;
  final int creditAmount;
  final String monthToRepay;
  final String percentage;
  final String monthlyPayment;
  final String dateOfBorrow;
  final String status;
  final int total;
  final int debt;
  final List<dynamic> transactions; // Updated: Handle transactions list

  const BuildHistoryLoad({
    Key? key,
    required this.creditID,
    required this.creditAmount,
    required this.monthToRepay,
    required this.percentage,
    required this.monthlyPayment,
    required this.dateOfBorrow,
    required this.status,
    required this.total,
    required this.debt,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine status text and color
    String statusText;
    Color statusColor;

    switch (status) {
      case "1":
        statusText = "ປະຕິເສດ"; // Rejected
        statusColor = Colors.red;
        break;
      case "2":
        statusText = "ລໍຖ້າອະນຸມັດ"; // Waiting for approval
        statusColor = cr_b692;
        break;
      case "3":
        statusText = "ກຳລັງຊຳລະ"; // In Payment
        statusColor = cr_7070;
        break;
      case "4":
        statusText = "ຊຳລະຄົບແລ້ວ"; // Completed
        statusColor = Colors.green;
        break;
      default:
        statusText = "ບໍ່ຮູ້ສະຖານະ"; // Unknown
        statusColor = Colors.grey;
    }

    return GestureDetector(
      onTap: () {
        // Navigate to XjaideePaymentscreen with all loan data
        Get.to(() => XjaideePaymentscreen(), arguments: {
          "creditID": creditID,
          "creditAmount": creditAmount,
          "monthToRepay": monthToRepay,
          "percentage": percentage,
          "monthlyPayment": monthlyPayment,
          "dateOfBorrow": dateOfBorrow,
          "status": status,
          "total": total,
          "debt": debt,
          "transactions": transactions, // Pass transactions safely
        });
      },
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: color_fff,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color_fff,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgPicture.asset(
                        MyIcon.ic_load_xjaidee,
                        color: cr_7070,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextFont(
                            text: NumberFormat("#,###").format(creditAmount),
                            fontSize: 13,
                          ),
                          const SizedBox(width: 5),
                          TextFont(
                            text: 'kip',
                            fontSize: 12,
                          ),
                        ],
                      ),
                      TextFont(
                        text: dateOfBorrow,
                        fontSize: 10,
                      ),
                    ],
                  ),
                ],
              ),
              TextFont(
                text: statusText,
                fontSize: 12,
                color: statusColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class buildButton extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback ontap;

  const buildButton({
    super.key,
    required this.title,
    required this.icon,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color_fff,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SvgPicture.asset(
                icon,
                color: cr_red,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFont(
            text: title,
            fontSize: 10,
          ),
        ],
      ),
    );
  }
}
