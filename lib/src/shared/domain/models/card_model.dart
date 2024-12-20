class CardModel {
  final String cardNumber;
  final String cardExpiry;

  const CardModel({
    required this.cardExpiry,
    required this.cardNumber,
  });

  String get fitchString => cardNumber + cardExpiry;
}
