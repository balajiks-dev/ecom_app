import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_ecommerce/common/custom_progress_bar.dart';
import 'package:sample_ecommerce/common/custom_search_bar.dart';
import 'package:sample_ecommerce/constants/app_colors.dart';
import 'package:sample_ecommerce/modules/bottom_navigation/bottom_navigation_bar.dart';
import 'package:sample_ecommerce/modules/cart/model/cart_response.dart';
import 'package:sample_ecommerce/modules/cart/presentation/bloc/cart_bloc.dart';
import 'package:sample_ecommerce/modules/cart/presentation/bloc/cart_event.dart';
import 'package:sample_ecommerce/modules/cart/presentation/bloc/cart_state.dart';
import 'package:sample_ecommerce/modules/cart/presentation/screen/cart_screen.dart';
import 'package:sample_ecommerce/modules/login/auth_service/auth_service.dart';
import 'package:sample_ecommerce/modules/login/presentation/screen/login_screen.dart';
import 'package:sample_ecommerce/modules/product/model/product_list_response.dart';
import 'package:sample_ecommerce/modules/product/presentation/bloc/product_list_bloc.dart';
import 'package:sample_ecommerce/modules/product/presentation/bloc/product_list_event.dart';
import 'package:sample_ecommerce/modules/product/presentation/bloc/product_list_state.dart';
import 'product_details.dart';

class ProductListingScreen extends StatefulWidget {
  final int brandId;
  final String brandName;
  final bool isFromBrand;
  final bool showBackButton;
  const ProductListingScreen(
      {super.key,
      this.brandId = 0,
      this.brandName = "",
      this.isFromBrand = false,
      this.showBackButton = false});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  List<Product> productList = [];
  List<Product> filterProductList = [];
  List<Product> searchProductList = [];
  List<CartItem> cartItem = [];
  List<BrandModel> brandList = [];
  List<BrandModel> categoryList = [];
  Map<String, int> brandNameToId = {};
  Map<String, int> categoryNameToId = {};
  Map<String, List<String>> brandToCategories = {};
  List<int> selectedCategoryOptionId = [];
  List<int> selectedBrandOptionId = [];
  bool hasMoreData = true;
  bool isLoading = true;
  bool isFilter = false;
  bool isSearch = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  late ProductListBloc productListBloc;
  Timer? _debounce;
  List<String> selectedBrands = [];
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog and cancel the logout action
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                AuthService.signOut();
                // Close the dialog and proceed with the logout action
                Navigator.of(context).pop();
                // Add your logout logic here
                // For example, navigating to the login screen:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        widget.isFromBrand
            ? BlocProvider(
                create: (context) => ProductListBloc()
                  ..add(FetchProductList(brandId: widget.brandId)),
              )
            : BlocProvider(
                create: (context) => ProductListBloc()..add(FetchProductList()),
              ),
        BlocProvider(
          create: (context) => CartBloc()..add(FetchCartItem()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductListBloc, ProductListState>(
            listener: (context, state) {
              if (state is ShowProductList) {
                CustomProgressBar.hide(context);
                isLoading = false;
                productListBloc = BlocProvider.of<ProductListBloc>(context);
                productList.addAll(state.productItemResponse.data ?? []);
                brandList = state.brandList;
                categoryList = state.categoryList;
                // List<String> stringList = SPUtil.getStringList(KeyStrings.wishListProductId);
                // favProducts = stringList.map((str) => int.parse(str)).toList();
                BlocProvider.of<CartBloc>(context).add(FetchCartItem());
              } else if (state is ProductListInitial) {
                CustomProgressBar.show(context);
              } else if (state is ProductListFailure) {
                isLoading = false;
                CustomProgressBar.hide(context);
              }
            },
          ),
          BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is AddItemSuccess) {
                CustomProgressBar.hide(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.successMsg)),
                );
              } else if (state is ShowCartItem) {
                cartItem = state.cartItem;
                CustomProgressBar.hide(context);
              } else if (state is CartInitial) {
                CustomProgressBar.show(context);
              }
            },
          ),
        ],
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: AppColors.primaryColor,
                    title: widget.isFromBrand
                        ? Text(
                            widget.brandName,
                            style: const TextStyle(color: Colors.white),
                          )
                        : const Text(
                            "Products",
                            style: TextStyle(color: Colors.white),
                          ),
                    centerTitle: true,
                    leading: Visibility(
                      visible: widget.showBackButton,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: AppColors.arrowBackColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _showLogoutConfirmationDialog(context);
                        },
                      ),
                    ],
                  ),
                  bottomNavigationBar: widget.isFromBrand
                      ? null
                      : CustomBottomNavigationBar(
                          selectedIndex: 0,
                          cartCount: cartItem.length,
                        ),
                  body: isLoading
                      ? Container()
                      : Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SearchTextField(
                                      padding: const EdgeInsets.all(10.0),
                                      controller: searchController,
                                      hintText:
                                          'search product here'.toUpperCase(),
                                      onChanged: (value) {
                                        if (_debounce?.isActive ?? false) {
                                          _debounce?.cancel();
                                        }
                                        _debounce = Timer(
                                            const Duration(milliseconds: 500),
                                            () {
                                          if (value.isNotEmpty) {
                                            isSearch = true;
                                            searchProductList.clear();
                                            searchProductList = isFilter
                                                ? filterProductList
                                                    .where((item) =>
                                                        item.title!.toLowerCase().contains(value.toLowerCase()) ||
                                                        item.category!.toLowerCase().contains(value
                                                            .toLowerCase()) ||
                                                        item.category!
                                                            .toLowerCase()
                                                            .contains(value
                                                                .toLowerCase()))
                                                    .toList()
                                                : productList
                                                    .where((item) =>
                                                        item.title!
                                                            .toLowerCase()
                                                            .contains(value
                                                                .toLowerCase()) ||
                                                        item.category!
                                                            .toLowerCase()
                                                            .contains(value
                                                                .toLowerCase()) ||
                                                        item.category!
                                                            .toLowerCase()
                                                            .contains(value.toLowerCase()))
                                                    .toList();
                                            setState(() {});
                                          } else {
                                            isSearch = false;
                                            setState(() {});
                                          }
                                        });
                                      },
                                      suffixIcon: isSearch
                                          ? IconButton(
                                              icon: const Icon(
                                                Icons.clear,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  searchController.clear();
                                                  isSearch = false;
                                                });
                                              },
                                            )
                                          : null,
                                    ),
                                  ),
                                  // const Spacer(),
                                ],
                              ),
                            ),
                            (isSearch
                                    ? searchProductList.isNotEmpty
                                    : productList.isNotEmpty)
                                ? Expanded(
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: (isSearch
                                          ? searchProductList.length
                                          : productList.length),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 380,
                                      ),
                                      itemBuilder: (context, index) {
                                        Product currentProduct = isSearch
                                            ? searchProductList[index]
                                            : productList[index];
                                        String price =
                                            (currentProduct.price! + 10.0)
                                                .toStringAsFixed(2);
                                        return GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    ProductDetailScreen(
                                                  productDetail: currentProduct,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(.1))
                                                  ],
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 16,
                                                              left: 16,
                                                              right: 16),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                              height: 15),
                                                          SizedBox(
                                                            height: 150,
                                                            width: 200,
                                                            child: Stack(
                                                              children: [
                                                                SizedBox(
                                                                  height: 150,
                                                                  width: 200,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    child: Image
                                                                        .network(
                                                                      currentProduct
                                                                              .image ??
                                                                          "",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width: double
                                                                          .infinity,
                                                                      errorBuilder: (_,
                                                                              __,
                                                                              ___) =>
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Container(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 3),
                                                          Text(
                                                            "${currentProduct.title ?? ""} \n",
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            maxLines: 2,
                                                          ),
                                                          const SizedBox(
                                                              height: 3),
                                                          Text(
                                                            currentProduct
                                                                    .category!
                                                                    .toUpperCase() ??
                                                                "",
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            maxLines: 2,
                                                          ),
                                                          const SizedBox(
                                                              height: 3),
                                                          // Text(
                                                          //   (currentProduct
                                                          //           .itemCode)
                                                          //       .toString(),
                                                          //   style:
                                                          //       const TextStyle(
                                                          //     // fontWeight: FontWeight.bold,
                                                          //     fontSize: 14,
                                                          //     overflow:
                                                          //         TextOverflow
                                                          //             .ellipsis,
                                                          //   ),
                                                          //   maxLines: 2,
                                                          // ),
                                                          const SizedBox(
                                                              height: 3),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "₹ ${currentProduct.price.toString()}",
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                maxLines: 2,
                                                              ),
                                                              const SizedBox(
                                                                  width: 20),
                                                              Text(
                                                                "₹ ${price}",
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 14,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                ),
                                                                maxLines: 2,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 3),
                                                          // Text(
                                                          //   "You get ${discount(currentProduct.baseAmount!, currentProduct.mrpAmount!)}% discount \n",
                                                          //   style:
                                                          //       const TextStyle(
                                                          //     fontWeight:
                                                          //         FontWeight
                                                          //             .bold,
                                                          //     fontSize: 14,
                                                          //     color:
                                                          //         Colors.green,
                                                          //     overflow:
                                                          //         TextOverflow
                                                          //             .ellipsis,
                                                          //   ),
                                                          //   maxLines: 2,
                                                          // ),
                                                          // const SizedBox(
                                                          //     height: 3),
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                "Qty : ",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                maxLines: 2,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                (currentProduct
                                                                        .quantity)
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 14,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                maxLines: 2,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10,
                                                              bottom: 5),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        height: 40,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            if (!cartItem.any(
                                                                (e) =>
                                                                    e.product
                                                                        .id ==
                                                                    currentProduct
                                                                        .id)) {
                                                              BlocProvider.of<
                                                                          CartBloc>(
                                                                      context)
                                                                  .add(
                                                                AddCartItem(
                                                                    productId:
                                                                        currentProduct.id ??
                                                                            0,
                                                                    quantity:
                                                                        1),
                                                              );
                                                            } else {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const CartScreen(
                                                                    showBackButton:
                                                                        true,
                                                                    // selectedIndex: 2,
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          style: ButtonStyle(
                                                            shape: WidgetStateProperty.all(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            0))),
                                                            // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                                                            backgroundColor: WidgetStateProperty.all<
                                                                Color>(cartItem
                                                                    .any((e) =>
                                                                        e.product
                                                                            .id ==
                                                                        currentProduct
                                                                            .id)
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    24,
                                                                    98,
                                                                    27)
                                                                : AppColors
                                                                    .secondary1Color),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .shopping_cart_rounded,
                                                                color: Colors
                                                                    .white,
                                                                size: 20,
                                                              ),
                                                              Text(
                                                                cartItem.any((e) =>
                                                                        e.product
                                                                            .id ==
                                                                        currentProduct
                                                                            .id)
                                                                    ? "ADDED TO CART"
                                                                    : "ADD TO CART",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // if (currentProduct.tag != null)
                                              //   Positioned(
                                              //   top: 5,
                                              //   left: 10,
                                              //   right: 10,
                                              //   child: SizedBox(
                                              //     width: double.infinity,
                                              //     height: 25,
                                              //     child: ClipRRect(
                                              //       child: BackdropFilter(
                                              //         filter:
                                              //             ImageFilter.blur(
                                              //                 sigmaX: 5.0,
                                              //                 sigmaY: 5.0),
                                              //         child: Container(
                                              //           decoration:
                                              //               const BoxDecoration(
                                              //             color: Colors.blue,
                                              //             borderRadius:
                                              //                 BorderRadius
                                              //                     .all(
                                              //               Radius.circular(
                                              //                   5.0), // Adjust this value for the curve
                                              //             ),
                                              //           ),
                                              //           child: Center(
                                              //             child: Text(
                                              //               currentProduct
                                              //                       .tag ??
                                              //                   "",
                                              //               style:
                                              //                   const TextStyle(
                                              //                 color: Colors
                                              //                     .white,
                                              //                 fontWeight:
                                              //                     FontWeight
                                              //                         .bold,
                                              //                 fontSize: 14,
                                              //               ),
                                              //               textAlign:
                                              //                   TextAlign
                                              //                       .center,
                                              //               maxLines: 2,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Expanded(
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      child: const Center(
                                        child: Text(
                                          "No Data Found",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20),
                          ],
                        ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String discount(int baseAmount, int mrpAmount) {
    double discountPercentage = ((mrpAmount - baseAmount) / mrpAmount) * 100;
    return discountPercentage.toStringAsFixed(0);
  }
}
