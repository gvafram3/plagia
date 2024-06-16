import 'package:flutter/material.dart';
import 'package:plagia_oc/screens/login_page.dart';
import 'package:plagia_oc/screens/sign_up_page.dart';
import 'package:plagia_oc/screens/welcome_screen.dart';
import 'package:plagia_oc/utils/usermodel.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings, UserModel? userModel) {
  switch (settings.name) {
    case SignUpPage.routeName:
      return MaterialPageRoute(builder: (context) => const SignUpPage());
    case LoginPage.routeName:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case WelcomeScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => WelcomeScreen(
                user: userModel,
              ));
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: Center(
                  child: Text("This page does not exit"),
                ),
              ));
  }
}
