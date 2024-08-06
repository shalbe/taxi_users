class GetApiKeyModel {
  bool? success;
  String? message;
  Data? data;

  GetApiKeyModel({this.success, this.message, this.data});

  GetApiKeyModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
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
  String? walletIntegrationId;
  String? walletIframeId;
  String? valueIntegrationId;
  String? valueIframeId;

  Data(
      {this.apiKey,
      this.integrationId,
      this.iframeId,
      this.walletIntegrationId,
      this.walletIframeId,
      this.valueIntegrationId,
      this.valueIframeId});

  Data.fromJson(Map<String, dynamic> json) {
    apiKey = json['api_key'];
    integrationId = json['integration_id'];
    iframeId = json['iframe_id'];
    walletIntegrationId = json['wallet_integration_id'];
    walletIframeId = json['wallet_iframe_id'];
    valueIntegrationId = json['value_integration_id'];
    valueIframeId = json['value_iframe_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_key'] = this.apiKey;
    data['integration_id'] = this.integrationId;
    data['iframe_id'] = this.iframeId;
    data['wallet_integration_id'] = this.walletIntegrationId;
    data['wallet_iframe_id'] = this.walletIframeId;
    data['value_integration_id'] = this.valueIntegrationId;
    data['value_iframe_id'] = this.valueIframeId;
    return data;
  }
}
