import 'package:infinity_box/utils/imports.dart';

class AddToCartButtonWidget extends StatelessWidget {
  const AddToCartButtonWidget({
    super.key,
    required this.price,
    required this.onTap,
    required this.isAddedToCart,
  });
  final String price;
  final VoidCallback onTap;
  final bool isAddedToCart ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
        decoration: BoxDecoration(
          // color: kPrimaryColor,
          borderRadius: BorderRadius.circular(300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  color: kLightSecondaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(300),
                    bottomLeft: Radius.circular(300),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.currency_rupee,
                      size: 20,
                      color: kBlackColor,
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 20,
                        color: kBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration:  BoxDecoration(
                  color:isAddedToCart ?kDeepOrangeColor:
 kPrimaryColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(300),
                    bottomRight: Radius.circular(300),
                  ),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 20,
                    color: kWhiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
