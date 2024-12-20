import '../domain/models/card_model.dart';

abstract class CardRepository {
  const CardRepository();

  Future<CardModel> getCardInfoWithInput(String cardNumber, String expiryDate);

  Future<String> getCardInfoWithCamera();

  Future<CardModel> getCardInfoWithNFC();
}

class CardRepositoryImpl implements CardRepository {
  const CardRepositoryImpl();
  @override
  Future<CardModel> getCardInfoWithInput(String cardNumber, String expiryDate) async {
    try {
      return CardModel(
        cardNumber: cardNumber,
        cardExpiry: expiryDate,
      );
    } catch (e) {
      throw Exception("Ma'lumotni qayta ishlashda xatolik: $e");
    }
  }

  @override
  Future<String> getCardInfoWithCamera() async {
    try {
      final recognizedText = await Future.delayed(const Duration(seconds: 2), () {
        return "1234 5678 9012 3456";
      });

      return recognizedText;
    } catch (e) {
      throw Exception("Kamera orqali karta raqamini o'qishda xatolik: $e");
    }
  }

  @override
  Future<CardModel> getCardInfoWithNFC() async {
    try {
      final nfcResult = await Future.delayed(const Duration(seconds: 2), () {
        return const CardModel(
          cardNumber: "9876 5432 1098 7654",
          cardExpiry: "08/25",
        );
      });

      return nfcResult;
    } catch (e) {
      throw Exception("NFC orqali ma'lumot olishda xatolik: $e");
    }
  }
}
