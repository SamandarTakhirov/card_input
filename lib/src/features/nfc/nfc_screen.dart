import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NFCScreen extends StatefulWidget {
  const NFCScreen({super.key});

  @override
  State<NFCScreen> createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
  String _nfcData = "NFC ma'lumotini o'qing...";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startNFC();
  }

  @override
  void dispose() {
    FlutterNfcKit.finish();
    super.dispose();
  }

  Future<void> _checkNfcPermissions() async {
    try {
      NFCAvailability availability = await FlutterNfcKit.nfcAvailability;
      if (availability == NFCAvailability.available) {
        print("NFC tizimi mavjud va yoqilgan.");
      } else {
        print("NFC tizimi mavjud emas yoki o'chirilgan.");
      }
    } catch (e) {
      print("NFC ruxsatlarini tekshirishda xato: $e");
    }
  }

  Future<void> _startNFC() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _checkNfcPermissions();
      await _readCardData();
    } catch (e) {
      setState(() {
        _nfcData = "Xatolik yuz berdi qayta ishga tushiring\n";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _readCardData() async {
    try {
      NFCTag tag = await FlutterNfcKit.poll();
      print('==============================${tag.toJson()}==============================');
      String cardInfo = '''
      NFC Karta Ma'lumotlari:
      - ID: ${tag.id}
      - Standart: ${tag.standard}
      - Turi: ${tag.type}
      ''';

      if (tag.standard == "ISO 14443-4 (Type A)") {
        try {
          // final a = await FlutterNfcKit.transceive('00A4040007A0000000041010');
          // print(a);
          final panResponse = await FlutterNfcKit.transceive(tag.historicalBytes) ?? '';
          print(panResponse);

          final pan = _parsePAN(panResponse);
          final expirationDate = _parseExpirationDate(panResponse);

          print(pan);
          print(expirationDate);

          cardInfo += '''
          Karta ma'lumotlari o'qildi:
          - Karta raqami: ${pan ?? "Ma'lumot topilmadi"}
          - Amal qilish muddati: ${expirationDate ?? "Ma'lumot topilmadi"}
          ''';
        } catch (e) {
          cardInfo += "\nEMV formatidagi karta, lekin ma'lumotlar bank tomonidan himoyalangan";
        }
      } else {
        cardInfo += "\nBu karta EMV formatiga mos emas.";
      }

      setState(() {
        _nfcData = cardInfo;
      });
    } catch (e) {
      setState(() {
        _nfcData = "Xato yuz berdi qayta ishga tushiring";
      });
    } finally {
      await FlutterNfcKit.finish();
    }
  }

  String? _parsePAN(String response) {
    final panMatch = RegExp(r'(\d{12,19})').firstMatch(response);
    return panMatch?.group(0);
  }

  String? _parseExpirationDate(String response) {
    final dateMatch = RegExp(r'(\d{4})').firstMatch(response);
    if (dateMatch != null) {
      final year = '20${dateMatch.group(0)!.substring(0, 2)}';
      final month = dateMatch.group(0)!.substring(2, 4);
      return '$month/$year';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Text(
                  _nfcData,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(
                  fixedSize: Size(size.width * 0.7, 55),
                  backgroundColor: Colors.blue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                onPressed: _startNFC,
                child: const Text('NFC qayta o`qish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
