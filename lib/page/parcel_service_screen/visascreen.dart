import 'dart:async';
import 'dart:io';

import 'package:cabme/constant/const.dart';
import 'package:cabme/constant/customtext.dart';
import 'package:cabme/constant/style.dart';
import 'package:flutter/material.dart';

import 'package:webview_universal/webview_universal.dart';

class VisaScreen extends StatefulWidget {
  VisaScreen({Key? key}) : super(key: key);

  @override
  VisaScreenState createState() => VisaScreenState();
}

class VisaScreenState extends State<VisaScreen> {
  WebViewController webViewController = WebViewController();

  
  @override
  void initState() {
    super.initState();
    webViewController.init(
      context: context,
      setState: setState,
      uri: Uri.parse(
          'https://accept.paymobsolutions.com/api/acceptance/iframes/$iframeIdCard?payment_token=$finalToken'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: defcolor,
        title: CustomText(
          data: 'Payment By Card',
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: WebView(
        controller: webViewController,
      ),
    );
  }
}
