import 'package:flutter/material.dart';
import 'package:sample_ecommerce/constants/app_colors.dart';
import 'package:sample_ecommerce/modules/cart/presentation/screen/cart_screen.dart';
import 'package:sample_ecommerce/modules/product/presentation/screen/product_list_screen.dart';
import 'package:sample_ecommerce/utils/keys.dart';
import 'package:sample_ecommerce/utils/sp_utils.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final int cartCount;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    this.cartCount = 0,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int selectedIndex = 0;
  int cartCount = 0;
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
    cartCount = (widget.cartCount != 0
        ? widget.cartCount
        : SPUtil.getInt(KeyStrings.cartCount));
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    cartCount = (widget.cartCount != 0
        ? widget.cartCount
        : SPUtil.getInt(KeyStrings.cartCount));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.secondaryColor,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      iconSize: 28,
      currentIndex: selectedIndex,
      onTap: (value) {
        if (selectedIndex != value) {
          selectedIndex = value;
          setState(() {});
          if (selectedIndex == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductListingScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          } else if (selectedIndex == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          } else if (selectedIndex == 2) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          } else if (selectedIndex == 3) {
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const More(),),
            //       (Route<dynamic> route) => false,
            // );
          }
        }
      },
      items: [
        const BottomNavigationBarItem(
          label: 'Home',
          icon: Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Icon(Icons.home),
          ),
        ),
        BottomNavigationBarItem(
          label: 'Cart',
          icon: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Icon(Icons.shopping_cart_rounded),
              ),
              if (cartCount > 0) // Check if there are items in the cart
                Positioned(
                  right: 0,
                  left: 10,
                  top: 0,
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
