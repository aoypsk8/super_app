import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildExpiryDateField.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:u_credit_card/u_credit_card.dart';

class AddVisaMasterCard extends StatefulWidget {
  const AddVisaMasterCard({super.key});

  @override
  State<AddVisaMasterCard> createState() => _AddVisaMasterCardState();
}

class _AddVisaMasterCardState extends State<AddVisaMasterCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  String _selectedCardType = 'Debit';

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
      appBar: BuildAppBar(title: "Add Visa/MasterCard"),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: color_fff,
          border: Border.all(color: color_ddd),
        ),
        child: buildBottomAppbar(
          bgColor: Theme.of(context).primaryColor,
          title: 'save_data',
          func: () {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              if (_formKey.currentState!.validate()) {
                DialogHelper.showSuccess(
                  onClose: () => {
                    Get.back(),
                  },
                  title: 'success',
                );
              }
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CreditCardUi(
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
                      cardType: _selectedCardType == 'Debit'
                          ? CardType.debit
                          : CardType.credit,
                      cardProviderLogo: Image.asset(MyIcon.ic_logo_x),
                      cardProviderLogoPosition: CardProviderLogoPosition.right,
                      // enableFlipping: true,
                      placeNfcIconAtTheEnd: true,
                      cvvNumber: _cvvController.text.isEmpty
                          ? '* * *'
                          : _cvvController.text,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                buildNumberFiledValidate(
                  controller: _nameController,
                  label: 'Cardholder Name',
                  name: 'Cardholder Name',
                  hintText: 'XXXXXXXX',
                  max: 18,
                  fillcolor: color_f4f4,
                  bordercolor: color_f4f4,
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
                const SizedBox(height: 20),
                TextFont(text: "Selecte Type Of Card"),
                SizedBox(height: 4),
                _buildDropdown(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButton2<String>(
        underline: const SizedBox(),
        isExpanded: true,
        value: _selectedCardType,
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            color: color_f4f4,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        ),
        dropdownStyleData: DropdownStyleData(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: color_f4f4,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: ['Debit', 'Credit'].map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(
              type,
              style: GoogleFonts.notoSans(fontSize: 14.sp, color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCardType = value!;
          });
        },
      ),
    );
  }
}
