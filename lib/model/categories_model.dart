class CategoryModel {
  int? id;
  String? name;
  String? state;
  String? createdAt;
  String? updatedAt;
  String? image;
  int? paymentType;
  CategoryModel(
      {this.id,
      this.name,
      this.state,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.paymentType});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    state = json['state'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json["img"];
    paymentType = json['payment_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['state'] = state;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['img'] = image;
    return data;
  }
}
