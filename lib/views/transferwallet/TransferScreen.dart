// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, sized_box_for_whitespace, prefer_const_literals_to_create_immutables
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/transfer_controller.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/views/transferwallet/buildFavoriteTransfer.dart';
import 'package:super_app/views/transferwallet/buildHistoryTranserRecent.dart';
import 'package:super_app/widget/RoundedRectangleTabIndicator';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/build_step_process.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _toWallet = TextEditingController();
  final TextEditingController _paymentAmount = TextEditingController();
  final TextEditingController _note = TextEditingController();
  final UserController userController = Get.find();
  final homeController = Get.find<HomeController>();
  final transferController = Get.put(TransferController());
  final storage = GetStorage();
  final FocusNode _amountFocusNode = FocusNode();
  String _contactName = '';
  int _balanceAmount = 0;
  bool isMore = false;
  bool isMoreText = false;

  late TabController _tabController;
  int indexTabs = 0;

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
    userController.increasepage();
    _toWallet.text = '';
    _balanceAmount = 0;
    _toWallet.text = transferController.destinationMsisdn.value;

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.index != indexTabs) {
        setState(() {
          indexTabs = _tabController.index;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    userController.decreasepage();
    _tabController.dispose();
    _toWallet.text = '';
    transferController.destinationMsisdn.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: cr_fbf7,
        appBar: BuildAppBar(title: homeController.menutitle.value),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: FormBuilder(
              key: _formKey,
              child: Container(
                height: Get.height,
                child: Column(
                  children: [
                    buildToWallet(context),
                    const SizedBox(height: 12),
                    buildTabBar(context),
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
            isEnabled: transferController.enableBottom.value,
            func: () {
              transferController.enableBottom.value = false;
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                _paymentProcess();
              }
            },
          ),
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
      "ເຕີມເງິນ",
      "ຄ່າເຄື່ອງ",
      "ຄ່າອາຫານ",
      "ຄ່າເຄື່ອງດື່ມ",
      "ເກັບອອມ",
      "ໃຊ້ໜີ້",
      "ຊ່ວຍເຫຼືອ",
      "ການສຶກສາ"
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
            buildStepProcess(title: "1/3", desc: "transfer_wallet"),
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
                if (await Permission.contacts.request().isGranted) {
                  try {
                    final Contact? contact =
                        await ContactsService.openDeviceContactPicker();
                    if (contact != null) {
                      final Item phone = contact.phones!.first;
                      String phoneNO = phone.value
                          .toString()
                          .trim()
                          .replaceAll(' ', '')
                          .replaceAll('-', '');
                      if (phoneNO.startsWith('020')) {
                        setState(() {
                          _toWallet.text = phoneNO.replaceAll('020', '20');
                        });
                      } else if (phoneNO.startsWith('+85620')) {
                        setState(() {
                          _toWallet.text = phoneNO.replaceAll('+85620', '20');
                        });
                      } else if (phoneNO.startsWith('85620')) {
                        setState(() {
                          _toWallet.text = phoneNO.replaceAll('85620', '20');
                        });
                      } else {
                        setState(() {
                          _toWallet.text = phoneNO;
                        });
                      }
                    }
                    setState(() {
                      _contactName = contact!.displayName.toString();
                    });
                  } on FormOperationException catch (e) {
                    switch (e.errorCode) {
                      case FormOperationErrorCode.FORM_OPERATION_CANCELED:
                      case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
                      case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                      default:
                    }
                  }
                }
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
                      fontSize: 10,
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
                              fontSize: 8,
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
                            fontSize: 8,
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
                              fontSize: 8,
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
                            fontSize: 8,
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

  Widget buildTabBar(BuildContext context) {
    return Expanded(
      child: Container(
        color: color_fff,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: RoundedRectangleTabIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                  weight: 4.0,
                  borderRadius: 10.0,
                ),
                onTap: (index) => setState(() {
                  indexTabs = index;
                }),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: TextFont(
                      text: 'recent',
                      fontWeight: FontWeight.w600,
                      color: indexTabs == 0
                          ? Theme.of(context).colorScheme.onPrimary
                          : cr_7070,
                    ),
                  ),
                  Tab(
                    child: TextFont(
                      text: 'favorite',
                      fontWeight: FontWeight.w600,
                      color: indexTabs == 1
                          ? Theme.of(context).colorScheme.onPrimary
                          : cr_7070,
                    ),
                  ),
                ],
                indicatorColor: Theme.of(context).colorScheme.onPrimary,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    buildHistoryTransferRecent(
                      updateParentValue: _updateParentValue,
                    ),
                    buildFavoriteTransfer(
                      updateParentValue: _updateParentValue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _paymentProcess() async {
    int paymentAmount = int.parse(
        _paymentAmount.text.trim().replaceAll(RegExp(r'[^\w\s]+'), ''));
    String toWallet = _toWallet.text;
    String note = _note.text;
    _balanceAmount = userController.mainBalance.value;
    String ownerWallet = await storage.read('msisdn') ?? '';
    if (paymentAmount < 1000) {
      transferController.enableBottom.value = true;
      DialogHelper.showErrorDialogNew(
          description: 'Minimum payment must than 1,000 Kip.');
    } else if (_balanceAmount < paymentAmount) {
      transferController.enableBottom.value = true;
      DialogHelper.showErrorDialogNew(description: 'Your balance not enough.');
    } else if (ownerWallet == toWallet) {
      transferController.enableBottom.value = true;
      DialogHelper.showErrorDialogNew(
          description: 'Can\'t transfer to same Wallet Account.');
    } else {
      transferController.vertifyWallet(
          toWallet, paymentAmount.toString(), note);
    }
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
