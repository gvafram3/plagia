import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:plagia_oc/providers/auth_provider.dart';
import 'package:plagia_oc/screens/welcome_screen.dart';

import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'utils/routes.dart';
import 'utils/usermodel.dart';
// import 'theme_notifier.dart';
// import 'package:plag_app/screens/home.dart';
// import 'package:plag_app/screens/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ThemeNotifier = ref.watch(themeNotifierProvider);
    UserModel? userModel;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Montserrat",
        useMaterial3: true,
      ),
      // theme: ThemeNotifier.currentTheme,
      home: ref.watch(userDetailsProvider).when(
            data: (data) {
              userModel = data;
              return WelcomeScreen(
                user: data,
              );
            },
            error: (error, stackTrace) => const LoginPage(),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      onGenerateRoute: (settings) => onGenerateRoute(settings, userModel),
    );
  }
}
