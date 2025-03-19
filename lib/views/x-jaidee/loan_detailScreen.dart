import 'package:flutter/material.dart';
import 'package:super_app/views/image_preview.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';
import '../../utility/color.dart';
import 'package:intl/intl.dart';

class LoanDetailScreen extends StatefulWidget {
  final Map<String, dynamic> loan;

  const LoanDetailScreen({super.key, required this.loan});

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  String formatCurrency(dynamic amount) {
    try {
      double value = double.tryParse(amount.toString()) ?? 0.0;
      final formatter = NumberFormat("#,### ກີບ");
      return formatter.format(value);
    } catch (e) {
      return "0 ກີບ"; // Default fallback in case of error
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        widget.loan['img'] != null && widget.loan['img'].isNotEmpty
            ? widget.loan['img']
            : "";

    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: "ລາຍລະອຽດຜູ້ກູ້"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Restored GestureDetector for Image Preview
            GestureDetector(
              onTap: () {
                if (imageUrl.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagepreviewScreen(
                        imageUrl: imageUrl,
                        title: 'Preview',
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.all(4),
                child: CircleAvatar(
                  radius: 100, // Bigger Profile Image
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage:
                      imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: imageUrl.isEmpty
                      ? Icon(Icons.person,
                          size: 80, color: Colors.grey.shade600)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            buildLoanFiledValidate(
              enable: false,
              controller: TextEditingController(text: widget.loan['emp_id']),
              label: "ລະຫັດພະນັກງານ",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            buildLoanFiledValidate(
              enable: false,
              controller: TextEditingController(text: widget.loan['name']),
              label: "ຊື່",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            buildLoanFiledValidate(
              enable: false,
              controller: TextEditingController(text: widget.loan['surname']),
              label: "ນາມສະກຸນ",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            buildLoanFiledValidate(
              enable: false,
              controller: TextEditingController(text: widget.loan['msisdn']),
              label: "ເບີພະນັກງານ",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            buildLoanFiledValidate(
              enable: false,
              controller: TextEditingController(text: widget.loan['tel']),
              label: "ເບີຕິດຕໍ່",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            buildLoanFiledValidate(
              enable: false,
              controller:
                  TextEditingController(text: widget.loan['department']),
              label: "ສັງກັດຢູ່ພະແນກ",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            buildLoanFiledValidate(
              enable: false,
              controller: TextEditingController(text: widget.loan['section']),
              label: "ສັງກັດຢູ່ພາກສ່ວນ",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            buildLoanFiledValidate(
              enable: false,
              controller:
                  TextEditingController(text: widget.loan['date_of_birth']),
              label: "ວັນເດືອນປີເກີດ",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            buildLoanFiledValidate(
              enable: false,
              controller:
                  TextEditingController(text: widget.loan['start_work_date']),
              label: "ວັນເດືອນປີເຂົ້າການ",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            buildLoanFiledValidate(
              enable: false,
              controller: TextEditingController(
                  text: formatCurrency(widget.loan['amount'])),
              label: "ຈຳນວນເງີນທີ່ຢືມ",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            buildLoanFiledValidate(
              enable: false,
              controller: TextEditingController(
                  text: "${widget.loan['month_to_repay']} ເດືອນ"),
              label: "ຈຳນວນເດືອນຜ່ອນຊຳລະ",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            buildLoanFiledValidate(
              enable: false,
              controller: TextEditingController(
                text: formatCurrency(widget.loan['monthly_payment']),
              ),
              label: "ຈຳນວນເດືອນຜ່ອນຊຳລະ / ເດືອນ",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
            ),
            const SizedBox(height: 10),
            BuildTextAreaValidate1(
              enable: false,
              controller: TextEditingController(
                  text: widget.loan['description'] ?? 'ບໍ່ມີ'),
              label: "ຈຸດປະສົງການຂໍກູ້ຢືມເງີນ",
              name: '',
              hintText: '',
              fillcolor: color_f4f4,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: TextFont(
                    text: "ປະຕິເສດ",
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print("Description:");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: TextFont(
                    text: "ອະນຸມັດ",
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
