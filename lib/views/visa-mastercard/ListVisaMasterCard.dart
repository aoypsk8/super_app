import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/views/visa-mastercard/addVisaMasterCard.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:u_credit_card/u_credit_card.dart';

class VisaMasterCard extends StatefulWidget {
  const VisaMasterCard({super.key});

  @override
  State<VisaMasterCard> createState() => _VisaMasterCardState();
}

class _VisaMasterCardState extends State<VisaMasterCard> {
  List<Map<String, String>> cardList = [
    {'cardHolder': 'AOY PHONGSAKORN', 'cardNumber': '1234567812345678'},
    {'cardHolder': 'JOHN DOE', 'cardNumber': '9876543212345678'},
    {'cardHolder': 'JANE SMITH', 'cardNumber': '1122334455667788'},
    {'cardHolder': 'AOY PHONGSAKORN', 'cardNumber': '1234567812345678'},
    {'cardHolder': 'JOHN DOE', 'cardNumber': '9876543212345678'},
    {'cardHolder': 'JANE SMITH', 'cardNumber': '1122334455667788'},
    {'cardHolder': 'AOY PHONGSAKORN', 'cardNumber': '1234567812345678'},
    {'cardHolder': 'JOHN DOE', 'cardNumber': '9876543212345678'},
    {'cardHolder': 'JANE SMITH', 'cardNumber': '1122334455667788'},
  ];

  void deleteCard(int index) {
    setState(() {
      cardList.removeAt(index);
    });
  }

  void confirmDelete(int index) {
    DialogHelper.dialogRecurringConfirm(
      title: 'Are you serious?',
      description: 'Do you want to delete this card?',
      onOk: () {
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(
        title: "Visa Master Card",
        hasIcon: true,
        customIcon: Icon(Iconsax.card_add),
        onIconTap: () {
          Get.to(AddVisaMasterCard());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cardList.length,
                itemBuilder: (context, index) {
                  final card = cardList[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 800),
                    child: SlideAnimation(
                      horizontalOffset: 500.0,
                      child: FadeInAnimation(
                        child: Stack(
                          children: [
                            SizedBox(
                              width: Get.width,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 15),
                                child: CreditCardUi(
                                  cardHolderFullName:
                                      card['cardHolder'] ?? 'No Name',
                                  cardNumber: card['cardNumber'] ?? 'No Number',
                                  validFrom: '01/23',
                                  validThru: '01/28',
                                  topLeftColor:
                                      const Color.fromARGB(255, 255, 0, 0),
                                  bottomRightColor:
                                      const Color.fromARGB(255, 73, 73, 73),
                                  doesSupportNfc: false,
                                  cardType: CardType.debit,
                                  // enableFlipping: true,
                                  placeNfcIconAtTheEnd: true,
                                  cvvNumber: '* * *',
                                ),
                              ),
                            ),
                            Positioned(
                              right: 20,
                              top: 0,
                              child: IconButton(
                                icon: Icon(
                                  Iconsax.trash,
                                  color: color_fff.withOpacity(0.5),
                                ),
                                onPressed: () => confirmDelete(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
