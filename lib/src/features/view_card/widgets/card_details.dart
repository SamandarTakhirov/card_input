import 'package:card_input/src/core/utils/constants/context_utils.dart';
import 'package:flutter/material.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({
    required this.mainText,
    required this.text,
    super.key,
  });

  final String mainText;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mainText,
          style: context.textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        Text(
         text.trim(),
          style: context.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
