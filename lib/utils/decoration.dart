import 'package:infinity_box/utils/imports.dart';

InputBorder kSearchInputBorder = const OutlineInputBorder(
  borderSide: BorderSide(
    color: kWhiteColor,
    width: 1.5,
  ),
);
InputBorder kInputBorder = const OutlineInputBorder(
  borderSide: BorderSide(
    color: kPrimaryColor,
    width: 1.5,
  ),
);
InputBorder kErrorInputBorder = const OutlineInputBorder(
  borderSide: BorderSide(
    color: kErrorColor,
    width: 1.5,
  ),
);

List<BoxShadow> kNeuShadow = [
  const BoxShadow(
    color: Color(0xFFBEBEBE),
    offset: Offset(10, 10),
    blurRadius: 30,
    spreadRadius: 1,
  ),
  const BoxShadow(
    color: kWhiteColor,
    offset: Offset(-10, -10),
    blurRadius: 30,
    spreadRadius: 1,
  ),
];
