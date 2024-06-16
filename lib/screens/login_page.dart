import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../widgets/build_container.dart';
import '../widgets/build_light_theme_background.dart';
import '../widgets/custom_textfield.dart';
import 'sign_up_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  static const routeName = "/sign-in-screen";
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // void login() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     if (emailController.text.trim().isNotEmpty &&
  //         passwordController.text.trim().isNotEmpty) {
  //       final res = await authentication.loginUser(
  //           passwordController.text.trim(),
  //           emailController.text.trim(),
  //           context);
  //       if (res) {
  //         Navigator.pushNamed(context, WelcomeScreen.routeName);
  //       } else {
  //         showSnackBar(
  //             context: context,
  //             txt: "Something went wrong check and try again");
  //         setState(() {
  //           isLoading = false;
  //         });
  //       }
  //     }
  //     setState(() {
  //       isLoading = false;
  //     });
  //   } catch (er) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     showSnackBar(context: context, txt: er.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authProvider.notifier);
    return Stack(
      children: [
        buildLightThemeBackground(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.dark_mode_outlined),
                ),
              ),
            ],
          ),
          mainWidget: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 12),
                const Text(
                  'Log in to your account',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.orange),
                ),
                const SizedBox(height: 8),
                const Text(
                    'Welcome back! Enter your details to login to your account.'),
                const SizedBox(height: 12),

                // SizedBox(height: 12),
                CustomTextField(
                  controller: emailController,
                  isPassword: false,
                  prefixIcon: Icons.mail,
                  hintText: 'Enter your email here',
                ),
                const SizedBox(height: 12),

                // SizedBox(height: 12),
                CustomTextField(
                  controller: passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock,
                  hintText: 'Enter your password here',
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot your password?',
                      style: TextStyle(
                        color: Colors.orange,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await authNotifier.loginUser(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          context: context);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Stack(alignment: Alignment.center, children: [
                  const Divider(
                    thickness: 3,
                    color: Colors.black,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white,
                    ),
                    width: 104,
                    height: 24,
                    child: const Text(
                      'or continue',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                const SizedBox(height: 36),
                GestureDetector(
                  onTap: () {},
                  child: buildContainer(
                    'Google',
                    'assets/images/g.png',
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {},
                  child: buildContainer(
                    'Apple',
                    'assets/images/a.png',
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => const SignUpPage()),
                          ),
                        );
                      },
                      child: const Text(
                        'SignUp',
                        style: TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          context: context,
        ),
        if (isLoading)
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.grey.shade400.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 10,
              ),
            ),
          )
      ],
    );
  }
}
