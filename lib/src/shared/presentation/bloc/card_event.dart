part of 'card_bloc.dart';

sealed class CardEvent {
  const CardEvent();
}

class GetCardInfo extends CardEvent {}

class GetCardInfoWithInput extends CardEvent {
  final String cardNumber;
  final String cardExpiry;

  const GetCardInfoWithInput({
    required this.cardExpiry,
    required this.cardNumber,
  });
}

