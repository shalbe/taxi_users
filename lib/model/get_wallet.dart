class GetWalletModel {
	int? id;
	bool? pending;
	int? amountCents;
	bool? success;
	bool? isAuth;
	bool? isCapture;
	bool? isStandalonePayment;
	bool? isVoided;
	bool? isRefunded;
	bool? is3dSecure;
	int? integrationId;
	int? profileId;
	bool? hasParentTransaction;
	Order? order;
	String? createdAt;
	
	String? currency;
	SourceData? sourceData;
	String? apiSource;

	
	bool? isSettled;
	bool? billBalanced;
	bool? isBill;
	int? owner;
	Null? parentTransaction;
	String? redirectUrl;
	String? iframeRedirectionUrl;

	GetWalletModel({this.id, this.pending, this.amountCents, this.success, this.isAuth, this.isCapture, this.isStandalonePayment, this.isVoided, this.isRefunded, this.is3dSecure, this.integrationId, this.profileId, this.hasParentTransaction, this.order, this.createdAt,  this.currency, this.sourceData, this.apiSource,
      this.isSettled, this.billBalanced, this.isBill, this.owner, this.parentTransaction, this.redirectUrl, this.iframeRedirectionUrl});

	GetWalletModel.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		pending = json['pending'];
		amountCents = json['amount_cents'];
		success = json['success'];
		isAuth = json['is_auth'];
		isCapture = json['is_capture'];
		isStandalonePayment = json['is_standalone_payment'];
		isVoided = json['is_voided'];
		isRefunded = json['is_refunded'];
		is3dSecure = json['is_3d_secure'];
		integrationId = json['integration_id'];
		profileId = json['profile_id'];
		hasParentTransaction = json['has_parent_transaction'];
		order = json['order'] != null ? new Order.fromJson(json['order']) : null;
		createdAt = json['created_at'];
	
		currency = json['currency'];
		sourceData = json['source_data'] != null ? new SourceData.fromJson(json['source_data']) : null;
		apiSource = json['api_source'];
	
		isSettled = json['is_settled'];
		billBalanced = json['bill_balanced'];
		isBill = json['is_bill'];
		owner = json['owner'];
		parentTransaction = json['parent_transaction'];
		redirectUrl = json['redirect_url'];
		iframeRedirectionUrl = json['iframe_redirection_url'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['pending'] = this.pending;
		data['amount_cents'] = this.amountCents;
		data['success'] = this.success;
		data['is_auth'] = this.isAuth;
		data['is_capture'] = this.isCapture;
		data['is_standalone_payment'] = this.isStandalonePayment;
		data['is_voided'] = this.isVoided;
		data['is_refunded'] = this.isRefunded;
		data['is_3d_secure'] = this.is3dSecure;
		data['integration_id'] = this.integrationId;
		data['profile_id'] = this.profileId;
		data['has_parent_transaction'] = this.hasParentTransaction;
		if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
		data['created_at'] = this.createdAt;
	
		data['currency'] = this.currency;
		if (this.sourceData != null) {
      data['source_data'] = this.sourceData!.toJson();
    }
		data['api_source'] = this.apiSource;
	
		
	
	
		data['is_settled'] = this.isSettled;
		data['bill_balanced'] = this.billBalanced;
		data['is_bill'] = this.isBill;
		data['owner'] = this.owner;
		data['parent_transaction'] = this.parentTransaction;
		data['redirect_url'] = this.redirectUrl;
		data['iframe_redirection_url'] = this.iframeRedirectionUrl;
		return data;
	}
}

class Order {
	int? id;
	String? createdAt;
	bool? deliveryNeeded;
	Merchant? merchant;
	Null? collector;
	int? amountCents;
	ShippingData? shippingData;
	String? currency;
	bool? isPaymentLocked;
	bool? isReturn;
	bool? isCancel;
	bool? isReturned;
	bool? isCanceled;
	Null? merchantOrderId;
	Null? walletNotification;
	int? paidAmountCents;
	bool? notifyUserWithEmail;
	List<Null>? items;
	String? orderUrl;
	int? commissionFees;
	int? deliveryFeesCents;
	int? deliveryVatCents;
	String? paymentMethod;
	Null? merchantStaffTag;
	String? apiSource;
	Data? data;

	Order({this.id, this.createdAt, this.deliveryNeeded, this.merchant, this.collector, this.amountCents, this.shippingData, this.currency, this.isPaymentLocked, this.isReturn, this.isCancel, this.isReturned, this.isCanceled, this.merchantOrderId, this.walletNotification, this.paidAmountCents, this.notifyUserWithEmail, this.items, this.orderUrl, this.commissionFees, this.deliveryFeesCents, this.deliveryVatCents, this.paymentMethod, this.merchantStaffTag, this.apiSource, this.data});

	Order.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		createdAt = json['created_at'];
		deliveryNeeded = json['delivery_needed'];
		merchant = json['merchant'] != null ? new Merchant.fromJson(json['merchant']) : null;
		collector = json['collector'];
		amountCents = json['amount_cents'];
		shippingData = json['shipping_data'] != null ? new ShippingData.fromJson(json['shipping_data']) : null;
		currency = json['currency'];
		isPaymentLocked = json['is_payment_locked'];
		isReturn = json['is_return'];
		isCancel = json['is_cancel'];
		isReturned = json['is_returned'];
		isCanceled = json['is_canceled'];
		merchantOrderId = json['merchant_order_id'];
		walletNotification = json['wallet_notification'];
		paidAmountCents = json['paid_amount_cents'];
		notifyUserWithEmail = json['notify_user_with_email'];
	
		orderUrl = json['order_url'];
		commissionFees = json['commission_fees'];
		deliveryFeesCents = json['delivery_fees_cents'];
		deliveryVatCents = json['delivery_vat_cents'];
		paymentMethod = json['payment_method'];
		merchantStaffTag = json['merchant_staff_tag'];
		apiSource = json['api_source'];
		data = json['data'] != null ? new Data.fromJson(json['data']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['created_at'] = this.createdAt;
		data['delivery_needed'] = this.deliveryNeeded;
		if (this.merchant != null) {
      data['merchant'] = this.merchant!.toJson();
    }
		data['collector'] = this.collector;
		data['amount_cents'] = this.amountCents;
		if (this.shippingData != null) {
      data['shipping_data'] = this.shippingData!.toJson();
    }
		data['currency'] = this.currency;
		data['is_payment_locked'] = this.isPaymentLocked;
		data['is_return'] = this.isReturn;
		data['is_cancel'] = this.isCancel;
		data['is_returned'] = this.isReturned;
		data['is_canceled'] = this.isCanceled;
		data['merchant_order_id'] = this.merchantOrderId;
		data['wallet_notification'] = this.walletNotification;
		data['paid_amount_cents'] = this.paidAmountCents;
		data['notify_user_with_email'] = this.notifyUserWithEmail;
	
		data['order_url'] = this.orderUrl;
		data['commission_fees'] = this.commissionFees;
		data['delivery_fees_cents'] = this.deliveryFeesCents;
		data['delivery_vat_cents'] = this.deliveryVatCents;
		data['payment_method'] = this.paymentMethod;
		data['merchant_staff_tag'] = this.merchantStaffTag;
		data['api_source'] = this.apiSource;
		if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
		return data;
	}
}

class Merchant {
	int? id;
	String? createdAt;
	String? state;
	String? country;
	String? city;
	String? postalCode;
	String? street;

	Merchant({this.id, this.createdAt, this.state, this.country, this.city, this.postalCode, this.street});

	Merchant.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		createdAt = json['created_at'];
		state = json['state'];
		country = json['country'];
		city = json['city'];
		postalCode = json['postal_code'];
		street = json['street'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['created_at'] = this.createdAt;
		data['state'] = this.state;
		data['country'] = this.country;
		data['city'] = this.city;
		data['postal_code'] = this.postalCode;
		data['street'] = this.street;
		return data;
	}
}

class ShippingData {
	int? id;
	String? firstName;
	String? lastName;
	String? street;
	String? building;
	String? floor;
	String? apartment;
	String? city;
	String? state;
	String? country;
	String? email;
	String? phoneNumber;
	String? postalCode;
	String? extraDescription;
	String? shippingMethod;
	int? orderId;
	int? order;

	ShippingData({this.id, this.firstName, this.lastName, this.street, this.building, this.floor, this.apartment, this.city, this.state, this.country, this.email, this.phoneNumber, this.postalCode, this.extraDescription, this.shippingMethod, this.orderId, this.order});

	ShippingData.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		firstName = json['first_name'];
		lastName = json['last_name'];
		street = json['street'];
		building = json['building'];
		floor = json['floor'];
		apartment = json['apartment'];
		city = json['city'];
		state = json['state'];
		country = json['country'];
		email = json['email'];
		phoneNumber = json['phone_number'];
		postalCode = json['postal_code'];
		extraDescription = json['extra_description'];
		shippingMethod = json['shipping_method'];
		orderId = json['order_id'];
		order = json['order'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['first_name'] = this.firstName;
		data['last_name'] = this.lastName;
		data['street'] = this.street;
		data['building'] = this.building;
		data['floor'] = this.floor;
		data['apartment'] = this.apartment;
		data['city'] = this.city;
		data['state'] = this.state;
		data['country'] = this.country;
		data['email'] = this.email;
		data['phone_number'] = this.phoneNumber;
		data['postal_code'] = this.postalCode;
		data['extra_description'] = this.extraDescription;
		data['shipping_method'] = this.shippingMethod;
		data['order_id'] = this.orderId;
		data['order'] = this.order;
		return data;
	}
}


class SourceData {
	String? type;
	String? phoneNumber;
	Null? ownerName;
	String? subType;
	String? pan;

	SourceData({this.type, this.phoneNumber, this.ownerName, this.subType, this.pan});

	SourceData.fromJson(Map<String, dynamic> json) {
		type = json['type'];
		phoneNumber = json['phone_number'];
		ownerName = json['owner_name'];
		subType = json['sub_type'];
		pan = json['pan'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['type'] = this.type;
		data['phone_number'] = this.phoneNumber;
		data['owner_name'] = this.ownerName;
		data['sub_type'] = this.subType;
		data['pan'] = this.pan;
		return data;
	}
}

class Data {
	String? klass;
	int? gatewayIntegrationPk;
	String? orderInfo;
	int? amount;
	String? currency;
	String? uigTxnId;
	String? message;
	String? mpgTxnId;
	String? walletMsisdn;
	String? walletIssuer;
	String? txnResponseCode;
	String? token;
	String? redirectUrl;
	String? merTxnRef;
	Null? upgTxnId;
	int? method;
	String? createdAt;
	String? gatewaySource;
	String? upgQrcodeRef;

	Data({this.klass, this.gatewayIntegrationPk, this.orderInfo, this.amount, this.currency, this.uigTxnId, this.message, this.mpgTxnId, this.walletMsisdn, this.walletIssuer, this.txnResponseCode, this.token, this.redirectUrl, this.merTxnRef, this.upgTxnId, this.method, this.createdAt, this.gatewaySource, this.upgQrcodeRef});

	Data.fromJson(Map<String, dynamic> json) {
		klass = json['klass'];
		gatewayIntegrationPk = json['gateway_integration_pk'];
		orderInfo = json['order_info'];
		amount = json['amount'];
		currency = json['currency'];
		uigTxnId = json['uig_txn_id'];
		message = json['message'];
		mpgTxnId = json['mpg_txn_id'];
		walletMsisdn = json['wallet_msisdn'];
		walletIssuer = json['wallet_issuer'];
		txnResponseCode = json['txn_response_code'];
		token = json['token'];
		redirectUrl = json['redirect_url'];
		merTxnRef = json['mer_txn_ref'];
		upgTxnId = json['upg_txn_id'];
		method = json['method'];
		createdAt = json['created_at'];
		gatewaySource = json['gateway_source'];
		upgQrcodeRef = json['upg_qrcode_ref'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['klass'] = this.klass;
		data['gateway_integration_pk'] = this.gatewayIntegrationPk;
		data['order_info'] = this.orderInfo;
		data['amount'] = this.amount;
		data['currency'] = this.currency;
		data['uig_txn_id'] = this.uigTxnId;
		data['message'] = this.message;
		data['mpg_txn_id'] = this.mpgTxnId;
		data['wallet_msisdn'] = this.walletMsisdn;
		data['wallet_issuer'] = this.walletIssuer;
		data['txn_response_code'] = this.txnResponseCode;
		data['token'] = this.token;
		data['redirect_url'] = this.redirectUrl;
		data['mer_txn_ref'] = this.merTxnRef;
		data['upg_txn_id'] = this.upgTxnId;
		data['method'] = this.method;
		data['created_at'] = this.createdAt;
		data['gateway_source'] = this.gatewaySource;
		data['upg_qrcode_ref'] = this.upgQrcodeRef;
		return data;
	}
}

class PaymentKeyClaims {
	int? userId;
	int? amountCents;
	String? currency;
	int? integrationId;
	int? orderId;
	BillingData? billingData;
	bool? lockOrderWhenPaid;
	Data? extra;
	bool? singlePaymentAttempt;
	int? exp;
	String? pmkIp;

	PaymentKeyClaims({this.userId, this.amountCents, this.currency, this.integrationId, this.orderId, this.billingData, this.lockOrderWhenPaid, this.extra, this.singlePaymentAttempt, this.exp, this.pmkIp});

	PaymentKeyClaims.fromJson(Map<String, dynamic> json) {
		userId = json['user_id'];
		amountCents = json['amount_cents'];
		currency = json['currency'];
		integrationId = json['integration_id'];
		orderId = json['order_id'];
		billingData = json['billing_data'] != null ? new BillingData.fromJson(json['billing_data']) : null;
		lockOrderWhenPaid = json['lock_order_when_paid'];
		extra = json['extra'] != null ? new Data.fromJson(json['extra']) : null;
		singlePaymentAttempt = json['single_payment_attempt'];
		exp = json['exp'];
		pmkIp = json['pmk_ip'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['user_id'] = this.userId;
		data['amount_cents'] = this.amountCents;
		data['currency'] = this.currency;
		data['integration_id'] = this.integrationId;
		data['order_id'] = this.orderId;
		if (this.billingData != null) {
      data['billing_data'] = this.billingData!.toJson();
    }
		data['lock_order_when_paid'] = this.lockOrderWhenPaid;
		if (this.extra != null) {
      data['extra'] = this.extra!.toJson();
    }
		data['single_payment_attempt'] = this.singlePaymentAttempt;
		data['exp'] = this.exp;
		data['pmk_ip'] = this.pmkIp;
		return data;
	}
}

class BillingData {
	String? firstName;
	String? lastName;
	String? street;
	String? building;
	String? floor;
	String? apartment;
	String? city;
	String? state;
	String? country;
	String? email;
	String? phoneNumber;
	String? postalCode;
	String? extraDescription;

	BillingData({this.firstName, this.lastName, this.street, this.building, this.floor, this.apartment, this.city, this.state, this.country, this.email, this.phoneNumber, this.postalCode, this.extraDescription});

	BillingData.fromJson(Map<String, dynamic> json) {
		firstName = json['first_name'];
		lastName = json['last_name'];
		street = json['street'];
		building = json['building'];
		floor = json['floor'];
		apartment = json['apartment'];
		city = json['city'];
		state = json['state'];
		country = json['country'];
		email = json['email'];
		phoneNumber = json['phone_number'];
		postalCode = json['postal_code'];
		extraDescription = json['extra_description'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['first_name'] = this.firstName;
		data['last_name'] = this.lastName;
		data['street'] = this.street;
		data['building'] = this.building;
		data['floor'] = this.floor;
		data['apartment'] = this.apartment;
		data['city'] = this.city;
		data['state'] = this.state;
		data['country'] = this.country;
		data['email'] = this.email;
		data['phone_number'] = this.phoneNumber;
		data['postal_code'] = this.postalCode;
		data['extra_description'] = this.extraDescription;
		return data;
	}
}

