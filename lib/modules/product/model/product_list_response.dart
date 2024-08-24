import 'dart:convert';

import 'package:sample_ecommerce/utils/type_converter.dart';

ProductListResponse productListResponseFromJson(String str) =>
    ProductListResponse.fromJson(json.decode(str));

class ProductListResponse {
  String? status;
  ProductItemResponse? response;
  int? code;

  ProductListResponse({
    this.status,
    this.response,
    this.code,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      ProductListResponse(
        status: TypeConverter.parse<String>(json["status"]),
        response: json["response"] == null
            ? null
            : ProductItemResponse.fromJson(json["response"]),
        code: TypeConverter.parse<int>(json["code"]),
      );
}

class ProductItemResponse {
  int? currentPage;
  List<Product>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  ProductItemResponse({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory ProductItemResponse.fromJson(Map<String, dynamic> json) =>
      ProductItemResponse(
        currentPage: TypeConverter.parse<int>(json["current_page"]),
        data: json["data"] == null
            ? []
            : List<Product>.from(json["data"]!.map((x) => Product.fromJson(x))),
        firstPageUrl: TypeConverter.parse<String>(json["first_page_url"]),
        from: TypeConverter.parse<int>(json["from"]),
        lastPage: TypeConverter.parse<int>(json["last_page"]),
        lastPageUrl: TypeConverter.parse<String>(json["last_page_url"]),
        links: json["links"] != null
            ? List<Link>.from(json["links"].map((x) => Link.fromJson(x)))
            : [],
        path: TypeConverter.parse<String>(json["path"]),
        perPage: TypeConverter.parse<int>(json["per_page"]),
        to: TypeConverter.parse<int>(json["to"]),
        total: TypeConverter.parse<int>(json["total"]),
      );
}

class Product {
  int? id;
  String? title;
  double? price;
  String? description;
  String? category;
  String? image;
  Rating? rating;
  int? quantity;

  Product(
      {this.id,
      this.title,
      this.price,
      this.description,
      this.category,
      this.image,
      this.rating,
      this.quantity});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        title: json['title'],
        price: TypeConverter.parse<double>(json["price"]),
        description: json['description'],
        category: json['category'],
        image: json['image'],
        quantity: json['quantity'],
        rating: json['rating'] != null
            ? new Rating.fromJson(json['rating'])
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['category'] = this.category;
    data['image'] = this.image;
    data['quantity'] = this.quantity;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    return data;
  }
}

class Rating {
  double? rate;
  int? count;

  Rating({this.rate, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = TypeConverter.parse<double>(json["rate"]);
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['rate'] = this.rate;
    data['count'] = this.count;
    return data;
  }
}

// class Product {
//   int? id;
//   int? clientId;
//   String? itemName;
//   String? itemCode;
//   String? hsnCode;
//   int? categoryId;
//   int? subCategoryId;
//   int? brandId;
//   int? colourId;
//   String? productType;
//   int? active;
//   String? itemImage;
//   String? tag;
//   String? productUnit;
//   int? productUnitValue;
//   int? warrenty;
//   int? baseAmount;
//   int? gstPercentage;
//   int? gstAmount;
//   int? amount;
//   int? mrpAmount;
//   int? purchaseAmount;
//   String? discountType;
//   int? minSellQuantity;
//   int? availableQuantity;
//   int? lowStockQuantity;
//   String? shortDescription;
//   String? description;
//   int? createdBy;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   BrandModel? category;
//   BrandModel? brand;
//   BrandModel? subCategory;
//   BrandModel? colour;
//   IsAddedToCart? isAddedToCart;
//   List<Gallary>? gallery;
//   List<Feature>? features;
//   bool isFavorite;

//   Product(
//       {this.id,
//         this.clientId,
//         this.itemName,
//         this.itemCode,
//         this.hsnCode,
//         this.categoryId,
//         this.subCategoryId,
//         this.brandId,
//         this.colourId,
//         this.productType,
//         this.active,
//         this.itemImage,
//         this.tag,
//         this.productUnit,
//         this.productUnitValue,
//         this.warrenty,
//         this.baseAmount,
//         this.gstPercentage,
//         this.gstAmount,
//         this.amount,
//         this.mrpAmount,
//         this.purchaseAmount,
//         this.discountType,
//         this.minSellQuantity,
//         this.availableQuantity,
//         this.lowStockQuantity,
//         this.shortDescription,
//         this.description,
//         this.createdBy,
//         this.createdAt,
//         this.updatedAt,
//         this.category,
//         this.brand,
//         this.subCategory,
//         this.colour,
//         this.isAddedToCart,
//         this.gallery,
//         this.features,
//         this.isFavorite = false
//       });

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//     id: TypeConverter.parse<int>(json["id"]),
//     clientId: TypeConverter.parse<int>(json["client_id"]),
//     itemName: TypeConverter.parse<String>(json["item_name"]),
//     itemCode: TypeConverter.parse<String>(json["item_code"]),
//     hsnCode: TypeConverter.parse<String>(json["hsn_code"]),
//     categoryId: TypeConverter.parse<int>(json["category_id"]),
//     subCategoryId: TypeConverter.parse<int>(json["sub_category_id"]),
//     brandId: TypeConverter.parse<int>(json["brand_id"]),
//     colourId: TypeConverter.parse<int>(json["colour_id"]),
//     productType: TypeConverter.parse<String>(json["product_type"]),
//     active: TypeConverter.parse<int>(json["active"]),
//     itemImage: TypeConverter.parse<String>(json["item_image"]),
//     tag: TypeConverter.parse<String>(json["tag"]),
//     productUnit: TypeConverter.parse<String>(json["product_unit"]),
//     productUnitValue: TypeConverter.parse<int>(json["product_unit_value"]),
//     warrenty: TypeConverter.parse<int>(json["warrenty"]),
//     baseAmount: TypeConverter.parse<int>(json["base_amount"]),
//     gstPercentage: TypeConverter.parse<int>(json["gst_percentage"]),
//     gstAmount: TypeConverter.parse<int>(json["gst_amount"]),
//     amount: TypeConverter.parse<int>(json["amount"]),
//     mrpAmount: TypeConverter.parse<int>(json["mrp_amount"]),
//     purchaseAmount: TypeConverter.parse<int>(json["purchase_amount"]),
//     discountType: TypeConverter.parse<String>(json["discount_type"]),
//     minSellQuantity: TypeConverter.parse<int>(json["min_sell_quantity"]),
//     availableQuantity: TypeConverter.parse<int>(json["available_quantity"]),
//     lowStockQuantity: TypeConverter.parse<int>(json["low_stock_quantity"]),
//     shortDescription: TypeConverter.parse<String>(json["short_description"]),
//     description: TypeConverter.parse<String>(json["description"]),
//     createdBy: json["created_by"],
//     createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//     updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//     category: json["category"] == null ? null : BrandModel.fromJson(json["category"]),
//     brand: json["brand"] == null ? null : BrandModel.fromJson(json["brand"]),
//     subCategory: json["sub_category"] == null ? null : BrandModel.fromJson(json["sub_category"]),
//     colour: json["colour"] == null ? null : BrandModel.fromJson(json["colour"]),
//     isAddedToCart: json["is_added_to_cart"] == null ? null : IsAddedToCart.fromJson(json["is_added_to_cart"]),
//     gallery: json["gallary"] == null ? [] : List<Gallary>.from(json["gallary"]!.map((x) => Gallary.fromJson(x))),
//     features: json["features"] == null ? [] : List<Feature>.from(json["features"]!.map((x) => Feature.fromJson(x))),
//   );
// }

class BrandModel {
  int? id;
  String? name;

  BrandModel({
    this.id,
    this.name,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        id: TypeConverter.parse<int>(json["id"]),
        name: TypeConverter.parse<String>(json["name"]),
      );
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );
}

class IsAddedToCart {
  final int? id;
  final int? userId;
  final int? productId;
  final int? quantity;
  final int? orderId;
  final int? cartCheckoutId;
  final int? amount;
  final int? mrpAmount;
  final int? discountType;
  final int? discountApply;
  final int? baseAmount;
  final int? gstPercentage;
  final int? gstAmount;
  final int? discountAmount;
  final int? isConfirmed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IsAddedToCart({
    this.id,
    this.userId,
    this.productId,
    this.quantity,
    this.orderId,
    this.cartCheckoutId,
    this.amount,
    this.mrpAmount,
    this.discountType,
    this.discountApply,
    this.baseAmount,
    this.gstPercentage,
    this.gstAmount,
    this.discountAmount,
    this.isConfirmed,
    this.createdAt,
    this.updatedAt,
  });

  factory IsAddedToCart.fromJson(Map<String, dynamic> json) => IsAddedToCart(
        id: TypeConverter.parse<int>(json["id"]),
        userId: TypeConverter.parse<int>(json["user_id"]),
        productId: TypeConverter.parse<int>(json["product_id"]),
        quantity: TypeConverter.parse<int>(json["quantity"]),
        orderId: TypeConverter.parse<int>(json["order_id"]),
        cartCheckoutId: TypeConverter.parse<int>(json["cart_checkout_id"]),
        amount: TypeConverter.parse<int>(json["amount"]),
        mrpAmount: TypeConverter.parse<int>(json["mrp_amount"]),
        discountType: TypeConverter.parse<int>(json["discount_type"]),
        discountApply: TypeConverter.parse<int>(json["discount_apply"]),
        baseAmount: TypeConverter.parse<int>(json["base_amount"]),
        gstPercentage: TypeConverter.parse<int>(json["gst_percentage"]),
        gstAmount: TypeConverter.parse<int>(json["gst_amount"]),
        discountAmount: TypeConverter.parse<int>(json["discount_amount"]),
        isConfirmed: TypeConverter.parse<int>(json["is_confirmed"]),
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );
}

class Feature {
  int? id;
  String? name;
  int? productId;
  String? description;
  int? sortOrder;

  Feature({
    this.id,
    this.name,
    this.productId,
    this.description,
    this.sortOrder,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: TypeConverter.parse<int>(json["id"]),
        name: TypeConverter.parse<String>(json["name"]),
        productId: TypeConverter.parse<int>(json["product_id"]),
        description: TypeConverter.parse<String>(json["description"]),
        sortOrder: TypeConverter.parse<int>(json["sort_order"]),
      );
}

class Gallary {
  int? id;
  int? productId;
  String? imageName;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Gallary({
    this.id,
    this.productId,
    this.imageName,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Gallary.fromJson(Map<String, dynamic> json) => Gallary(
        id: TypeConverter.parse<int>(json["id"]),
        productId: TypeConverter.parse<int>(json["product_id"]),
        imageName: TypeConverter.parse<String>(json["image_name"]),
        createdBy: TypeConverter.parse<int>(json["created_by"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
