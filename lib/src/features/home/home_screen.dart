import 'package:card_input/src/core/router/app_router.dart';
import 'package:card_input/src/shared/presentation/bloc/card_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../shared/domain/models/card_model.dart';
import '../nfc/nfc_screen.dart';
import 'widgets/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _cardNumberController;
  late final TextEditingController _cardExpiryController;
  String? _expiryError;

  @override
  void initState() {
    _cardExpiryController = TextEditingController();
    _cardNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _cardExpiryController.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }

  void getFromCardModel(CardModel cardModel) {
    _cardExpiryController.text = cardModel.cardExpiry;
    _cardNumberController.text = cardModel.cardNumber;
  }

  bool _isExpiryDateValid(String expiryDate) {
    try {
      final parsedDate = DateFormat('MM/yy').parseStrict(expiryDate);
      final currentDate = DateTime.now();
      final month = parsedDate.month;
      if (month < 1 || month > 12) {
        return false;
      }
      final year = parsedDate.year;
      if (year < 2024) {
        return false;
      }
      if (year == currentDate.year && month < currentDate.month) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("Karta ma'lumotlarini kiritish"),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          width: size.width * 0.9,
                          height: size.height * 0.6,
                          child: const NFCScreen(),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(CupertinoIcons.waveform),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  fixedSize: Size(size.width * 0.7, 55),
                  backgroundColor: Colors.blue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                onPressed: () {
                  if (_isExpiryDateValid(_cardExpiryController.text)) {
                    context.pushNamed(
                      Routes.card,
                      extra: CardModel(
                        cardExpiry: _cardExpiryController.text,
                        cardNumber: _cardNumberController.text,
                      ),
                    );
                  } else {
                    setState(() {
                      _expiryError = 'Amal qilish muddati xato';
                    });
                  }
                },
                child: const Text('Kartalar ro`yxatiga qo`shish'),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                CustomTextField(
                  textEditingController: _cardNumberController,
                  hintText: 'Karta raqam',
                  prefix: CupertinoIcons.creditcard,
                  suffix: IconButton(
                    onPressed: () async {
                      final cardInfo = await context.pushNamed<CardModel>(Routes.camera);
                      if (cardInfo != null) {
                        getFromCardModel(cardInfo);
                      }
                    },
                    icon: const Icon(CupertinoIcons.camera),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  textEditingController: _cardExpiryController,
                  hintText: 'Amal qilish mudati',
                  prefix: CupertinoIcons.calendar,
                  maskPattern: '##/##',
                  maxLength: 5,
                  errorText: _expiryError,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
