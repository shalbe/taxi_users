class GetPaymentData {
  String? message;
  Data? data;

  GetPaymentData({this.message, this.data});

  GetPaymentData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? apiKey;
  String? integrationId;
  String? iframeId;

  Data({this.apiKey, this.integrationId, this.iframeId});

  Data.fromJson(Map<String, dynamic> json) {
    apiKey = json['api_key'];
    integrationId = json['integration_id'];
    iframeId = json['iframe_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_key'] = this.apiKey;
    data['integration_id'] = this.integrationId;
    data['iframe_id'] = this.iframeId;
    return data;
  }
}
