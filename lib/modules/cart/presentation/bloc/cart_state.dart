import 'package:sample_ecommerce/modules/cart/model/cart_response.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class AddItemSuccess extends CartState {
  final String successMsg;
  AddItemSuccess({required this.successMsg});
}

class ShowCartItem extends CartState {
  final List<CartItem> cartItem;
  ShowCartItem({required this.cartItem});
}
