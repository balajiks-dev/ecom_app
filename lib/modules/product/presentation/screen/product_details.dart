import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sample_ecommerce/common/custom_progress_bar.dart';
import 'package:sample_ecommerce/constants/app_colors.dart';
import 'package:sample_ecommerce/modules/cart/model/cart_response.dart';
import 'package:sample_ecommerce/modules/cart/presentation/bloc/cart_bloc.dart';
import 'package:sample_ecommerce/modules/cart/presentation/bloc/cart_event.dart';
import 'package:sample_ecommerce/modules/cart/presentation/bloc/cart_state.dart';
import 'package:sample_ecommerce/modules/cart/presentation/screen/cart_screen.dart';
import 'package:sample_ecommerce/modules/product/model/product_list_response.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product productDetail;

  const ProductDetailScreen({super.key, required this.productDetail});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? productDetail;
  List<CartItem> cartItem = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    productDetail = widget.productDetail;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc()..add(FetchCartItem()),
      child: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is ShowCartItem) {
            cartItem = state.cartItem;
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
            String price = (productDetail!.price! + 10.0).toStringAsFixed(2);
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: AppColors.primaryColor,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.arrowBackColor,
                  ),
                ),
                title: Text(
                  productDetail!.title!.toUpperCase() ?? "",
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      productDetail?.image ?? "",
                      fit: BoxFit.fitHeight,
                      width: double.infinity,
                      height: 350,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        return child;
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          height: 80,
                          width: 120,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 5),
                            child: Expanded(
                              child: Text(
                                productDetail?.title ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "₹ ${productDetail?.price.toString() ?? ""}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Visibility(
                                visible: productDetail != null &&
                                    productDetail!.price != null,
                                child: Text(
                                  "₹ $price",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              titleValue(
                                  "Category",
                                  productDetail?.category
                                          ?.toString()
                                          .toUpperCase() ??
                                      ""),
                              titleValue("Quantity",
                                  productDetail?.quantity.toString() ?? ""),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Html(
                            data: productDetail?.description ?? "",
                            style: {
                              '#': Style(
                                padding: HtmlPaddings.zero,
                                fontWeight: FontWeight.w400,
                                margin: Margins(
                                    bottom: Margin.zero(),
                                    top: Margin.zero(),
                                    left: Margin.zero(),
                                    right: Margin.auto()),
                                lineHeight: const LineHeight(1.5),
                                // fontSize: FontSize(14),
                              ),
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!cartItem.any(
                                (e) => e.product.id == productDetail!.id)) {
                              BlocProvider.of<CartBloc>(context).add(
                                AddCartItem(
                                    productId: productDetail!.id ?? 0,
                                    quantity: 1),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CartScreen(
                                    showBackButton: true,
                                    // selectedIndex: 2,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                AppColors.secondary1Color),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_basket_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                cartItem.any((e) =>
                                        e.product.id == productDetail!.id)
                                    ? "Go TO CART"
                                    : "ADD TO CART",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget titleValue(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
