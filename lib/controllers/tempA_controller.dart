import 'package:get/get.dart';
import 'package:super_app/models/menu_model.dart';
import 'package:super_app/models/provider_tempA_model.dart';
import 'package:super_app/services/api/dio_client.dart';

class TempAController extends GetxController {
  RxList<ProviderTempAModel> tempAmodel = <ProviderTempAModel>[].obs;
  RxList<Map<String, Object?>> provsep = <Map<String, Object?>>[].obs;

  RxString rxaccnumber = ''.obs;
  RxString rxaccname = ''.obs;
  RxString debit = ''.obs;
  RxString rxtransid = ''.obs;
  RxString rxtimestamp = ''.obs;
  RxString rxNote = ''.obs;
  RxString rxPaymentAmount = ''.obs;
  var logVerify;
  var logPaymentReq;
  var logPaymentRes;

  var isLoading = false.obs;
  // menudetail.url = 'https://electricx.mmoney.la/getList;https://electricx.mmoney.la/verify;https://electricx.mmoney.la/payment;https://electricx.mmoney.la/getRecent;https://electricx.mmoney.la/history;';

  Menulists menudetailA = Menulists();

  TempAController() {
    menudetailA.url = '/Electric/getList;/Electric/verify;/Electric/payment;/Electric/getRecent;/Electric/history;';
  }

  @override
  void onReady() {
    super.onReady();
    fetchTempAList(); // Automatically fetch data when the controller is ready
  }

  Future<void> fetchTempAList() async {
    try {
      // Check if the URL is valid
      if (menudetailA.url == null || menudetailA.url!.isEmpty) {
        throw Exception("Invalid or empty URL in menudetail.");
      }

      // Split the URL
      List<String> urlSplit = menudetailA.url!.split(";");
      if (urlSplit.isEmpty || urlSplit[0].isEmpty) {
        throw Exception("Malformed URL: Unable to extract the first URL part.");
      }

      // Extract the primary URL
      var url = urlSplit[0];
      print("Requesting data from URL: $url");

      // Make the API call
      var response = await DioClient.postEncrypt(loading: false, url, key: 'lmm', {});

      // Check if the response is valid
      if (response == null || response.isEmpty) {
        throw Exception("Empty or invalid response received from API.");
      }

      print("Response received: $response");

      // Map the response to a list of ProviderTempAModel
      tempAmodel.value = response.map<ProviderTempAModel>((json) => ProviderTempAModel.fromJson(json)).toList();

      // Extract unique parts
      final part = tempAmodel.map((e) => e.part).toSet().toList();

      // Map the parts to a structured list
      provsep.value = part.map((e) {
        return {"partid": e, "data": tempAmodel.where((res) => res.part == e).toList()};
      }).toList();

      print("Processed data: $provsep");
    } catch (e, stackTrace) {
      print("Error in fetchTempAList: $e");
      print(stackTrace);
    }
  }
}
