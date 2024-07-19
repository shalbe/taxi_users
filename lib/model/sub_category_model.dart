class SubCategoryModel {
  int? id;
  String? name;
  String? state;
  String? price;
  String? price2;
  int? categoryId;
  String? createdAt;
  String? updatedAt;

  SubCategoryModel(
      {this.id,
      this.name,
      this.state,
      this.price,
      this.price2,
      this.categoryId,
      this.createdAt,
      this.updatedAt});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    state = json['state'];
    price = json['price'];
    price2 = json['price2'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['state'] = state;
    data['price'] = price;
    data['price2'] = price2;
    data['category_id'] = categoryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
