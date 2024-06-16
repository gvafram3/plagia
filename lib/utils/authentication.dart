// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:plag_app/utils/usermodel.dart';
// import 'package:plag_app/widgets/snacbar.dart';

// class Authentication extends StateNotifier{

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestorage = FirebaseFirestore.instance;
//   static bool isLoading = false;

//   Authentication(super.state);

//   Future<UserModel> getUserDetails() async {
//     DocumentSnapshot snapshot = await _firestorage
//         .collection('users')
//         .doc(_auth.currentUser!.uid)
//         .get();

//     return UserModel.fromMap(snapshot as Map<String, dynamic>);
//   }

//   // Sign up method
//   Future<String> signUp({
//     required String name,
//     required String email,
//     required String password,
//     required BuildContext context,
//   }) async {
//     String result = 'Some error occured';

//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);

//       if (credential.user != null) {
//         UserModel user = UserModel(
//           email: email,
//           // badgeNumber: badgeNumber,
//           uid: credential.user!.uid,
//           name: name,
//         );

//         await _firestorage.collection('users').doc(credential.user!.uid).set(
//               user.toMap(),
//             );

//         await credential.user!.sendEmailVerification();
//         showSnackBar(
//             context: context,
//             txt:
//                 "Email verification sent to your email account check and verify");
//       }
//       result = 'Successful';
//       debugPrint(result);
//     } catch (err) {
//       result = err.toString();
//       // ignore: avoid_print
//       // print('Errrorrr');
//       debugPrint(err.toString());
//     }

//     return result;
//   }

//   Future<bool> loginUser (
//       String password, String email, BuildContext context) async {
//     bool result = false;
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       credential.user!.reload();

//       // debugPrint(credential.user as String?);
//       if (!credential.user!.emailVerified) {
//         showSnackBar(context: context, txt: "Please verify your email account");
//         return false;
//       }

//       if (credential.user != null && credential.user!.emailVerified) {
//         result = true;
//       } else {
//         showSnackBar(context: context, txt: "Please verify your email");
//         result = false;
//       }
//     } on FirebaseAuthException {
//       throw Exception;
//     } catch (err) {
//       result = false;

//       debugPrint(" err.toString() ${err.toString()}");
//     }

//     return result;
//   }

//   signOut() {
//     _auth.signOut();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plagia_oc/screens/welcome_screen.dart';
import 'package:plagia_oc/utils/usermodel.dart';

import '../widgets/snackbar.dart';

class Authentication extends StateNotifier<UserModel?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Authentication() : super(null);

  Future<UserModel> getUserDetails() async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

    return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  // Sign up method
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showSnackBar(context: context, txt: 'Please fill in your details');
      return;
    }
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        UserModel user = UserModel(
          email: email,
          uid: credential.user!.uid,
          name: name,
        );

        await _firestore.collection('users').doc(credential.user!.uid).set(
              user.toMap(),
            );

        await credential.user!.sendEmailVerification();
        showSnackBar(
          context: context,
          txt:
              "Email verification sent to your email account, check and verify",
        );
        state = user;
      }
    } catch (err) {
      showSnackBar(context: context, txt: err.toString());
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      showSnackBar(context: context, txt: 'Please Enter your credentials');
      return;
    }
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.reload();

      if (!credential.user!.emailVerified) {
        showSnackBar(
          context: context,
          txt: "Please verify your email account",
        );
      }

      if (credential.user != null && credential.user!.emailVerified) {
        state = await getUserDetails();
        Navigator.pushNamedAndRemoveUntil(
            context, WelcomeScreen.routeName, (T) => false);
      } else {
        showSnackBar(context: context, txt: "Please verify your email");
      }
    } on FirebaseAuthException {
      showSnackBar(context: context, txt: "Errrrrooorrororororo");
    } catch (err) {
      showSnackBar(context: context, txt: err.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = null;
  }
}
