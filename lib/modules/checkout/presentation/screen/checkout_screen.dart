import 'package:flutter/material.dart';
import 'package:sample_ecommerce/common/custom_text_field.dart';
import 'package:sample_ecommerce/constants/app_colors.dart';
import 'package:sample_ecommerce/modules/cart/model/cart_response.dart';
import 'package:sample_ecommerce/modules/checkout/model/shipping_address_model.dart';
import 'package:sample_ecommerce/modules/checkout/presentation/screen/order_confirmation_screen.dart';
import 'package:sample_ecommerce/utils/sp_utils.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartResponse;
  final String netTotal;
  final String gstAmount;

  const CheckoutScreen({
    super.key,
    required this.cartResponse,
    required this.netTotal,
    required this.gstAmount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController shippingAddressController =
      TextEditingController(text: "");
  final TextEditingController cityController = TextEditingController(text: "");
  final TextEditingController stateController = TextEditingController(text: "");
  final TextEditingController countryController =
      TextEditingController(text: "");
  final TextEditingController pinCodeController =
      TextEditingController(text: "");
  final TextEditingController phoneNumberController =
      TextEditingController(text: "");
  Address address = Address(
    name: "",
    shippingAddress: "",
    city: "",
    state: "",
    country: "",
    pinCode: "",
    phoneNumber: "",
  );

  @override
  void initState() {
    super.initState();
  }

  void saveAddress() {
    address = Address(
      name: nameController.text,
      shippingAddress: shippingAddressController.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      pinCode: pinCodeController.text,
      phoneNumber: phoneNumberController.text,
    );

    // Clear the form after saving
    nameController.clear();
    shippingAddressController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    pinCodeController.clear();
    phoneNumberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Place Order",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.arrowBackColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Shipping Address",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomTextField(
                      controller: nameController,
                      hintText: "Name",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomTextField(
                      controller: shippingAddressController,
                      hintText: "Shipping Address",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomTextField(
                      controller: cityController,
                      hintText: "City",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomTextField(
                      controller: stateController,
                      hintText: "State",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomTextField(
                      controller: countryController,
                      hintText: "Country",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomTextField(
                      controller: pinCodeController,
                      hintText: "Pin Code",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomTextField(
                      controller: phoneNumberController,
                      hintText: "Phone Number",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        saveAddress();
                        await SPUtil.clear();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                OrderConfirmationScreen(
                                    shippingAddress: address),
                          ),
                          ModalRoute.withName('/'),
                        );
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          AppColors.secondary1Color,
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
