abstract class CartEvent {}

class AddCartItem extends CartEvent {
  final int productId;
  final int quantity;

  AddCartItem({
    required this.productId,
    required this.quantity,
  });
}

class AddSubCartItem extends CartEvent {
  final int productId;
  final String type;

  AddSubCartItem({
    required this.productId,
    required this.type,
  });
}

class FetchCartItem extends CartEvent {}

class DeleteCartItem extends CartEvent {
  final int productId;

  DeleteCartItem({
    required this.productId,
  });
}
