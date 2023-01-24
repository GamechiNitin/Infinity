import 'package:infinity_box/utils/imports.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.text,
    required this.onTap,
    this.margin,
  });
  final String text;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? margin;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        margin: margin ?? const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: size20,
            color: kWhiteColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
