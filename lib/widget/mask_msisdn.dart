// mask_msisdn.dart

String maskMsisdn(String msisdn, {bool showMsisdn = false}) {
  if (showMsisdn) {
    return msisdn;
  }
  return msisdn.replaceRange(3, msisdn.length - 3, '****');
}
