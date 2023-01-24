import 'dart:async';
import 'package:infinity_box/utils/imports.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    initTimer();
  }

  initTimer() async {
    Timer(const Duration(seconds: 2), checkUser);
  }

  Future<void> checkUser() async {
    final db = LocalDatabase();
    String? res = await db.getUser();

    if (res != null) {
      gotoHomePage();
    } else {
      gotoLogInPage();
    }
  }

  gotoHomePage() {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      (route) => false,
    );
  }

  gotoLogInPage() {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LogInPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RichText(
          text: const TextSpan(
            text: 'Infinity',
            style: TextStyle(
              fontSize: 20,
              color: kBlackColor,
            ),
            children: [
              TextSpan(
                text: 'Box',
                style: TextStyle(
                  fontSize: 20,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
