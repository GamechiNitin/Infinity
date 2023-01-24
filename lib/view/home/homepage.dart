// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:infinity_box/utils/imports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFn = FocusNode();

  List<ProductModel> productList = [];
  List<ProductModel> rawProductList = [];
  List<ProductModel> cartListData = [];
  List<String> categoryListData = [];
  String selectedChip = '';
  bool isLoading = false;

  @override
  void initState() {
    getCategoriesListAPi();
    getCartData();
    fetchProdcutDataList();

    super.initState();
  }

  Future<void> getCartData() async {
    final db = LocalDatabase();
    cartListData = await db.getCart();
    _notify();
  }

  Future getCategoriesListAPi() async {
    final respo = ProductRepository();
    if (await Helper.checkInternet()) {
      _changeLoading(true);
      List<String>? res = await respo.getCategories();

      if (res != null && res.isNotEmpty) {
        categoryListData.addAll(res);
      }
      log("List ${categoryListData.length.toString()}");
    } else {
      Helper.toast(context: context, text: 'No Internet');
    }
    // _changeLoading(false);
  }

  Future<void> fetchProdcutDataList() async {
    if (await Helper.checkInternet()) {
      _changeLoading(true);
      final request = ProductRepository();
      List<ProductModel>? rawList = await request.fetchDataList();

      if (rawList != null && rawList.isNotEmpty) {
        productList.addAll(rawList);
        rawProductList.addAll(rawList);
      }
      _changeLoading(false);
      log("List ${productList.length.toString()}");
    } else {
      Helper.toast(context: context, text: 'No Internet');
    }
  }

  Future<void> filterApiCall() async {
    final request = ProductRepository();
    if (await Helper.checkInternet()) {
      _changeLoading(true);
      List<ProductModel>? rawList =
          await request.filterProductCategoryListApi(selectedChip);

      if (rawList != null && rawList.isNotEmpty) {
        productList.addAll(rawList);
      }
      log("Filter List ${productList.length.toString()}");
      _changeLoading(false);
    } else {
      Helper.toast(context: context, text: 'No Internet');
    }
  }

  _refresh() {
    selectedChip = '';
    searchController.clear();
    searchFn.unfocus();
    productList.clear();
    cartListData.clear();
    categoryListData.clear();
    rawProductList.clear();
    isLoading = false;
    fetchProdcutDataList();
    getCategoriesListAPi();
    getCartData();
  }

  _refreshList() {
    selectedChip = '';
    searchController.clear();
    searchFn.unfocus();
    productList.clear();
    rawProductList.clear();
    isLoading = false;
    fetchProdcutDataList();
  }

  _refreshFilter() {
    searchController.clear();
    searchFn.unfocus();
    productList.clear();
    isLoading = false;
    filterApiCall();
  }

  _clearFilter() {
    searchController.clear();
    searchFn.unfocus();
    productList.clear();
    isLoading = false;
    fetchProdcutDataList();
  }

  _changeLoading(bool loading) {
    isLoading = loading;
    _notify();
  }

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      drawer: const MyDrawerComponent(),
      appBar: AppBar(
        titleSpacing: 0,
        elevation: kAppBarElevation,
        title: SizedBox(
          height: 40,
          child: SearchWidget(
            controller: searchController,
            focusNode: searchFn,
            label: 'Search Product',
            suffixIcon: searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      selectedChip = '';
                      searchController.clear();
                      searchFn.unfocus();
                      productList.clear();
                      productList.addAll(rawProductList);
                      _notify();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: kWhiteColor,
                    ),
                  )
                : const SizedBox(),
            onSubmitted: (val) {
              autoCompleteApiCall(val);
            },
          ),
        ),
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Wrap(
                  spacing: 4.0,
                  children: categoryListData.map((String e) {
                    return FilterChip(
                      backgroundColor: kPrimaryColor,
                      selectedColor: kDeepOrangeColor,
                      label: Text(
                        e[0].toUpperCase() + e.substring(1).toLowerCase(),
                        style: const TextStyle(
                          color: kWhiteColor,
                          fontSize: 11,
                        ),
                      ),
                      selected: selectedChip == e,
                      checkmarkColor: kWhiteColor,
                      onSelected: (bool value) {
                        log(value.toString());

                        if (value == true && categoryListData.contains(e)) {
                          selectedChip = e;
                          _refreshFilter();
                        } else {
                          selectedChip = '';
                          _clearFilter();
                        }
                        _notify();
                      },
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () async {
                  _refreshList();
                },
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: productList.length,
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return ProductWidget(
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (contex) => ProductDetailPage(
                              productModel: productList[index],
                            ),
                          ),
                        );
                        _refresh();
                      },
                      onCartTap: () async {
                        if (cartListData
                            .any((e) => e.id == productList[index].id)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('You can only add one item to Cart.'),
                            ),
                          );
                        } else {
                          cartListData.add(productList[index]);
                          final db = LocalDatabase();

                          bool status = await db.addToCart(cartListData);
                          if (status) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Product added to cart successfully.'),
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
                      imageUrl: productList[index].image ?? "",
                      name: productList[index].title ?? "",
                      category: productList[index].category ?? "",
                      price: productList[index].price.toString(),
                      added: cartListData
                          .any((e) => e.id == productList[index].id),
                      rating: productList[index].rating?.rate.toString() ?? "",
                    );
                  },
                ),
              )),
            ],
          ),
          if (isLoading) const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }

  autoCompleteApiCall(String value) {
    _changeLoading(true);
    if (value != '') {
      productList.clear();
      log(value);
      for (var element in rawProductList) {
        if ((element.title != null &&
                    (element.title!.toLowerCase().contains(value)) ||
                (element.title!.contains(value))) ||
            (element.description != null &&
                    (element.description!.toLowerCase().contains(value)) ||
                (element.description!.toLowerCase().contains(value)))) {
          log("------${element.title}");

          productList.add(element);
        }
      }
    }
    _changeLoading(false);
  }
}
