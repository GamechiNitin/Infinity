import 'package:infinity_box/utils/imports.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    required this.suffixIcon,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final Widget suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onSubmitted: onSubmitted,
      cursorColor: kDeepOrangeColor,
      style: const TextStyle(
        fontSize: 14,
        color: kWhiteColor,
      ),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: kWhiteColor,
        ),
        prefixIcon: const Icon(
          Icons.search,
          size: 20,
          color: kWhiteColor,
        ),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.zero,
        border: kSearchInputBorder,
        enabledBorder: kSearchInputBorder,
        focusedBorder: kSearchInputBorder,
        errorBorder: kSearchInputBorder,
        disabledBorder: kSearchInputBorder,
        focusedErrorBorder: kSearchInputBorder,
      ),
    );
  }
}
