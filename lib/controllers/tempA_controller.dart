import 'package:get/get.dart';
import 'package:super_app/models/menu_model.dart';
import 'package:super_app/models/provider_tempA_model.dart';

class TempAController extends GetxController {
  RxList<ProviderTempAModel> tampAmodel = <ProviderTempAModel>[].obs;
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

  fetchtampAList(Menulists menudetail) async {
    List<String> urlSplit = menudetail.url.toString().split(";");
    print(urlSplit);
    var url = urlSplit[0];
    var response = await DioClient.postEncrypt(loading: false, url, key: 'lmm', {});
    print(response);
    tempAmodel.value = response.map<ProviderTempAModel>((json) => ProviderTempAModel.fromJson(json)).toList();
    final part = tampAmodel.map((e) => e.part).toSet().toList();
    provsep.value = part.map((e) => {"partid": e, "data": tampAmodel.where((res) => res.part == e).toList()}).toList();
  }
}
