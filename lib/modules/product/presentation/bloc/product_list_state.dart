import 'package:equatable/equatable.dart';
import 'package:sample_ecommerce/modules/product/model/product_list_response.dart';

abstract class ProductListState {}

class ProductListInitial extends ProductListState {}

class ProductDetailInitial extends ProductListState {}

class ShowProductList extends ProductListState with EquatableMixin {
  final ProductItemResponse productItemResponse;
  final List<BrandModel> brandList;
  final List<BrandModel> categoryList;
  ShowProductList({
    required this.productItemResponse,
    required this.brandList,
    required this.categoryList,
  });

  @override
  List<Object?> get props => [
    productItemResponse,
    brandList,
    categoryList,
    identityHashCode(this),
  ];
}

class ShowFilterProductList extends ProductListState with EquatableMixin {
  final ProductItemResponse productItemResponse;
  final List<BrandModel> brandList;
  final List<BrandModel> categoryList;
  ShowFilterProductList({
    required this.productItemResponse,
    required this.brandList,
    required this.categoryList,
  });

  @override
  List<Object?> get props => [
    productItemResponse,
    brandList,
    categoryList,
    identityHashCode(this),
  ];
}

class ShowProductDetail extends ProductListState {
  final Product? productDetail;
  ShowProductDetail({required this.productDetail});
}

class ProductListFailure extends ProductListState {
  final String error;
  ProductListFailure({required this.error});
}