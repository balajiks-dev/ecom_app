import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_ecommerce/common/custom_form_button.dart';
import 'package:sample_ecommerce/common/custom_progress_bar.dart';
import 'package:sample_ecommerce/constants/app_colors.dart';
import 'package:sample_ecommerce/constants/assets_path.dart';
import 'package:sample_ecommerce/modules/bottom_navigation/bottom_navigation_bar.dart';
import 'package:sample_ecommerce/modules/cart/model/cart_response.dart';
import 'package:sample_ecommerce/modules/cart/presentation/bloc/cart_bloc.dart';
import 'package:sample_ecommerce/modules/cart/presentation/bloc/cart_event.dart';
import 'package:sample_ecommerce/modules/cart/presentation/bloc/cart_state.dart';
import 'package:sample_ecommerce/modules/cart/widget/quantity_modifier.dart';
import 'package:sample_ecommerce/modules/checkout/presentation/screen/checkout_screen.dart';
import 'package:sample_ecommerce/modules/product/presentation/screen/product_list_screen.dart';

class CartScreen extends StatefulWidget {
  final bool showBackButton;
  const CartScreen({super.key, this.showBackButton = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartResponse = [];
  int quantity = 0;
  int totalDiscount = 0;
  int totalGst = 0;
  int totalAmount = 0;
  String addOrSub = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc()..add(FetchCartItem()),
      child: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is ShowCartItem) {
            cartResponse = state.cartItem;
            isLoading = false;
            CustomProgressBar.hide(context);
          } else if (state is AddItemSuccess) {
            CustomProgressBar.hide(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMsg)),
            );
          } else if (state is CartInitial) {
            CustomProgressBar.show(context);
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: AppColors.primaryColor,
                title: const Text(
                  "Cart",
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
              ),
              body: isLoading
                  ? Container()
                  : cartResponse.isNotEmpty
                      ? Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  const SizedBox(height: 70),
                                  ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      quantity = cartResponse[index].quantity;
                                      return GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {},
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 120,
                                                      height: 170,
                                                      // decoration:
                                                      //     BoxDecoration(
                                                      //   color: Theme.of(
                                                      //           context)
                                                      //       .scaffoldBackgroundColor,
                                                      //   borderRadius:
                                                      //       BorderRadius
                                                      //           .circular(3),
                                                      //   boxShadow: [
                                                      //     BoxShadow(
                                                      //       color: Theme.of(
                                                      //               context)
                                                      //           .focusColor
                                                      //           .withOpacity(
                                                      //               .25),
                                                      //       spreadRadius: -4,
                                                      //       blurRadius:
                                                      //           6, // changes position of shadow
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                        child: Image.network(
                                                          cartResponse[index]
                                                                  .product
                                                                  .image ??
                                                              "",
                                                          fit: BoxFit.fill,
                                                          width:
                                                              double.infinity,
                                                          errorBuilder:
                                                              (_, __, ___) =>
                                                                  Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 14),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            cartResponse[index]
                                                                    .product
                                                                    .title ??
                                                                "",
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
                                                              height: 8),
                                                          // Text(
                                                          //   cartResponse[
                                                          //   index]
                                                          //       .product
                                                          //       .itemCode ??
                                                          //       "",
                                                          //   style:
                                                          //   const TextStyle(
                                                          //     fontWeight:
                                                          //     FontWeight
                                                          //         .w400,
                                                          //     fontSize: 14,
                                                          //     overflow:
                                                          //     TextOverflow
                                                          //         .ellipsis,
                                                          //   ),
                                                          //   maxLines: 2,
                                                          // ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            "Amount : ₹ ${cartResponse[index].product.price}",
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
                                                              height: 5),
                                                          // Text(
                                                          //   cartResponse[index]
                                                          //       .product
                                                          //       .gstPercentage !=
                                                          //       0
                                                          //       ? "GST : ${cartResponse[index].product.gstPercentage} %"
                                                          //       : "GST :",
                                                          //   style:
                                                          //   const TextStyle(
                                                          //     fontWeight:
                                                          //     FontWeight
                                                          //         .w400,
                                                          //     fontSize: 14,
                                                          //     overflow:
                                                          //     TextOverflow
                                                          //         .ellipsis,
                                                          //   ),
                                                          //   maxLines: 2,
                                                          // ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Text(
                                                            "Total Amount : ₹ ${totalPricePerItemMethod(
                                                              cartResponse[
                                                                      index]
                                                                  .quantity,
                                                              cartResponse[
                                                                          index]
                                                                      .product
                                                                      .price!
                                                                      .toInt() ??
                                                                  0,
                                                              0,
                                                            )}",
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
                                                              height: 5),
                                                          const Divider(
                                                              color:
                                                                  Colors.black),
                                                          const SizedBox(
                                                              height: 5),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text("Qty"),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              QuantityModifierWidget(
                                                                height: 25,
                                                                iconBoxWidth:
                                                                    25,
                                                                centerWidth: 25,
                                                                iconSize: 19,
                                                                quantity:
                                                                    quantity,
                                                                onQuantityUpdate:
                                                                    (value) {
                                                                  CustomProgressBar
                                                                      .show(
                                                                          context);
                                                                  BlocProvider.of<
                                                                              CartBloc>(
                                                                          context)
                                                                      .add(
                                                                    AddSubCartItem(
                                                                      productId:
                                                                          cartResponse[index].product.id ??
                                                                              0,
                                                                      type:
                                                                          addOrSub,
                                                                    ),
                                                                  );
                                                                },
                                                                maxQuantity: cartResponse[
                                                                            index]
                                                                        .product
                                                                        .quantity ??
                                                                    0,
                                                                borderColor: Theme.of(
                                                                        context)
                                                                    .disabledColor,
                                                                addOrRemove:
                                                                    (String
                                                                        value) {
                                                                  addOrSub =
                                                                      value;
                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                              const Spacer(),
                                                              GestureDetector(
                                                                behavior:
                                                                    HitTestBehavior
                                                                        .opaque,
                                                                onTap: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (cxt) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              const Text(
                                                                            'Do you want to delete this item',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                          content:
                                                                              const Text(
                                                                            "Are you sure if you want to delete this item?",
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.grey,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                          actions: <Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: CustomFormButton(
                                                                                      innerText: "Cancel",
                                                                                      borderRadius: 10,
                                                                                      fontSize: 14,
                                                                                      height: 40,
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(width: 20),
                                                                                  Expanded(
                                                                                    child: CustomFormButton(
                                                                                      innerText: "OK",
                                                                                      borderRadius: 10,
                                                                                      fontSize: 14,
                                                                                      height: 40,
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                        CustomProgressBar.show(context);
                                                                                        BlocProvider.of<CartBloc>(context).add(
                                                                                          DeleteCartItem(
                                                                                            productId: cartResponse[index].product.id ?? 0,
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      });
                                                                },
                                                                child: const Icon(
                                                                    Icons
                                                                        .delete),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 10,
                                      );
                                    },
                                    itemCount: cartResponse.length,
                                  ),
                                  const SizedBox(height: 30),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(.25),
                                          spreadRadius: -4,
                                          blurRadius:
                                              6, // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    // decoration: BoxDecoration(
                                    //   borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                                    //   color: Theme.of(context).scaffoldBackgroundColor,
                                    //   boxShadow: [
                                    //     BoxShadow(
                                    //       color:
                                    //       Colors.grey.withOpacity(.1),
                                    //     )
                                    //   ],
                                    // ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: <Widget>[
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Order Summary",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Net Total"),
                                              Text(
                                                  "₹ ${totalPrice(cartResponse)}"),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Gst Amount"),
                                              Text(
                                                  "₹ ${totalGstMethod(cartResponse)}"),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          const SizedBox(height: 5),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Shipping"),
                                              Text("Free"),
                                            ],
                                          ),
                                          const Divider(color: Colors.black),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Total Payable",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                "₹ ${totalPayableMethod()}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.4),
                                    spreadRadius: 2,
                                    offset: const Offset(1, 0),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Total",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "(${cartResponse.length} ${cartResponse.length > 1 ? "items" : "item"})",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CheckoutScreen(
                                                    cartResponse: cartResponse,
                                                    netTotal: totalPrice(
                                                        cartResponse),
                                                    gstAmount: totalGstMethod(
                                                        cartResponse),
                                                  )),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                AppColors.secondary1Color),
                                        shape: WidgetStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: AppColors.secondaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        "CHECK OUT",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetPath.emptyCartIcon,
                              // height:
                              //     MediaQuery.of(context).size.height * .4,
                              width: MediaQuery.of(context).size.width * .6,
                            ),
                            Text(
                              'Oops! Your cart is empty!',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Looks like you haven't added anything to your cart yet",
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: () {
                                  // Navigator.pop(context);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const ProductListingScreen(),
                                    ),
                                    ModalRoute.withName('/'),
                                  );
                                },
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0))),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          AppColors.secondary1Color),
                                ),
                                child: const Text(
                                  'Shop now',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
              bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: 1,
                cartCount: cartResponse.length,
              ),
            );
          },
        ),
      ),
    );
  }

  String totalGstMethod(List<CartItem> cart) {
    totalGst = 0;
    for (var code in cart) {
      totalGst += (code.quantity) * (12 ?? 0);
    }
    return totalGst.toString();
  }

  String totalPricePerItemMethod(
      int quantity, int amountPerItem, int gstAMount) {
    int total = quantity * amountPerItem;
    total += (quantity * gstAMount);
    return total.toString();
  }

  String totalPrice(List<CartItem> cart) {
    totalAmount = 0;
    for (var code in cart) {
      totalAmount += (code.quantity) * (code.product.price!.toInt() ?? 0);
    }
    return totalAmount.toString();
  }

  String totalPayableMethod() {
    int total = totalAmount + totalDiscount + totalGst;
    return total.toString();
  }
}
