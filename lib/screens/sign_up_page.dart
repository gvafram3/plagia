import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../widgets/build_container.dart';
import '../widgets/build_light_theme_background.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/snackbar.dart';
import 'login_page.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});
  static const routeName = "/sign-up-screen";
  @override
  ConsumerState<SignUpPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<SignUpPage> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void signUp() async {
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        nameController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim().isNotEmpty &&
        (passwordController.text.trim() ==
            confirmPasswordController.text.trim())) {
      try {
        setState(() {
          isLoading = true;
        });
        final authNotifier = ref.watch(authProvider.notifier);
        await authNotifier.signUp(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            context: context);

        showSnackBar(
            context: context,
            txt: 'Successful sign up \n login with the same credentials');
        emailController.text = "";
        passwordController.text = "";
        nameController.text = "";
        confirmPasswordController.text = "";
        setState(() {});
        Navigator.pushNamed(context, LoginPage.routeName);

        setState(() {
          isLoading = false;
        });
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context: context, txt: err.toString());
      }
    } else {
      showSnackBar(
          context: context,
          txt: "Something went wrong check your credentials well");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildLightThemeBackground(
          context: context,
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
            padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create an account',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.orange),
                ),
                const SizedBox(height: 8),
                const Text(
                    'Welcome! Enter your details to create a free account today.'),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: nameController,
                  isPassword: false,
                  prefixIcon: Icons.person_outline_outlined,
                  hintText: 'Enter your name here',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: emailController,
                  isPassword: false,
                  prefixIcon: Icons.mail,
                  hintText: 'Enter your email here',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock,
                  hintText: 'Enter your password here',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: confirmPasswordController,
                  isPassword: true,
                  prefixIcon: Icons.lock,
                  hintText: 'Confirm your password',
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: signUp,
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Stack(alignment: Alignment.center, children: [
                  const Divider(
                    thickness: 3,
                    color: Colors.black,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
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
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {},
                  child: buildContainer(
                    'Google',
                    'assets/images/g.png',
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: buildContainer(
                    'Apple',
                    'assets/images/a.png',
                  ),
                ),
              ],
            ),
          ),
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
