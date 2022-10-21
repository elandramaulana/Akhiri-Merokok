import 'package:akhiri_merokok/app/modules/home/navbar.dart';
import 'package:akhiri_merokok/app/modules/signup/signup_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/utils/keys.dart';
import '../models/users.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> firestoreUser = Rxn<UserModel>();

  @override
  void onReady() {
    super.onReady();

    ever(firebaseUser, handleAuthChanged);
    firebaseUser.bindStream(user);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  handleAuthChanged(firebaseUser) async {
    //get user data from firestore
    if (firebaseUser?.uid != null) {
      firestoreUser.bindStream(streamFirestoreUser());
    }

    if (firebaseUser == null) {
      if (kDebugMode) {
        print('Send to signin');
      }
      Get.offAll(() => SignupView());
    } else {
      Get.offAll(() => const Navbar());
    }
  }

  // Firebase user one-time fetch
  Future<User> get getUser async => firebaseAuth.currentUser!;

  // Firebase user a realtime stream
  Stream<User?> get user => firebaseAuth.authStateChanges();

  //Streams the firestore user from the firestore collection
  Stream<UserModel> streamFirestoreUser() {
    if (kDebugMode) {
      print('streamFirestoreUser()');
    }

    return firebaseFirestore
        .doc('/users/${firebaseUser.value!.uid}')
        .snapshots()
        .map((snapshot) => UserModel.fromMap(snapshot.data()!));
  }

  //get the firestore user from the firestore collection
  Future<UserModel> getFirestoreUser() {
    return firebaseFirestore
        .doc('/users/${firebaseUser.value!.uid}')
        .get()
        .then(
            (documentSnapshot) => UserModel.fromMap(documentSnapshot.data()!));
  }

  //Method to handle user sign in using email and password
  signInWithEmailAndPassword(BuildContext context) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // if (userCredential.user!.emailVerified) {
      //
      // }
      emailController.clear();
      passwordController.clear();
    } catch (error) {
      if (kDebugMode) {
        print("Signin error");
      }
    }
  }

  // User registration using email and password
  registerWithEmailAndPassword(BuildContext context) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((result) async {
        if (kDebugMode) {
          print('uID: ${result.user!.uid}');
        }
        if (kDebugMode) {
          print('email: ${result.user!.email}');
        }
        //create the new user object
        UserModel newUser = UserModel(
          uid: result.user!.uid,
          email: result.user!.email!,
          timestamp: DateTime.now().toString(),
        );
        //create the user in firestore
        createUserFirestore(newUser, result.user!);
        emailController.clear();
        passwordController.clear();
      });
    } on FirebaseAuthException {
      if (kDebugMode) {
        print("Signup error");
      }
    }
  }

  //create the firestore user in users collection
  void createUserFirestore(UserModel user, User firebaseUser) {
    firebaseFirestore.doc('/users/${firebaseUser.uid}').set(user.toJson());
    update();
  }

  //password reset email
  Future<void> sendPasswordResetEmail(BuildContext context) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: emailController.text);
    } on FirebaseAuthException {
      if (kDebugMode) {
        print("error");
      }
    }
  }

  // // Confirm the link is a sign-in with email link.
  // Future<void> signInWithEmailLink(BuildContext context) async {
  //   if (firebaseAuth.isSignInWithEmailLink(emailLink)) {
  //     try {
  //       // The client SDK will parse the code from the link for you.
  //       final userCredential = await firebaseAuth.signInWithEmailLink(
  //           email: emailAuth, emailLink: emailLink);
  //
  //       // You can access the new user via userCredential.user.
  //       final emailAddress = userCredential.user?.email;
  //
  //       print('Successfully signed in with email link!');
  //     } catch (error) {
  //       print('Error signing in with email link.');
  //     }
  //   }
  // }

  void signOut() async {
    // await firebaseAuth.signOut();
    emailController.clear();
    passwordController.clear();
    return firebaseAuth.signOut();
  }
}
