import 'package:card_input/src/core/utils/widgets/masked_input_formatter.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.textEditingController,
    required this.prefix,
    required this.hintText,
    this.suffix,
    this.maxLength = 19,
    this.maskPattern = '#### #### #### ####',
    super.key,
    this.errorText,
  });

  final TextEditingController textEditingController;
  final int maxLength;
  final String maskPattern;
  final IconData prefix;
  final String hintText;
  final Widget? suffix;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: errorText!= null ? 80 :60,
      child: TextFormField(
        controller: textEditingController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        maxLength: maxLength,
        autofocus: false,
        obscureText: false,
        cursorColor: Colors.blue,
        inputFormatters: [MaskedInputFormatter(maskPattern: maskPattern)],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
          prefixIcon: Icon(prefix),
          suffixIcon: suffix,
          counterText: '',
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          errorText: errorText,
        ),
      ),
    );
  }
}
