import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:super_app/controllers/home_controller.dart';
import 'package:super_app/controllers/payment_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/views/webview/webview_screen.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildExpiryDateField.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:u_credit_card/u_credit_card.dart';

class PaymentVisaMasterCard extends StatefulWidget {
  const PaymentVisaMasterCard({
    super.key,
    required this.function,
    required this.trainID,
    required this.description,
    required this.amount,
  });
  final VoidCallback function;
  final String trainID;
  final int amount;
  final String description;

  @override
  State<PaymentVisaMasterCard> createState() => _PaymentVisaMasterCardState();
}

class _PaymentVisaMasterCardState extends State<PaymentVisaMasterCard> {
  final paymentController = Get.put(PaymentController());
  final _formKey = GlobalKey<FormState>();
  final HomeController homeController = Get.find();
  String cardType = 'MASTERCARD';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool isChecked = false;
  // Function to detect card type
  String detectCardType(String cardNumber) {
    if (cardNumber.isEmpty) return '';
    if (cardNumber.startsWith('4')) {
      return 'VISA';
    } else if (RegExp(r'^5[1-5]').hasMatch(cardNumber) ||
        RegExp(r'^222[1-9]|^22[3-9][0-9]|^2[3-6][0-9]{2}|^27[0-1][0-9]|^2720')
            .hasMatch(cardNumber)) {
      return 'MasterCard';
    }
    return 'Unknown';
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _numberController.addListener(() => setState(() {}));
    _expiryController.addListener(() => setState(() {}));
    _cvvController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: "PaymentByCreditCard"),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: color_fff,
          border: Border.all(color: color_ddd),
        ),
        child: buildBottomAppbar(
          bgColor: Theme.of(context).primaryColor,
          title: 'payment',
          func: () async {
            setState(() {
              cardType = detectCardType(_numberController.text);
            });
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              if (isChecked) {
                if (await paymentController
                    .paymentCardWithoutstoredCardUniqueID(
                  widget.trainID,
                  _numberController.text,
                  _expiryController.text.replaceAll('/', ''),
                  _cvvController.text,
                  _nameController.text,
                  cardType,
                  widget.description,
                  widget.amount,
                  false,
                )) {
                  widget.function();
                }
              } else {
                DialogHelper.showErrorWithFunctionDialog(
                  closeTitle: "close",
                  title: "Please Check",
                  description: "Please check box first",
                  onClose: () {
                    Get.back();
                  },
                );
              }
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(color: cr_fdeb),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          MyIcon.ic_security_check,
                          color: cr_ef33,
                        ),
                        const SizedBox(width: 5),
                        TextFont(
                          text: "M moneyX payment protection",
                          color: cr_ef33,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                CreditCardUi(
                  cardHolderFullName: _nameController.text.isEmpty
                      ? 'Card Holder'
                      : _nameController.text,
                  cardNumber: _numberController.text.isEmpty
                      ? '**** **** **** ****'
                      : _numberController.text,
                  validFrom: 'MM/YY',
                  validThru: _expiryController.text.isEmpty
                      ? 'MM/YY'
                      : _expiryController.text,
                  topLeftColor: const Color.fromARGB(255, 255, 0, 0),
                  bottomRightColor: const Color.fromARGB(255, 73, 73, 73),
                  doesSupportNfc: true,
                  cardProviderLogoPosition: CardProviderLogoPosition.right,
                  // enableFlipping: true,
                  placeNfcIconAtTheEnd: true,
                  cvvNumber: _cvvController.text.isEmpty
                      ? '* * *'
                      : _cvvController.text,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      buildNumberFiledValidate(
                        controller: _nameController,
                        label: 'Cardholder Name',
                        name: 'Cardholder Name',
                        hintText: 'XXXXXXXX',
                        max: 18,
                        fillcolor: color_f4f4,
                        bordercolor: color_f4f4,
                        textType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),
                      buildNumberFiledValidate(
                        controller: _numberController,
                        label: 'Card Number',
                        name: 'Card Number',
                        hintText: 'XXXXXXXX',
                        max: 16,
                        fillcolor: color_f4f4,
                        bordercolor: color_f4f4,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: buildExpiryDateField(
                              title: "Expiry Date (MM/YY)",
                              controller: _expiryController,
                              hintText: "MM/YY",
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: buildNumberFiledValidate(
                              controller: _cvvController,
                              label: 'CVV',
                              name: 'CVV',
                              hintText: 'XXX',
                              max: 3,
                              fillcolor: color_f4f4,
                              bordercolor: color_f4f4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      isChecked = !isChecked;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5),
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: BorderSide(color: Colors.grey),
                            activeColor: color_ec1c,
                            checkColor: Colors.white,
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              TextFont(
                                text: 'I agree to the ',
                                color: color_1a1,
                                fontSize: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  homeController.urlwebview.value =
                                      'https://gateway.ltcdev.la/AppImage/en/consumer/policy/index.html';
                                  Get.to(() => WebviewScreen());
                                },
                                child: TextFont(
                                  text: 'Terms & Policy',
                                  underline: true,
                                  underlineColor: cr_7070,
                                  color: cr_7070,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
