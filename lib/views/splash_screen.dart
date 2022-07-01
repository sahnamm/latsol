import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:latsol/constants/enums.dart';
import 'package:latsol/constants/r.dart';
import 'package:latsol/constants/route_name.dart';
import 'package:latsol/models/user_by_email.dart';
import 'package:latsol/respository/auth_api.dart';
import 'package:latsol/views/login_page.dart';
import 'package:latsol/views/main_page.dart';

class SplashScreen extends StatefulWidget {
  static const String route = RouteName.routeSplashScreen;
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      // final user = UserEmail.getUserEmail();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final dataUser = await AuthApi().getUserByEmail();
        if (dataUser.status == Status.success) {
          final data = UserByEmail.fromJson(dataUser.data!);
          if (data.status == 1) {
            if (!mounted) return;
            Navigator.of(context).pushReplacementNamed(MainPage.route);
          } else {
            await GoogleSignIn().signOut();
            await FirebaseAuth.instance.signOut();
            if (!mounted) return;
            Navigator.of(context).pushReplacementNamed(LoginPage.route);
          }
        }
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.primary,
      body: Center(
        child: Image.asset(
          R.assets.icSplash,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
    );
  }
}
