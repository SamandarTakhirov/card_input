part of "app_router.dart";

sealed class Routes {
  Routes._();

  static const String initial = "/";

  static const String home = "/home";
  static const String card = "/card";
  static const String camera = "/camera";
  static const String nfc = "/nfc";
}