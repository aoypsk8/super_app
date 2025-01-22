// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:super_app/controllers/user_controller.dart';
import '../../utility/dialog_helper.dart';

class HandleApiError {
  static void dioError(error) {
    final userController = Get.find<UserController>();
    var message = error.message;
    DialogHelper.hide();
    if (error.type == DioErrorType.badResponse) {
      DialogHelper.showErrorDialogNew(description: message);
      return;
    }

    if (error.type == DioErrorType.connectionTimeout) {
      // DialogHelper.showErrorDialog(
      //     description: 'Request timeout check your connection!');
      // DialogHelper.showErrorDialog(description: message);
      DialogHelper.showErrorWithFunctionDialog(
          description: 'Request timeout check your connection!',
          onClose: () {
            Get.close(userController.pageclose.value + 1);
          });
      return;
    }
    if (error.type == DioErrorType.receiveTimeout) {
      // DialogHelper.showErrorDialog(
      //     description: 'Request timeout unable to connect to the server');
      // DialogHelper.showErrorDialog(description: message);
      DialogHelper.showErrorWithFunctionDialog(
          description: 'Request timeout unable to connect to the server',
          onClose: () {
            Get.close(userController.pageclose.value + 1);
          });
      return;
    }
    if (error.error is SocketException) {
      DialogHelper.showErrorDialogNew(description: 'No Internet Connection!');
      // DialogHelper.showErrorDialog(description: message);
      return;
    }
    if (error.type == DioErrorType.unknown) {
      // DialogHelper.showErrorDialog(description: 'Something went wrong');
      // DialogHelper.showErrorDialog(description: message);
      DialogHelper.showErrorWithFunctionDialog(
          description: 'Something went wrong',
          onClose: () {
            Get.close(userController.pageclose.value + 1);
          });
      return;
    }
  }
}
