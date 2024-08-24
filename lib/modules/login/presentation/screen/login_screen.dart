import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_ecommerce/common/custom_progress_bar.dart';
import 'package:sample_ecommerce/constants/assets_path.dart';
import 'package:sample_ecommerce/constants/styles.dart';
import 'package:sample_ecommerce/modules/login/presentation/bloc/login_bloc.dart';
import 'package:sample_ecommerce/modules/product/presentation/screen/product_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoggedInSuccessful) {
            CustomProgressBar.hide(context);
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const ProductListingScreen(),
              ),
            );
          } else if (state is FailureState) {
            CustomProgressBar.hide(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          } else if (state is LoginInitial) {
            CustomProgressBar.show(context);
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Scaffold(
              body: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 1, 135, 1),
                      Color.fromRGBO(255, 4, 113, 1),
                      Color.fromRGBO(255, 45, 58, 1),
                      Color.fromRGBO(255, 134, 1, 1),
                    ], // Define the gradient colors
                    begin: Alignment.topLeft, // Define the gradient start point
                    end: Alignment.bottomRight, // Define the gradient end point
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to ECommerce Application\n",
                      style: TextStyles.whiteMedium14
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text(
                        "Where you can buy unlimited products at low price\n",
                        style: TextStyles.whiteMedium14,
                        maxLines: 2,
                      ),
                    ),
                    showLoginWidget(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  showLoginWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          10, MediaQuery.of(context).size.height * 0.05, 10, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: showCommonLoginWidget(
                "Sign With Google", AssetPath.googleIcon, () async {
              BlocProvider.of<LoginBloc>(context).add(SignInWithGoogle());
            }),
          ),
        ],
      ),
    );
  }

  showCommonLoginWidget(String title, String image, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Image.asset(
                image,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyles.whiteMedium14.copyWith(color: Colors.black),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
