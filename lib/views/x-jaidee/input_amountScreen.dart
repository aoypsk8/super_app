import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:super_app/controllers/xjaidee_controller.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
import 'package:super_app/views/x-jaidee/input_infoScreen.dart';
import 'package:super_app/widget/buildAppBar.dart';
import 'package:super_app/widget/buildBottomAppbar.dart';
import 'package:super_app/widget/buildTextField.dart';
import 'package:super_app/widget/textfont.dart';

class InputAmountXJaideeScreen extends StatefulWidget {
  const InputAmountXJaideeScreen({super.key});

  @override
  State<InputAmountXJaideeScreen> createState() =>
      _InputAmountXJaideeScreenState();
}

class _InputAmountXJaideeScreenState extends State<InputAmountXJaideeScreen> {
  final XjaideeController xjaidee = Get.find<XjaideeController>();
  final TextEditingController _paymentAmount = TextEditingController();
  final TextEditingController _percent = TextEditingController();
  final TextEditingController _months = TextEditingController();
  final TextEditingController _monthlyPayment = TextEditingController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  double _currentValue = 500000;
  final double _min = 500000;
  double _max = 5000000; // Default value, will be updated in initState
  final double _step = 500000;

  var dataMonths = [
    {"month_id": 1, "Name": "1"},
    {"month_id": 2, "Name": "2"},
    {"month_id": 3, "Name": "3"},
    {"month_id": 4, "Name": "4"},
    {"month_id": 5, "Name": "5"},
    {"month_id": 6, "Name": "6"},
  ];

  @override
  void initState() {
    super.initState();

    _max = (xjaidee.balance.value ?? 0) > _min ? xjaidee.balance.value : _min;

    // If _max is not a multiple of _step, don't round up. Just use the exact balance.
    if (_max % _step != 0) {
      _max = (_max ~/ _step) *
          _step; // Ensure _max is always a multiple of 500,000
    }

    _paymentAmount.text = fn.format(_currentValue);
    _percent.text = '3%';
    _months.text = '${dataMonths.first['Name']}';
    _updateMonthlyPayment();
  }

  @override
  void dispose() {
    _paymentAmount.dispose();
    _percent.dispose();
    _months.dispose();
    _monthlyPayment.dispose();
    super.dispose();
  }

  void _updateAmount(double value) {
    setState(() {
      if (_max <= _min) {
        _currentValue = _min; // If _max is too low, set it to the minimum
      } else if (value >= _max) {
        _currentValue = _max;
      } else {
        _currentValue = (value / _step).round() * _step;
      }

      _paymentAmount.text = fn.format(_currentValue);
      xjaidee.paymentAmount.value = _currentValue;
      _updateMonthlyPayment();
    });
  }

  void _updateMonthlyPayment() {
    int months = int.tryParse(_months.text.split('-').last) ?? 1;
    double monthlyPayment =
        (_currentValue / months) + (_currentValue * 3 / 100);
    _monthlyPayment.text = fn.format(monthlyPayment);
    xjaidee.monthlyPayment.value = monthlyPayment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: "ຢືມສິນເຊື່ອ"),
      bottomNavigationBar: buildBottomAppbar(
        bgColor: Theme.of(context).primaryColor,
        title: 'next',
        func: () async {
          if (_max <= _min) {
            DialogHelper.showErrorDialogNew(
                description: "Your balance is too low to proceed.");
            return;
          }
          await xjaidee.fetchDetails();
          xjaidee.paymentAmount.value = _currentValue;
          xjaidee.percent.value = _percent.text;
          xjaidee.months.value = _months.text.split('-').first;
          xjaidee.monthlyPayment.value =
              double.tryParse(_monthlyPayment.text.replaceAll(',', '')) ?? 0.0;
          Get.to(() => InputInfoXJaideeScreen());
        },
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildAccountingFiledVaidate(
                    enable: false,
                    controller: _paymentAmount,
                    label: 'amount_kip',
                    name: 'amount',
                    hintText: '0',
                    max: 9,
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
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
                  const SizedBox(height: 5),
                  Slider(
                    value: _currentValue,
                    min: _min,
                    max: _max < _min
                        ? _min
                        : _max, // Ensure max is never less than min
                    divisions: (_max > _min)
                        ? ((_max - _min) ~/ _step)
                        : null, // Ensure divisions is valid
                    activeColor: color_ec1c,
                    inactiveColor: cr_7070.withOpacity(0.3),
                    onChanged: (_max > _min)
                        ? (double value) {
                            _updateAmount(value);
                          }
                        : null, // Disable slider if max is too low
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFont(text: '500 K', color: cr_7070),
                        TextFont(
                            text: '${(_max / 1000).round()} K', color: cr_7070),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildDropDown_return_Value_Name_Validate(
                    controller: _months,
                    label: 'ເລືອກໄລຍະທີ່ຈະຢືມສິນເຊື່ອ',
                    name: 'months',
                    hintText: 'Select your months',
                    dataObject: dataMonths,
                    initValue:
                        '${dataMonths.first['month_id']}-${dataMonths.first['Name']}',
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                    colName: 'Name',
                    valName: 'month_id',
                    onChanged: (value) {
                      setState(() {
                        _months.text = value!;
                        _updateMonthlyPayment();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  buildAccountingFiledVaidate(
                    enable: false,
                    controller: _percent,
                    label: 'ດອກເບ້ຍຕໍ່ເດືອນ',
                    name: 'percent',
                    hintText: '3 %',
                    max: 9,
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                  buildAccountingFiledVaidate(
                    enable: false,
                    controller: _monthlyPayment,
                    label: 'ຈຳນວນເງິນຜ່ອນຊຳລະ / ເດືອນ',
                    name: 'monthly_payment',
                    hintText: '0 ກີບ',
                    max: 9,
                    fillcolor: color_f4f4,
                    bordercolor: color_f4f4,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
