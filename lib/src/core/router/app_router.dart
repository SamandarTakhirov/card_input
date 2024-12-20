import 'package:card_input/src/features/camera/camera_screen.dart';
import 'package:card_input/src/features/home/home_screen.dart';
import 'package:card_input/src/features/nfc/nfc_screen.dart';
import 'package:card_input/src/features/view_card/card_view_screen.dart';
import 'package:card_input/src/shared/data/card_repository.dart';
import 'package:card_input/src/shared/domain/models/card_model.dart';
import 'package:card_input/src/shared/presentation/bloc/card_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'router_name.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      name: Routes.home,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, __) => BlocProvider<CardBloc>(
        create: (_) => CardBloc(cardRepository: const CardRepositoryImpl()),
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: Routes.card,
      name: Routes.card,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => CardViewScreen(
        extraData: state.extra as CardModel,
      ),
    ),
    GoRoute(
      path: Routes.camera,
      name: Routes.camera,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, __) => const CameraScreen(),
    ),
    GoRoute(
      path: Routes.nfc,
      name: Routes.nfc,
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, __) => const NFCScreen(),
    ),
  ],
);
