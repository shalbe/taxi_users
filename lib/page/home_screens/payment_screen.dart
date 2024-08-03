import 'package:cabme/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    return SafeArea(
      child: Scaffold(
        body: WebViewWidget(controller: controller.webViewcontroller!),
      ),
    );
  }
}
