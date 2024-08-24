import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_ecommerce/modules/cart/model/cart_response.dart';
import 'package:sample_ecommerce/modules/cart/presentation/bloc/cart_event.dart';
import 'package:sample_ecommerce/modules/cart/presentation/bloc/cart_state.dart';
import 'package:sample_ecommerce/modules/product/model/product_list_response.dart';
import 'package:sample_ecommerce/modules/product/repository/product_data.dart';
import 'package:sample_ecommerce/utils/keys.dart';
import 'package:sample_ecommerce/utils/sp_utils.dart';

List<CartItem> cartResponse = [];

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddCartItem>(_onAddCartItem);
    on<FetchCartItem>(_onFetchCartItem);
    on<AddSubCartItem>(_onAddSubCartItem);
    on<DeleteCartItem>(_onDeleteCartItem);
  }
  final ProductListResponse productListResponse =
      ProductListResponse.fromJson(jsonDecode(jsonEncode(productResponse)));
  int currentPage = 1;

  Future<void> _onAddCartItem(
    AddCartItem event,
    Emitter<CartState> emit,
  ) async {
    emit(CartInitial());
    List<Product> productList = productListResponse.response!.data!;
    Product productToAddInCart = productList[
        productList.indexWhere((item) => item.id == event.productId)];
    int index =
        cartResponse.indexWhere((item) => item.product.id == event.productId);

    if (index != -1) {
      cartResponse[index].quantity += event.quantity;
    } else {
      cartResponse
          .add(CartItem(product: productToAddInCart, quantity: event.quantity));
    }

    List<Map<String, dynamic>> cartJson =
        cartResponse.map((item) => item.toJson()).toList();

    await SPUtil.putObject(KeyStrings.cartItems, cartJson);

    emit(AddItemSuccess(
      successMsg: "Product added to Cart",
    ));
    add(FetchCartItem());
  }

  Future<void> _onFetchCartItem(
    FetchCartItem event,
    Emitter<CartState> emit,
  ) async {
    emit(CartInitial());
    emit(ShowCartItem(cartItem: cartResponse));
    String json = SPUtil.getString(KeyStrings.cartItems);
    if (json.isNotEmpty) {
      // Decode the JSON string
      List<dynamic> decodedJson = jsonDecode(json);
      cartResponse =
          decodedJson.map((item) => CartItem.fromJson(item)).toList();
    }
    SPUtil.putInt(KeyStrings.cartCount, cartResponse.length);
  }

  Future<void> _onAddSubCartItem(
    AddSubCartItem event,
    Emitter<CartState> emit,
  ) async {
    int index =
        cartResponse.indexWhere((item) => item.product.id == event.productId);
    if (event.type == "add") {
      cartResponse[index].quantity += 1;
      List<Map<String, dynamic>> cartJson =
          cartResponse.map((item) => item.toJson()).toList();

      await SPUtil.putObject(KeyStrings.cartItems, cartJson);
      emit(AddItemSuccess(
        successMsg: "Product added successfully",
      ));
    } else {
      cartResponse[index].quantity -= 1;
      List<Map<String, dynamic>> cartJson =
          cartResponse.map((item) => item.toJson()).toList();

      await SPUtil.putObject(KeyStrings.cartItems, cartJson);
      emit(AddItemSuccess(
        successMsg: "Product removed successfully",
      ));
    }
    add(FetchCartItem());
  }

  Future<void> _onDeleteCartItem(
    DeleteCartItem event,
    Emitter<CartState> emit,
  ) async {
    int index =
        cartResponse.indexWhere((item) => item.product.id == event.productId);
    cartResponse.remove(cartResponse[index]);
    List<Map<String, dynamic>> cartJson =
        cartResponse.map((item) => item.toJson()).toList();

    await SPUtil.putObject(KeyStrings.cartItems, cartJson);
    emit(AddItemSuccess(
      successMsg: "Product removed successfully",
    ));
    add(FetchCartItem());
  }
}
