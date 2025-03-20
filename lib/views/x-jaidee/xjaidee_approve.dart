import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_app/controllers/xjaidee_controller.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/x-jaidee/loan_detailScreen.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/textfont.dart';
import '../../utility/color.dart';

class XjaideeApproveScreen extends StatefulWidget {
  const XjaideeApproveScreen({super.key});

  @override
  State<XjaideeApproveScreen> createState() => _XjaideeApproveScreenState();
}

class _XjaideeApproveScreenState extends State<XjaideeApproveScreen> {
  final XjaideeController xjaidee = Get.find<XjaideeController>();

  @override
  void initState() {
    super.initState();
    _fetchLoanData();
  }

  Future<void> _fetchLoanData() async {
    await Future.delayed(Duration.zero); // Ensures this runs after build
    await xjaidee.FetchListloan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: "ອະນຸມັດສິນເຊື່ອ"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFont(
              text: 'ຄຳຮ້ອງຂໍສິນເຊື່ອທັງຫມົດ',
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: cr_7070,
              noto: true,
            ),
            const SizedBox(height: 10), // Adds spacing before the list
            Expanded(
              child: Obx(() {
                if (xjaidee.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (xjaidee.loanList.isEmpty) {
                  return Center(
                    child: TextFont(
                      text: "ບໍ່ມີລາຍການສິນເຊື່ອ",
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: xjaidee.loanList.length,
                  itemBuilder: (context, index) {
                    var loan = xjaidee.loanList[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => LoanDetailScreen(loan: loan));
                      },
                      child: LoanCard(
                        name: loan['name'],
                        surname: loan['surname'],
                        imageUrl: loan['img'],
                        empID: loan['emp_id'],
                        dob: loan['date_of_borrow'],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class LoanCard extends StatelessWidget {
  final String name;
  final String surname;
  final String empID;
  final String? imageUrl;
  final String dob;

  const LoanCard({
    required this.name,
    required this.surname,
    required this.imageUrl,
    required this.empID,
    required this.dob,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 25,
            backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                ? NetworkImage(imageUrl!) as ImageProvider
                : NetworkImage(MyConstant.profile_default),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFont(
                  text: "$name $surname",
                ),
                TextFont(
                  text: empID,
                ),
                TextFont(
                  text: dob,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
