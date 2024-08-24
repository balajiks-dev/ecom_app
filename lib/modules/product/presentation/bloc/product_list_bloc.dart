import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_ecommerce/modules/product/model/product_list_response.dart';
import 'package:sample_ecommerce/modules/product/presentation/bloc/product_list_event.dart';
import 'package:sample_ecommerce/modules/product/presentation/bloc/product_list_state.dart';
import 'package:sample_ecommerce/modules/product/repository/product_data.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc() : super(ProductListInitial()) {
    on<FetchProductList>(_onProductListEvent);
  }
  List<BrandModel> brandList = [];
  List<BrandModel> categoryList = [];
  bool isLoading = false;

  Future<void> _onProductListEvent(
      FetchProductList event, Emitter<ProductListState> emit) async {
    emit(ProductListInitial());
    final ProductListResponse productListResponse =
        ProductListResponse.fromJson(jsonDecode(jsonEncode(productResponse)));
    if (productListResponse.response != null) {
      if (productListResponse.status == "success") {
        emit(
          ShowProductList(
            productItemResponse: productListResponse.response!,
            brandList: brandList,
            categoryList: categoryList,
          ),
        );
      }
    }
  }
}
