import 'package:infinity_box/utils/imports.dart';

class OrderCompletedPage extends StatefulWidget {
  const OrderCompletedPage({super.key});

  @override
  State<OrderCompletedPage> createState() => _OrderCompletedPageState();
}

class _OrderCompletedPageState extends State<OrderCompletedPage> {
  gotoHomePage() {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: RichText(
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
              iOrderConfirmed,
              // height: 80,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 10),
            const Text(
              "Congralutations!",
              style: TextStyle(
                fontSize: size24,
                color: kPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Order placed Successfully.",
              style: TextStyle(
                fontSize: size14,
                color: kHintColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                gotoHomePage();
              },
              child: const Text(
                "Back to home",
                style: TextStyle(
                  fontSize: size14,
                  color: kBlueColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
