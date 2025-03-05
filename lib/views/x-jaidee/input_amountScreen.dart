import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myconstant.dart';
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
  final TextEditingController _paymentAmount = TextEditingController();
  final TextEditingController _percent = TextEditingController();
  final TextEditingController _months = TextEditingController();
  final TextEditingController _monthlyPayment = TextEditingController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  double _currentValue = 1000000;
  final double _min = 500000;
  final double _max = 5000000;
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
    _paymentAmount.text = fn.format(_currentValue);
    _updateMonthlyPayment();
  }

  @override
  void dispose() {
    super.dispose();
    DialogHelper.hide();
  }

  void _updateAmount(double value) {
    setState(() {
      _currentValue = (value / _step).round() * _step;
      _paymentAmount.text = fn.format(_currentValue);
      _updateMonthlyPayment();
    });
  }

  void _updateMonthlyPayment() {
    int months = int.tryParse(_months.text.split('-').last) ?? 3;
    double monthlyPayment = _currentValue / months;
    _monthlyPayment.text = fn.format(monthlyPayment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_fff,
      appBar: BuildAppBar(title: "ຢືມສິນເຊື່ອ"),
      bottomNavigationBar: buildBottomAppbar(
        bgColor: Theme.of(context).primaryColor,
        title: 'next',
        func: () {
          // _paymentProcess();
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
                    max: _max,
                    divisions: ((_max - _min) / _step).round(),
                    activeColor: color_ec1c,
                    inactiveColor: cr_7070.withOpacity(0.3),
                    onChanged: (double value) {
                      _updateAmount(value);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFont(
                          text: '500 K',
                          color: cr_7070,
                        ),
                        TextFont(
                          text: '5.000 K',
                          color: cr_7070,
                        ),
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
                    label: 'ເປີເຊັນການຜ່ອນຊຳລະ',
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
