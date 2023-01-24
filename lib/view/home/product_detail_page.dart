// ignore_for_file: use_build_context_synchronously
import 'package:infinity_box/utils/imports.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.productModel});
  final ProductModel productModel;
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<ProductModel> cartListData = [];
  bool isAddedToCart = false;

  @override
  void initState() {
    getCartData();

    super.initState();
  }

  Future<void> getCartData() async {
    final db = LocalDatabase();
    cartListData = await db.getCart();
    if (cartListData.any((e) => e.id == widget.productModel.id)) {
      isAddedToCart = true;
    }
    _notify();
  }

  _notify() {
    if (mounted) setState(() {});
  }

  _refresh() {
    cartListData.clear();
    isAddedToCart = false;
    getCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      extendBody: true,
      appBar: AppBar(
        elevation: kAppBarElevation,
        titleSpacing: 0,
        title: const Text('Product Detail'),
        actions: [
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CartListPage(),
                ),
              );
              _refresh();
            },
            child: Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: kWhiteColor,
                  ),
                ),
                if (cartListData.isNotEmpty)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: kErrorColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        cartListData.length.toString(),
                        style: const TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          imageCard(widget.productModel.image ?? ""),
          Expanded(
            child: detailsCard(
              name: widget.productModel.title ?? "",
              category: widget.productModel.category ?? "",
              desc: widget.productModel.description ?? "",
            ),
          ),
        ],
      ),
      bottomNavigationBar: AddToCartButtonWidget(
        isAddedToCart: isAddedToCart,
        price: widget.productModel.price.toString(),
        onTap: () async {
          if (cartListData.any((e) => e.id == widget.productModel.id)) {
            isAddedToCart = true;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You can only add one item to Cart.'),
              ),
            );
          } else {
            cartListData.add(widget.productModel);
            final db = LocalDatabase();

            bool status = await db.addToCart(cartListData);
            if (status) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product added to cart successfully.'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to added to cart.'),
                ),
              );
            }
          }
          _notify();
        },
      ),
    );
  }

  Widget imageCard(String imageUrl) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 12, bottom: 12),

      // padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kBorderRadius),
          topRight: Radius.circular(kBorderRadius),
        ),
        color: kWhiteColor,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kBorderRadius),
          topRight: Radius.circular(kBorderRadius),
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget detailsCard({
    required String name,
    required String category,
    required String desc,
  }) {
    return Container(
      color: kLightPrimaryColor,
      padding: const EdgeInsets.all(20),
      // height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: size16,
              color: kBlackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: [
                Expanded(child: categoryCard()),
                Expanded(child: ratingCard()),
              ],
            ),
          ),
          Text(
            desc,
            style: const TextStyle(
              fontSize: size14,
              color: kBlackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      color: kPrimaryColor,
      child: Text(
        widget.productModel.category ?? "",
        style: const TextStyle(
          fontSize: size14,
          color: kWhiteColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget ratingCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: kLightPrimaryColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.productModel.rating!.rate! < 2.5
                ? Icons.star_half
                : Icons.star,
            size: size16,
            color: kOrangeColor,
          ),
          const SizedBox(width: 6),
          Text(
            widget.productModel.rating!.rate!.toString(),
            style: const TextStyle(
              fontSize: size14,
              color: kBlackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            " (${widget.productModel.rating!.count!.toString()})",
            style: const TextStyle(
              fontSize: size14,
              color: kBlackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
