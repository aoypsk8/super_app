// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, sized_box_for_whitespace, prefer_const_literals_to_create_immutables
import 'package:contacts_service/contacts_service.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/views/transferwallet/buildFavoriteTransfer.dart';
import 'package:super_app/views/transferwallet/buildHistoryTranserAll.dart';
import 'package:super_app/views/transferwallet/buildHistoryTranserRecent.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _toWallet = TextEditingController();
  final TextEditingController _paymentAmount = TextEditingController();
  final TextEditingController _note = TextEditingController();
  // final UserController userController = Get.find();
  // final homeController = Get.put<HomeController>(HomeController());
  // final transferController = Get.put(TransferController());
  final storage = GetStorage();

  final FocusNode _amountFocusNode = FocusNode();
  String _contactName = '';
  int _balanceAmount = 0;
  bool isMore = false;
  bool isMoreText = false;

  void _updateParentValue(String walletNo, String contactName) {
    setState(() {
      _toWallet.text = walletNo;
      _contactName = contactName;
    });

    if (_toWallet.text != '') {
      FocusScope.of(context).requestFocus(_amountFocusNode);
    }
  }

  @override
  void initState() {
    // print(
    //     'transferScrenn destinationMsisdn ${transferController.destinationMsisdn.value}');

    // _toWallet.text = transferController.destinationMsisdn.value;

    // userController.increasepage();
    super.initState();
  }

  @override
  void dispose() {
    // userController.decreasepage();
    _toWallet.text = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cr_fbf7,
      appBar: BuildAppBar(title: "transfer"),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: FormBuilder(
            key: _formKey,
            child: Container(
              child: Column(
                children: [
                  buildToWallet(context),
                  const SizedBox(height: 12),
                  buildRecentTransfer(context),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: color_fff,
          border: Border.all(color: color_ddd),
        ),
        child: buildBottomAppbar(
          bgColor: Theme.of(context).primaryColor,
          title: 'next',
          func: () {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              _paymentProcess();
            }
          },
        ),
      ),
    );
  }

  Widget buildToWallet(BuildContext context) {
    final List<String> amountValue = [
      '10,000',
      '25,000',
      '30,000',
      '100,000',
      '500,000',
      '1,000,000',
    ];
    final List<String> textValue = [
      'ເຕີມເງິນ',
      'ຄ່າເຄື່ອງ',
      'ຄ່າອາຫານ',
      'ຄ່າເຄື່ອງດື່ມ',
      'ເກັບອອມ',
      'ໃຊ້ໜີ້',
      'ຊ່ວຍເຫຼືອ',
      'ການສຶກສາ',
    ];
    return Container(
      color: color_fff,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextFont(
              text: 'transfer_wallet',
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
            ),
            const SizedBox(height: 10),
            buildNumberFiledValidate(
              controller: _toWallet,
              label: 'fill_wallet',
              name: 'wallet',
              hintText: '20XXXXXXXX',
              max: 10,
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
              suffixIcon: Container(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  MyIcon.ic_contact,
                ),
              ),
              suffixonTapFuc: () async {
                // if (await Permission.contacts.request().isGranted) {
                //   try {
                //     final Contact? contact =
                //         await ContactsService.openDeviceContactPicker();
                //     if (contact != null) {
                //       final Item phone = contact.phones!.first;
                //       String phoneNO = phone.value
                //           .toString()
                //           .trim()
                //           .replaceAll(' ', '')
                //           .replaceAll('-', '');
                //       if (phoneNO.startsWith('020')) {
                //         setState(() {
                //           _toWallet.text = phoneNO.replaceAll('020', '20');
                //         });
                //       } else if (phoneNO.startsWith('+85620')) {
                //         setState(() {
                //           _toWallet.text = phoneNO.replaceAll('+85620', '20');
                //         });
                //       } else if (phoneNO.startsWith('85620')) {
                //         setState(() {
                //           _toWallet.text = phoneNO.replaceAll('85620', '20');
                //         });
                //       } else {
                //         setState(() {
                //           _toWallet.text = phoneNO;
                //         });
                //       }
                //     }
                //     setState(() {
                //       _contactName = contact!.displayName.toString();
                //     });
                //   } on FormOperationException catch (e) {
                //     switch (e.errorCode) {
                //       case FormOperationErrorCode.FORM_OPERATION_CANCELED:
                //       case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
                //       case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                //       default:
                //       // print(e.toString());
                //     }
                //   }
                // }
              },
            ),
            const SizedBox(height: 10),
            buildAccountingFiledVaidate(
              controller: _paymentAmount,
              label: 'amount_kip',
              name: 'amount',
              hintText: '0',
              max: 11,
              fillcolor: color_f4f4,
              bordercolor: color_f4f4,
              focus: _amountFocusNode,
              suffixWidget: true,
              suffixWidgetData: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextFont(
                      text: '.00 LAK',
                      color: cr_7070,
                      fontSize: 10.sp,
                    ),
                  ],
                ),
              ),
              suffixonTapFuc: () {},
            ),
            isMore
                ? GridView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: amountValue.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 7 / 2.5,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          _paymentAmount.text = amountValue[index];
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: color_f5f5,
                              borderRadius: BorderRadius.circular(6)),
                          child: Center(
                            child: TextFont(
                              text: amountValue[index],
                              color: color_blackE72,
                              poppin: true,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox(),
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: isMore
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isMore = isMore ? false : true;
                              });
                            },
                            child: TextFont(
                              text: 'less',
                              color: color_777,
                              fontSize: 8.sp,
                              underline: true,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_up_rounded,
                              size: 15.sp, color: color_777),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isMore = isMore ? false : true;
                            });
                          },
                          child: TextFont(
                            text: 'more',
                            color: color_777,
                            fontSize: 8.sp,
                            underline: true,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            size: 15.sp, color: color_777),
                      ],
                    ),
            ),
            SizedBox(height: 4),
            BuildTextAreaValidate(
              label: 'note',
              controller: _note,
              name: 'note',
              iconColor: color_f4f4,
              hintText: 'input_text',
            ),
            isMoreText
                ? GridView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: textValue.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 7 / 2.5,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          _note.text = textValue[index];
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color_f5f5,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: TextFont(
                              text: textValue[index],
                              color: color_blackE72,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox(),
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: isMoreText
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isMoreText = isMoreText ? false : true;
                              });
                            },
                            child: TextFont(
                              text: 'less',
                              color: color_777,
                              fontSize: 8.sp,
                              underline: true,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_up_rounded,
                              size: 15.sp, color: color_777),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isMoreText = isMoreText ? false : true;
                            });
                          },
                          child: TextFont(
                            text: 'more',
                            color: color_777,
                            fontSize: 8.sp,
                            underline: true,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down_rounded,
                            size: 15.sp, color: color_777),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRecentTransfer(BuildContext context) {
    return Container(
      color: color_fff,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 350,
              child: ContainedTabBarView(
                initialIndex: 0,
                tabBarProperties: TabBarProperties(
                  indicatorColor: Theme.of(context).primaryColor,
                ),
                tabBarViewProperties: TabBarViewProperties(
                  physics: NeverScrollableScrollPhysics(),
                ),
                tabs: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.clock,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 5),
                      TextFont(
                        text: 'recent',
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.heart,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 5),
                      TextFont(
                        text: 'favorite',
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.like, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 5),
                      TextFont(
                        text: 'all',
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
                views: [
                  buildHistoryTransferRecent(
                    updateParentValue: _updateParentValue,
                  ),
                  buildFavoriteTransfer(
                    updateParentValue: _updateParentValue,
                  ),
                  buildHistoryTransferAll(
                    updateParentValue: _updateParentValue,
                  ),
                ],
                onChange: (index) => print(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _paymentProcess() async {
    Get.toNamed("confirmTransfer");
    // DialogHelper.showErrorDialogNew(description: 'account_not_found');
    // int paymentAmount = int.parse(
    //     _paymentAmount.text.trim().replaceAll(RegExp(r'[^\w\s]+'), ''));
    // String toWallet = _toWallet.text;
    // String note = _note.text;
    // // _balanceAmount = userController.balance.value;
    // String ownerWallet = await storage.read('msisdn') ?? '';
    // if (paymentAmount < 1000) {
    //   DialogHelper.showErrorDialogNew(
    //       description: 'Minimum payment must than 1,000 Kip.');
    // } else if (_balanceAmount < paymentAmount) {
    //   DialogHelper.showErrorDialogNew(description: 'Your balance not enough.');
    // } else if (ownerWallet == toWallet) {
    //   DialogHelper.showErrorDialogNew(
    //       description: 'Can\'t transfer to same Wallet Account.');
    // } else {
    //   // transferController.vertifyWallet(
    //   //     toWallet, paymentAmount.toString(), note);
    // }
  }
}

class MultiplePointedEdgeClipperMod extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    var curXPos = 0.0;
    var curYPos = size.height;
    var increment = size.width / 40;
    while (curXPos < size.width) {
      curXPos += increment;
      curYPos = curYPos == size.height ? size.height - 10 : size.height;
      path.lineTo(curXPos, curYPos);
    }
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
