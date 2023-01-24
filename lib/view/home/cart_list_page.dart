// ignore_for_file: use_build_context_synchronously

import 'package:infinity_box/utils/imports.dart';

class CartListPage extends StatefulWidget {
  const CartListPage({
    super.key,
  });
  @override
  State<CartListPage> createState() => _CartListPageState();
}

class _CartListPageState extends State<CartListPage> {
  List<ProductModel> productData = [];
  bool isLoading = false;
  double total = 0;
  @override
  void initState() {
    super.initState();
    getCartData();
  }

  Future<void> getCartData() async {
    _changeLoading(true);
    final db = LocalDatabase();
    productData = await db.getCart();
    calculateTotal();
    _changeLoading(false);
  }

  void calculateTotal() {
    total = 0;
    if (productData.isNotEmpty) {
      for (var element in productData) {
        total = total + element.price!;
      }
    }
  }

  _changeLoading(bool loading) {
    isLoading = loading;
    _notify();
  }

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: productData.isNotEmpty ? Colors.grey[300] : kWhiteColor,
      appBar: AppBar(
        elevation: kAppBarElevation,
        titleSpacing: 0,
        title: const Text('My Cart'),
      ),
      body: Stack(
        children: [
          if (productData.isEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  iEmptyCart,
                  width: MediaQuery.of(context).size.width,
                ),
                const SizedBox(height: 40),
                const Text(
                  "Empty Cart!",
                  style: TextStyle(
                    fontSize: size24,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "You have not added any product to cart yet!",
                  style: TextStyle(
                    fontSize: size14,
                    color: kHintColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Continue Shopping",
                    style: TextStyle(
                      fontSize: size14,
                      color: kBlueColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          if (productData.isNotEmpty)
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: productData.length,
                    itemBuilder: (context, index) {
                      return itemView(index);
                    },
                  ),
                ),
                Container(
                  color: kWhiteColor,
                  height: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Total cart item : ${productData.length}",
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: size12,
                            color: kDeepOrangeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: List.generate(
                            productData.length,
                            (index) {
                              return Container(
                                color: index.isEven
                                    ? kLightPrimaryColor
                                    : Colors.white30,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${index + 1}). ",
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: size12,
                                        color: kBlackColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        productData[index].title ?? "",
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: size12,
                                          color: kBlackColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '1 x ',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: size14,
                                        color: kBlackColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          4.5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Icon(
                                            Icons.currency_rupee,
                                            size: size14,
                                            color: kPrimaryColor,
                                          ),
                                          Flexible(
                                            child: Text(
                                              productData[index]
                                                  .price
                                                  .toString(),
                                              textAlign: TextAlign.start,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: size14,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      chectOutButton(),
                    ],
                  ),
                ),
              ],
            ),
          if (isLoading) const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }

  Widget chectOutButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const OrderCompletedPage(),
          ),
          (route) => false,
        );
      },
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  color: kLightSecondaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.currency_rupee,
                      size: 20,
                      color: kBlackColor,
                    ),
                    Flexible(
                      child: Text(
                        total.toStringAsFixed(2),
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 20,
                          color: kBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
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
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                ),
                child: const Text(
                  "Pay Now",
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

  Widget itemView(int index) {
    return CartProductWidget(
      imageUrl: productData[index].image ?? "",
      name: productData[index].title ?? "",
      category: productData[index].category ?? "",
      price: productData[index].price.toString(),
      desc: productData[index].description ?? "",
      rating: productData[index].rating?.rate.toString() ?? "",
      onTap: () {},
      onRemoveTap: () async {
        List<ProductModel> list = [];
        list.addAll(productData);
        list.remove(productData[index]);
        final db = LocalDatabase();

        bool status = await db.addToCart(list);
        if (status) {
          productData.remove(productData[index]);
          calculateTotal();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product remove from cart successfully.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to remove from cart.'),
            ),
          );
        }
        _notify();
      },
    );
  }
}
