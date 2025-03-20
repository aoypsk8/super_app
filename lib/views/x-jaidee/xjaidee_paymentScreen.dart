import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:super_app/controllers/xjaidee_controller.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';

class XjaideePaymentscreen extends StatefulWidget {
  const XjaideePaymentscreen({super.key});

  @override
  State<XjaideePaymentscreen> createState() => _XjaideePaymentscreenState();
}

class _XjaideePaymentscreenState extends State<XjaideePaymentscreen> {
  final XjaideeController xjaidee = Get.find<XjaideeController>();

  late int creditID;
  late int creditAmount;
  late String monthToRepay;
  late String percentage;
  late String monthlyPayment;
  late String dateOfBorrow;
  late String status;
  late int total;
  late int debt;
  late List<dynamic> transactions;
  double progress = 0.0; // Default to 0% progress
  String progressText = "0%"; // Default percentage display
  late Color progressColor;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    creditID = args["creditID"];
    creditAmount = args["creditAmount"] ?? 1;
    monthToRepay = args["monthToRepay"];
    percentage = args["percentage"];
    monthlyPayment = args["monthlyPayment"];
    dateOfBorrow = args["dateOfBorrow"];
    status = args["status"];
    total = args["total"] ?? 0;
    debt = args["debt"];
    transactions = args["transactions"] ?? [];

    // **Calculate progress percentage**
    progress = (total / creditAmount).clamp(0.0, 1.0);
    progressText = "${(progress * 100).toStringAsFixed(0)}%";

    // **Set progress bar color**
    progressColor = (progress == 1.0) ? Colors.green : Colors.red;
  }

  String formatNumber(int number) {
    return NumberFormat("#,###").format(number); // Format numbers like 1,000
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: "ປິດສິນເຊື່ອ"),
      bottomNavigationBar: status == "3"
          ? buildBottomAppbar(
              bgColor: Theme.of(context).primaryColor,
              title: 'ປິດສິນເຊື່ອ',
              func: () async {
                // Your function logic here
              },
            )
          : null, // Hides the button if status is NOT "3"

      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Loan Summary Card
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          MyIcon.ic_load_cancel,
                          width: 80,
                          height: 80,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFont(
                            text: "ຊຳລະສິນເຊື່ອທີ່ກູ້",
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          TextFont(
                            text:
                                "${NumberFormat("#,###").format(creditAmount)} ກິບ",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Dynamic Progress Indicator
                      LinearProgressIndicator(
                        value: progress, // Dynamic progress
                        backgroundColor: Colors.grey[300],
                        color: progressColor,
                      ),
                      SizedBox(height: 5),

                      // Display progress percentage
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFont(
                            text: "${formatNumber(total)} ກິບ",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          TextFont(
                            text: progressText, // Dynamic percentage display
                            fontSize: 12,
                            color: progressColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                // Loan Details Section
                TextFont(text: "ລາຍລະອຽດການຢືມ", fontWeight: FontWeight.bold),
                SizedBox(height: 10),
                _buildDetailRow("ຈຳນວນເງີນທີ່ຢືມ",
                    "${NumberFormat("#,###").format(creditAmount)} ກີບ"),
                _buildDetailRow(
                    "ຈຳນວນເງີນຊຳລະແລ້ວ", "${formatNumber(total)} ກີບ"),
                _buildDetailRow("ຄ້າງຊຳລະ", "${formatNumber(debt)} ກີບ"),
                _buildDetailRow("ວັນທີທີ່ຢືມ", dateOfBorrow),
                _buildDetailRow("ຈຳນວນເດືອນຜ່ອນຊຳລະ", "$monthToRepay ເດືອນ"),
                _buildDetailRow("ດອກເບ້ຍ", "$percentage%"),

                SizedBox(height: 20),

                // Payment History Section
                TextFont(text: "ປະຫວັດການຊຳລະ", fontWeight: FontWeight.bold),
                SizedBox(height: 10),
                transactions.isEmpty
                    ? Text("No payment transactions")
                    : Column(
                        children: transactions.map((txn) {
                          return Column(
                            children: [
                              _buildDetailRow(
                                  "ລະຫັດຊຳລະ", txn["tran_id"].toString()),
                              _buildDetailRow("ວັນທີຊຳລະ", txn["payment_date"]),
                              _buildDetailRow("ຈຳນວນຊຳລະ",
                                  "${NumberFormat("#,###").format(txn["transaction_amount"])} ກີບ"),
                              Divider(
                                  color: Colors.grey.shade700,
                                  thickness: 1), // Adds spacing
                            ],
                          );
                        }).toList(),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build loan details row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFont(text: label, fontSize: 12, color: Colors.black54),
          TextFont(text: value, fontSize: 12, color: Colors.black54),
        ],
      ),
    );
  }

  // Build payment record
  Widget _buildPaymentRecord(String transactionId, String date, String amount) {
    return Column(
      children: [
        _buildDetailRow("ລະຫັດການສຳລະ", transactionId),
        _buildDetailRow("ວັນທີທີ່ສຳລະ", date),
        _buildDetailRow("ຈຳນວນບິນສຳລະ", amount),
        Divider(color: Colors.grey, thickness: 1),
      ],
    );
  }
}
