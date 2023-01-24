// ignore_for_file: use_build_context_synchronously

import 'package:infinity_box/utils/imports.dart';

class MyDrawerComponent extends StatelessWidget {
  const MyDrawerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Nitin Gamechi'),
              accountEmail: const Text('nitingamechi@gmail.com'),
              currentAccountPicture: Container(
                height: 60,
                width: 60,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: kWhiteColor,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  'NG',
                  style: TextStyle(
                    fontSize: size24,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                Navigator.pop(context);
              },
              title: const Text('Home'),
              leading: const Icon(
                Icons.home,
                color: kPrimaryColor,
              ),
              horizontalTitleGap: 0,
            ),
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CartListPage(),
                  ),
                );
              },
              title: const Text('Cart'),
              leading: const Icon(
                Icons.shopping_bag_sharp,
                color: kPrimaryColor,
              ),
              horizontalTitleGap: 0,
            ),
            ListTile(
              hoverColor: kLightSecondaryColor,
              onTap: () async {
                Navigator.pop(context);
                DialogBoxx.logOutDialog(context);
              },
              title: const Text('Log out'),
              trailing: const Icon(
                Icons.logout,
              ),
            )
          ],
        ),
      ),
    );
  }
}
