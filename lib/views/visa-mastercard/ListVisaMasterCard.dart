import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/visa-mastercard/addVisaMasterCard.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/mask_msisdn.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';

class VisaMasterCard extends StatefulWidget {
  const VisaMasterCard({super.key});

  @override
  State<VisaMasterCard> createState() => _VisaMasterCardState();
}

class _VisaMasterCardState extends State<VisaMasterCard> {
  List<Map<String, String>> cardList = [
    {
      'cardHolder': 'AOY PHONGSAKORN',
      'cardNumber': '2052768833',
      'type': 'MmoneyX',
      'mainCard': '0'
    },
    {
      'cardHolder': 'JOHN DOE',
      'cardNumber': '9876543212345678',
      'type': 'Credit/Debit card',
      'mainCard': '0'
    },
    {
      'cardHolder': 'JANE SMITH',
      'cardNumber': '1122334455667788',
      'type': 'Credit/Debit card',
      'mainCard': '0'
    },
  ];

  int? selectedCardIndex = 0;

  void deleteCard(int index) {
    setState(() {
      cardList.removeAt(index);
      if (selectedCardIndex == index) {
        selectedCardIndex = null;
      } else if (selectedCardIndex != null && selectedCardIndex! > index) {
        selectedCardIndex = selectedCardIndex! - 1;
      }
    });
  }

  void confirmDelete(int index) {
    DialogHelper.showErrorWithFunctionDialog(
      closeTitle: "ລົບ",
      title: "ຕ້ອງການລົບບັນຊີນີ້ບໍ່",
      description: "ການກະທຳນີ້ຈະບໍ່ສາມາດກູຄືນໄດ້!",
      withCancel: true,
      onClose: () {
        setState(() {
          deleteCard(index);
        });
        Get.back();
        DialogHelper.showSuccessWithMascot(
          onClose: () => {},
          title: 'ລົບສຳເລັດ!',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(
        title: "Visa Master Card",
        // hasIcon: true,
        // customIcon: Icon(Iconsax.card_add),
        // onIconTap: () {
        //   Get.to(AddVisaMasterCard());
        // },
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: color_f4f4,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFont(text: "All Cards"),
                            GestureDetector(
                              onTap: () {
                                Get.to(AddVisaMasterCard());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 7,
                                  ),
                                  child: TextFont(
                                    color: color_fff,
                                    text: "+ Add",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Divider(color: color_b6b6),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cardList.length,
                          itemBuilder: (context, index) {
                            final card = cardList[index];
                            bool isSelected = selectedCardIndex == index;
                            return GestureDetector(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                                await Future.delayed(Duration(seconds: 2), () {
                                  setState(() {
                                    selectedCardIndex = index;
                                  });
                                  Get.back();
                                });
                                DialogHelper.showSuccessWithMascot(
                                  onClose: () => {},
                                  title: 'change_primary_success',
                                );
                              },
                              child: AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 800),
                                child: SlideAnimation(
                                  horizontalOffset: 500.0,
                                  child: FadeInAnimation(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: isSelected
                                                          ? cr_ef33
                                                          : color_9f9,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                      2.5,
                                                    ),
                                                    child: Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: isSelected
                                                            ? cr_ef33
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                TextFont(
                                                  text: "Primary account",
                                                  poppin: true,
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: card['type']! == "MmoneyX"
                                                  ? null
                                                  : () => confirmDelete(index),
                                              child: card['type']! == "MmoneyX"
                                                  ? SizedBox.shrink()
                                                  : SvgPicture.asset(
                                                      MyIcon.ic_trash,
                                                      color: cr_ef33,
                                                    ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        MoneyCardWidget(
                                          cardHolderName: card['cardHolder']!,
                                          accountNumber: card['cardNumber']!,
                                          mainCard: card['mainCard']!,
                                          type: card['type']!,
                                          selected: isSelected,
                                        ),
                                        const SizedBox(height: 10),
                                        Divider(color: color_b6b6),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoneyCardWidget extends StatelessWidget {
  final String cardHolderName;
  final String accountNumber;
  final String mainCard;
  final String type;
  final bool selected;

  MoneyCardWidget({
    required this.cardHolderName,
    required this.accountNumber,
    required this.mainCard,
    required this.type,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: selected ? color_ec1c : color_8e94,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: 20.h,
          child: Stack(
            children: [
              SvgPicture.asset(
                MyIcon.bgOfCard,
                color: selected ? cr_ef33 : color_989,
              ),
              SizedBox(
                height: Get.height,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFont(
                            text: cardHolderName,
                            color: color_fff,
                            fontSize: 13,
                          ),
                          const SizedBox(height: 10),
                          TextFont(
                            text: type,
                            color: color_fff,
                            fontSize: 10,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 11.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color_fff,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  MyConstant.profile_default,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          TextFont(
                            text: maskMsisdn(accountNumber),
                            color: color_fff,
                            fontSize: 13,
                            poppin: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
