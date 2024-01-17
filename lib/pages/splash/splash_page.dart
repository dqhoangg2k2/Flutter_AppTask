import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_api_adv/gen/assets.gen.dart';
import 'package:task_api_adv/pages/main_page.dart';
import 'package:task_api_adv/pages/onboading/onboading_page.dart';
import 'package:task_api_adv/resources/app_color.dart';
import 'package:task_api_adv/services/local/shared_prefs.dart';
//remote (api từ xa )
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkToken();   // kiểm tra token có chưa , nếu có vào thẳng trang home , ko thì vô trang login 
  }

  void _checkToken() {  // chờ cho thấy chạy simer
    Timer(const Duration(milliseconds: 2600), () {
      if (SharedPrefs.isAccessed) {  
        if (SharedPrefs.isLogin) {  // nếu có thì vào trang home (MainPage)  // nếu có token thì vào thẳng trang main 
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainPage(title: 'Tasks'),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              // nếu không có thì vào trang login (LoginPage)
              builder: (context) => const OnboardingPage(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const OnboardingPage(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.images.todoIcon.path,
              width: 112.0,
              fit: BoxFit.cover,
            ),
            Shimmer.fromColors(
              baseColor: Colors.red,
              highlightColor: Colors.yellow,
              child: const Text(
                'Flutter Todos',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
