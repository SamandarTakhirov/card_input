import 'package:card_input/src/shared/domain/models/card_model.dart';
import 'package:flutter/material.dart';

import 'widgets/card_details.dart';

class CardViewScreen extends StatefulWidget {
  const CardViewScreen({
    required this.extraData,
    super.key,
  });
  final CardModel extraData;
  @override
  State<CardViewScreen> createState() => _CardViewScreenState();
}

class _CardViewScreenState extends State<CardViewScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('CardViewScreen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SizedBox(
          width: size.width,
          height: size.width * 0.5,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0093E9),
                  Color(0xFF80D0C7),
                ],
                begin: Alignment.topCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.network(
                      'https://cdn140.picsart.com/271476369038211.png',
                      width: size.width * 0.15,
                    ),
                    Image.network(
                      widget.extraData.cardNumber.startsWith('9860')
                          ? 'https://static.tildacdn.com/tild3336-3961-4239-a338-666432376632/humo-logo-more.png'
                          : widget.extraData.cardNumber.startsWith('8600')
                              ? 'https://mirsleveltravel.uz/wp-content/uploads/2023/02/Uzcard_Logo_old-2048x1285-1.png'
                              : 'https://static.insales-cdn.com/files/1/3779/32927427/original/1_c5040ac174aebf56881a973118937b0d.png',
                      width: size.width * 0.2,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CardDetails(
                      mainText: 'Card Number',
                      text: widget.extraData.cardNumber,
                    ),
                    CardDetails(
                      mainText: 'THRU',
                      text: widget.extraData.cardExpiry,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
