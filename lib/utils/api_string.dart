class ApiString {
  static String logInUrl = 'https://fakestoreapi.com/auth/login';
  static String productListUrl = 'https://fakestoreapi.com/products';
  static String createAccountUrl = 'https://fakestoreapi.com/users';
  static String productCategoriesUrl =
      'https://fakestoreapi.com/products/categories';
  static String filterProductCategoriesUrl(String filter) =>
      'https://fakestoreapi.com/products/category/$filter';
}
