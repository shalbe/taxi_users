// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;

class SendNotification {
  static var SERVER_KEY =
      "AAAAvKfXmbU:APA91bG5gY8V2NtU6RMK2NJLwKJ4zXtJyTzNNVG7WldFi4ER1eHwW8hpgJj5SVtxEZ_tI6WB0ulDKsj0sv8z88DB7PCse1hsg5N3M69xnv_tO7dY78aoVXO-leq385gWexiBVdpNSPEn";
  static sendMessageNotification(
      {String? token,
      String? title,
      String? body,
      Map<String, dynamic>? payload}) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$SERVER_KEY',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': payload ?? <String, dynamic>{},
          'to': token
        },
      ),
    );
  }
}
