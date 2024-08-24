abstract class ProductListEvent {}

class FetchProductList extends ProductListEvent {
  final int subCategoryId;
  final int brandId;
  FetchProductList({this.subCategoryId=0, this.brandId=0});
}

class FetchFilterProductList extends ProductListEvent {
  final List<int> brandId;
  final int categoryId;
  FetchFilterProductList({required this.brandId, required this.categoryId});
}

class FetchProductDetails extends ProductListEvent {
  final int productId;

  FetchProductDetails({required this.productId});
}

class ChangeFilterOption extends ProductListEvent {
  final int selectedIndex;
  ChangeFilterOption({required this.selectedIndex});
}