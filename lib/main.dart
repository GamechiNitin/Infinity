import 'package:infinity_box/utils/imports.dart';
import 'package:infinity_box/view/splash_page.dart';
import 'package:infinity_box/view/widget/scroll_widget.dart';

void main() {
  runApp(const MyApp());
}

FocusNode fn = FocusNode();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'Infinity Box',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: kPrimaryColor,
        ),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: ScrollWidget(),
            child: child!,
          );
        },
        home: const SplashPage(),
      ),
    );
  }
}
