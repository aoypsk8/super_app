// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, unused_local_variable, depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:super_app/controllers/user_controller.dart';
import 'package:super_app/utility/app_url.dart';
import 'package:super_app/utility/dialog_helper.dart';
import 'package:super_app/utility/myKey.dart';
import 'package:super_app/utility/myconstant.dart';
import 'handle_api_error.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class DioClient {
  static Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  )..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

  // Post new Encrypt
  static Future<dynamic> postEncrypt(
    String path,
    dynamic body, {
    String key = 'lite',
    String bearer = '',
    String msisdn = '',
    String token = '',
    bool loading = true,
    bool image = false,
  }) async {
    final userController = Get.find<UserController>();
    dio.options.headers.clear();
    if (loading) Loading.show();
    try {
      final url = '${MyConstant.urlLtcdev}$path';
      print(url);
      final headers =
          _generateEncryptedHeaders(path, image == false ? body : {});
      dio.options.headers.addAll(headers);
      print(headers);
      // Handle custom headers based on the key
      _setCustomHeaders(key, bearer, msisdn, token);

      // Perform the POST request
      var response = await dio.post(url, data: body);
      print(response);

      if (loading) Loading.hide();
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 299) {
        DialogHelper.showErrorWithFunctionDialog(
          description: response.data,
          onClose: () {
            Get.close(userController.pageclose.value + 1);
          },
        );
      } else {
        DialogHelper.showErrorWithFunctionDialog(
          description: response.statusMessage!,
          onClose: () {
            Get.close(userController.pageclose.value + 1);
          },
        );
      }
    } catch (e) {
      print(e);
      Loading.hide();
      HandleApiError.dioError(e);
    }
  }

/*
  ╔═.✵.═════════════════════════════════════════════════════════════════════════════════════╗
»»————————————————————————————————⚠️ Encryption ⚠️—————————————————————————————————————————————««
  ╚═════════════════════════════════════════════════════════════════════════════════════.✵.═╝
 */

  static Map<String, String> _generateEncryptedHeaders(
      String path, dynamic body) {
    // Convert body to Map if it's a JSON string, handle null as an empty map
    Map<String, dynamic> bodyMap = {};
    if (body != null) {
      if (body is String) {
        bodyMap = jsonDecode(body) as Map<String, dynamic>;
      } else if (body is Map) {
        bodyMap = body.cast<String, dynamic>();
      } else {
        throw ArgumentError('body must be a JSON string or a Map');
      }
    }
    // Check if 'apiToken' is in the body and set it to null if it is
    final apiToken = bodyMap.containsKey('apiToken') ? "" : MyKey.apitoken;

    const username = 'lmmapi';
    const secret = '~,6a+HFa=C/P]R5Zp';
    final uuid = const Uuid().v4();
    const algorithm = 'hmac-sha256';

    final dateFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'', 'en_US')
        .format(DateTime.now().toUtc());
    final digestBody = sha256.convert(utf8.encode(jsonEncode(bodyMap))).bytes;
    final digestBodyHeader = 'SHA-256=' + base64.encode(digestBody);
    final signingString =
        'x-date: $dateFormat\nPOST $path HTTP/1.1\nx-uuid: $uuid\ndigest: $digestBodyHeader';
    final hmac = Hmac(sha256, utf8.encode(secret));
    final signature = hmac.convert(utf8.encode(signingString)).bytes;
    final signatureBase64 = base64.encode(signature);
    final authorizationHeader =
        'hmac username="$username", algorithm="$algorithm", headers="x-date request-line x-uuid digest", signature="$signatureBase64"';
    print({
      'Authorization': authorizationHeader,
      'Digest': digestBodyHeader,
      'X-Date': dateFormat,
      'X-UUID': uuid,
      'lmm-token': apiToken,
      'apikey': MyKey.apikey,
      'Content-Type': 'application/json',
    });
    return {
      'Authorization': authorizationHeader,
      'Digest': digestBodyHeader,
      'X-Date': dateFormat,
      'X-UUID': uuid,
      'lmm-token': apiToken,
      'apikey': MyKey.apikey,
      'Content-Type': 'application/json',
    };
  }

/*
  ╔═.✵.═════════════════════════════════════════════════════════════════════════════════════╗
»»————————————————————————————————⚠️ Add key and header ⚠️—————————————————————————————————————————««
  ╚═════════════════════════════════════════════════════════════════════════════════════.✵.═╝
 */
  static void _setCustomHeaders(
      String key, String bearer, String msisdn, String token) {
    final customHeaders = <String, String>{};
    switch (key) {
      case 'appkey':
        customHeaders['appkey'] = MyKey.appkey;
        break;
      case 'lite':
        customHeaders['mlitekeys'] = MyKey.mlitekeys;
        break;
      case 'mlitekeys':
        customHeaders['mlitekeys'] = MyKey.mlitekey;
        break;
      case 'point':
        customHeaders['lmmkey'] = MyKey.lmmkeyPoint;
        break;
      case 'lmmkey':
        customHeaders['lmmkey'] = MyKey.lmmkeyApp;
        break;
      case 'lmm-key':
        customHeaders['lmm-key'] = MyKey.lmmkeyPro;
        break;
      case 'lmmkeyPro':
        customHeaders['lmmkey'] = MyKey.lmmkeyPro;
        break;
      case 'redeem':
        // customHeaders['Authorization'] = 'Basic bG1tYXBpOmxtbXhAMjAyNCE=';
        break;
      case 'transfer':
        customHeaders['Authorization'] = 'Basic ${MyKey.keyTransferX}';
        break;
      case 'openkey':
        customHeaders['openkey'] = token;
        break;
      case 'visa':
        customHeaders['lmmkey'] = MyKey.keyVisa;
        break;
      case 'backup':
        customHeaders['lmmkey'] = MyKey.keyBackup;
        break;
      case 'form':
        customHeaders
            .addAll({'Content-Type': 'application/x-www-form-urlencoded'});
        break;
      case 'visa-form':
        customHeaders.addAll({
          'lmmkey': MyKey.keyVisa,
          'Content-Type': 'application/x-www-form-urlencoded'
        });
        break;
      case 'savedevice':
        customHeaders.addAll({
          "Authorization": "Basic bm90aWZpY2F0aW9uOiNMdGMxcWF6MndzeEBOT1RJ"
        });
        break;
      default:
        customHeaders['lmm-token'] =
            MyKey.desRoute == "UAT" ? MyKey.lmmTokenUAT : MyKey.lmmTokenPRO;
        break;
    }
    dio.options.headers.addAll(customHeaders);
  }

  static String mlitekeys =
      'gUkXp2r5u8x/A?D(G+KbPeShVmYq3t6v9y\$B&E)H@McQfTjWnZr4u7x!z%C*F-JaNdRgUkXp2s5v8y/B?D(G+KbPeShVmYq3t6w9z\$C&F)H@McQfTjWnZr4u7x!A%D*G';
  static String appkey = 'i4hFTaScLmWKaIfuPgXHYDmjcbz5K5a';
  static Future<dynamic> getNoLoading(String url, {String key = 'lite'}) async {
    // final storage = GetStorage();
    //dio.interceptors.add(PrettyDioLogger(request: true, requestHeader: true, requestBody: true, responseBody: true, error: true));
    dio.options.headers.clear();
    try {
      if (key == 'redeem') {
        dio.options.headers
            .addAll({'Authorization': 'Basic bG1tYXBpOmxtbXhAMjAyNCE='});
      }
      if (key == 'appkey') {
        dio.options.headers.addAll({"appkey": appkey});
      }
      if (key == 'lite') {
        dio.options.headers.addAll({"mlitekeys": mlitekeys});
      }
      if (key == 'point') {
        dio.options.headers.addAll({"lmmkey": MyKey.lmmkeyPoint});
      }
      if (key == 'lmmkey') {
        dio.options.headers.addAll({"lmmkey": MyKey.lmmkeyApp});
      }
      if (key == 'backup') {
        dio.options.headers.addAll({"lmmkey": MyKey.keyBackup});
      }
      if (key == 'notify') {
        dio.options.headers.addAll({"authorization": MyKey.keyNotify});
      }
      if (key == 'visa') {
        dio.options.headers.addAll({"lmmkey": MyKey.keyVisa});
      }
      if (key == 'lmmkeyPro') {
        dio.options.headers.addAll({"lmmkey": MyKey.lmmkeyPro});
      } else if (key == 'nokey') {
        //Todo
      } else {
        dio.options.headers.addAll({
          "lmm-token": MyConstant.desRoute == "UAT"
              ? AppUrl.lmmTokenUAT
              : AppUrl.lmmTokenPRO
        });
      }

      // logger.d('dioClient req GET === $url');
      var response = await dio.get(url);
      // logger.d('dioClient res GET === ${response.data}');

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        print('home');
      } else if (response.statusCode == 299) {
        DialogHelper.showErrorDialogNew(description: response.data);
      } else {
        DialogHelper.showErrorDialogNew(description: response.statusMessage!);
      }
    } catch (e) {
      HandleApiError.dioError(e);
    }
  }

  static Future<dynamic> post(String url, dynamic body,
      {String key = 'lite',
      String bearer = '',
      String msisdn = '',
      String token = ''}) async {
    final userController = Get.find<UserController>();
    final storage = GetStorage();
    //dio.interceptors.add(PrettyDioLogger(request: true, requestHeader: true, requestBody: true, responseBody: true, error: true));
    dio.options.headers.clear();
    Loading.show();
    try {
      if (key == 'callback_v1') {
        // API key
        const String apiKey = "ca9c07e6b8364062a8c4f53674fd0f39";
        const String username = "lmmapi";
        const String password = "lmm@2024!";
        dio.options.headers = {
          'Authorization': "Basic bG1tYXBpOmxtbUAyMDI0IQ==",
          'lmmkey': apiKey,
          'Content-Type': 'application/json'
        };
      }

      if (key == 'redeem') {
        dio.options.headers
            .addAll({'Authorization': 'Basic bG1tYXBpOmxtbXhAMjAyNCE='});
      }
      if (key == 'transfer') {
        dio.options.headers
            .addAll({'Authorization': 'Basic ${MyKey.keyTransferX}'});
      }
      if (key == 'buy-lottery-backup') {
        dio.options.headers.addAll({
          "Authorization": 'Bearer $bearer',
          "msisdn": msisdn,
          "token": token,
          "Content-Type": "application/json",
        });
      }
      if (key == 'openkey') {
        dio.options.headers.addAll({"openkey": token});
      }
      if (key == 'appkey') {
        dio.options.headers.addAll({"appkey": appkey});
      }
      if (key == 'lite') {
        dio.options.headers.addAll({"mlitekeys": mlitekeys});
      }
      if (key == 'point') {
        dio.options.headers.addAll({"lmmkey": MyKey.lmmkeyPoint});
      }
      if (key == 'lmmkey') {
        dio.options.headers.addAll({"lmmkey": MyKey.lmmkeyApp});
      }
      if (key == 'lmm-key') {
        dio.options.headers.addAll({"lmm-key": MyKey.lmmkeyPro});
      }
      if (key == 'backup') {
        if (bearer != '') {
          dio.options.headers.addAll({
            "Authorization": 'Bearer $bearer',
            "Content-Type": "application/json"
          });
        } else {
          dio.options.headers.addAll({"lmmkey": MyKey.keyBackup});
        }
      }
      if (key == 'visa') {
        dio.options.headers.addAll({"lmmkey": MyKey.keyVisa});
      }
      if (key == 'lmmkeyPro') {
        dio.options.headers.addAll({"lmmkey": MyKey.lmmkeyPro});
      } else if (key == 'nokey') {
        //Todo
      } else {
        dio.options.headers.addAll({
          "lmm-token": MyConstant.desRoute == "UAT"
              ? AppUrl.lmmTokenUAT
              : AppUrl.lmmTokenPRO
        });
      }

      // logger.d('dioClient req POST === $url');
      // logger.d('dioClient req POST === $body');

      var response = await dio.post(url, data: body);

      // logger.d('dioClient res POST === $url');
      // logger.d('dioClient res POST === ${response.data}');

      Loading.hide();
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        print('home');
      } else if (response.statusCode == 299) {
        // DialogHelper.showErrorDialog(description: response.data);
        DialogHelper.showErrorWithFunctionDialog(
            description: response.data,
            onClose: () {
              Get.close(userController.pageclose.value + 1);
            });
      } else {
        // DialogHelper.showErrorDialog(description: response.statusMessage!);
        DialogHelper.showErrorWithFunctionDialog(
            description: response.statusMessage!,
            onClose: () {
              Get.close(userController.pageclose.value + 1);
            });
      }
    } catch (e) {
      Loading.hide();
      HandleApiError.dioError(e);
      // DialogHelper.showErrorDialog(description: e.message);
    }
  }
}
