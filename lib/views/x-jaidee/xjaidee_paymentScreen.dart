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
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: "ປິດສິນເຊື່ອ"),
      bottomNavigationBar: buildBottomAppbar(
        bgColor: Theme.of(context).primaryColor,
        title: 'ປິດສິນເຊື່ອ',
        func: () async {},
      ),
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
                        padding: EdgeInsets.all(
                            10), // Optional padding inside the container
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          borderRadius: BorderRadius.circular(
                              100), // Rounded corners // Soft border
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.2), // Light shadow
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3), // Subtle shadow position
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          MyIcon
                              .ic_load_cancel, // Ensure this is a valid SVG path
                          width: 50, // Icon size
                          height: 50,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 10),
                              TextFont(
                                text: "ຊຳລະສິນເຊື່ອທີ່ກູ້",
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ],
                          ),
                          TextFont(
                            text: "5,000,000 ກິບ",
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: 1.0, // 100% completion
                        backgroundColor: Colors.grey[300],
                        color: Colors.green,
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextFont(text: "5,000,000 ກິບ", fontSize: 12),
                          TextFont(
                              text: "100%", fontSize: 12, color: Colors.green),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Loan Details Section
                TextFont(text: "ລາຍລະອຽດການຢືມ", fontWeight: FontWeight.bold),
                SizedBox(height: 10),
                _buildDetailRow("ຈຳນວນບິນເຕັມ", "5,000,000 ກິບ"),
                _buildDetailRow("ຈຳນວນບິນທີ່ສຳລະແລ້ວ", "5,000,000 ກິບ"),
                _buildDetailRow("ຍັງຄ້າງຊໍາລະ", "0 ກິບ"),
                _buildDetailRow("ວັນທີຢືມ", "09 Sep 2024 09:30 AM"),
                _buildDetailRow("ຈຳນວນເດືອນຜ່ອນຊໍາລະ", "6 ເດືອນ"),
                _buildDetailRow("ດອກເບ້ຍ", "6%"),

                SizedBox(height: 20),

                // Payment History Section
                TextFont(text: "ປະຫວັດການສຳລະ", fontWeight: FontWeight.bold),
                SizedBox(height: 10),
                _buildPaymentRecord("MAF13413412132131", "09 Sep 2024 09:30 AM",
                    "1,000,000 ກິບ"),
                _buildPaymentRecord("MAF13413412132131", "09 Sep 2024 09:30 AM",
                    "1,000,000 ກິບ"),
                _buildPaymentRecord("MAF13413412132131", "09 Sep 2024 09:30 AM",
                    "1,000,000 ກິບ"),
                _buildPaymentRecord("MAF13413412132131", "09 Sep 2024 09:30 AM",
                    "1,000,000 ກິບ"),
                _buildPaymentRecord("MAF13413412132131", "09 Sep 2024 09:30 AM",
                    "1,000,000 ກິບ"),
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
          TextFont(text: label, fontSize: 14, color: Colors.black54),
          TextFont(text: value, fontSize: 14, fontWeight: FontWeight.bold),
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
