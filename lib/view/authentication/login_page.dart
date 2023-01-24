// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:infinity_box/utils/imports.dart';
import 'package:infinity_box/view/authentication/signup_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode userIdFn = FocusNode();
  FocusNode passwordFn = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool obscureText = true;

  _changeLoading(bool loading) {
    isLoading = loading;
    _notify();
  }

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    passwordFn.unfocus();
    userIdController.clear();
    passwordController.clear();
    userIdFn.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                gotoHomePage();
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  fontSize: size16,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'Infinity',
                        style: TextStyle(
                          fontSize: size24,
                          color: kBlackColor,
                        ),
                        children: [
                          TextSpan(
                            text: 'Box',
                            style: TextStyle(
                              fontSize: size24,
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Image.asset(
                    iLogIn,
                    // height: 80,
                    width: MediaQuery.of(context).size.width / 1.5,
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Log In',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        color: kBlackColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormWidget(
                          controller: userIdController,
                          focusNode: userIdFn,
                          label: 'Enter User Id : mor_2314',
                          prefixIcon: Icons.person,
                          validator: (val) {
                            log(val.toString());
                            if (val == null || val == '') {
                              return 'Enter the User Id';
                            }
                            return null;
                          },
                          onChanged: (val) {},
                        ),
                        const SizedBox(height: 20),
                        TextFormWidget(
                          controller: passwordController,
                          focusNode: passwordFn,
                          label: 'Enter Password : 83r5^_',
                          prefixIcon: Icons.lock,
                          suffixIcon: obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          obscureText: obscureText,
                          onSuffixIxonTap: () {
                            obscureText = !obscureText;
                            _notify();
                          },
                          validator: (val) {
                            if (val == null || val == '') {
                              return 'Enter the Password';
                            } else if (val.length < 6) {
                              return 'Enter the Six Password';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            log(val);
                            _notify();
                          },
                        ),
                        const SizedBox(height: 20),
                        ButtonWidget(
                          text: 'Log In',
                          onTap: () {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              loginApiCall();
                            }
                          },
                        ),
                        const Text(
                          'or',
                          style: TextStyle(
                            fontSize: size16,
                            color: kHintColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            gotoSignUpPage();
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                fontSize: size14,
                                color: kBlackColor,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    fontSize: size16,
                                    color: kBlueColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }

  Future<void> loginApiCall() async {
    final api = LoginRepository();

    if (await Helper.checkInternet()) {
      _changeLoading(true);
      String? token = await api.logIn(
        cred: passwordController.text.trim(),
        name: userIdController.text.trim(),
      );
      if (token != null) {
        final data = LocalDatabase();
        bool value = await data.saveUser(token);
        if (value) {
          _changeLoading(false);
          gotoHomePage();
        } else {
          _changeLoading(false);
          Helper.toast(context: context, text: 'User Login Failed');
        }
      } else {
        _changeLoading(false);
        Helper.toast(
            context: context, text: 'Server Error : User Login Failed');
      }
    } else {
      Helper.toast(context: context, text: 'No Internet');
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

  gotoSignUpPage() {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      ),
    );
  }
}
