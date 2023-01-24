// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:infinity_box/utils/imports.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FocusNode userIdFn = FocusNode();
  FocusNode emailFn = FocusNode();
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: kToolbarHeight + 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
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
                  const SizedBox(height: 30),
                  Image.asset(
                    iCreateAccount,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign Up',
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
                          label: 'Enter user name ',
                          prefixIcon: Icons.person,
                          validator: (val) {
                            log(val.toString());
                            if (val == null || val == '') {
                              return 'Enter the user name';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            log(val);
                            _notify();
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormWidget(
                          controller: emailController,
                          focusNode: emailFn,
                          label: 'Enter email ',
                          prefixIcon: Icons.email,
                          onChanged: (val) {
                            log(val);
                            _notify();
                          },
                          validator: (val) {
                            log(val.toString());
                            if (val == null || val == '') {
                              return 'Enter the email';
                            } else if (!val.contains('@')) {
                              return 'Enter valid the email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormWidget(
                          controller: passwordController,
                          focusNode: passwordFn,
                          label: 'Create Password',
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
                              return 'Create the Password';
                            } else if (val.length < 6) {
                              return 'Create the Six Password';
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
                          text: 'Create Account',
                          onTap: () {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              signUpApiCall();
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            // gotoHomePage();
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              text: "Read Privacy Policy and",
                              style: TextStyle(
                                fontSize: size14,
                                color: kBlueColor,
                              ),
                              children: [
                                TextSpan(
                                  text: ' Terms & Condition',
                                  style: TextStyle(
                                    fontSize: size14,
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

  Future<void> signUpApiCall() async {
    final api = LoginRepository();
    if (await Helper.checkInternet()) {
      _changeLoading(true);
      int? id = await api.createAccount(
        cred: passwordController.text.trim(),
        name: userIdController.text.trim(),
        email: emailController.text.trim(),
      );
      if (id != null) {
        _changeLoading(false);
        Helper.toast(context: context, text: 'User created successfully');
        Navigator.pop(context);
      } else {
        Helper.toast(
            context: context, text: 'Server Error : User Login Failed');
      }
      _changeLoading(false);
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
}
