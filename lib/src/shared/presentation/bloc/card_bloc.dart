import 'package:bloc/bloc.dart';
import 'package:card_input/src/shared/data/card_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../core/utils/constants/status_screen.dart';
import '../../domain/models/card_model.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  CardBloc({required this.cardRepository}) : super(const CardState()) {
    on<CardEvent>(
      (event, emit) => switch (event) {
        GetCardInfo _ => _getCardInfo(event, emit),
        GetCardInfoWithInput _ => getCardInfoWithInput(event, emit),
      },
    );
  }

  final CardRepository cardRepository;

  Future<void> _getCardInfo(
    GetCardInfo event,
    Emitter<CardState> emit,
  ) async {}

  Future<void> getCardInfoWithInput(
    GetCardInfoWithInput event,
    Emitter<CardState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    final data = await cardRepository.getCardInfoWithInput(
      event.cardNumber,
      event.cardExpiry,
    );

    emit(state.copyWith(
      cardModel: CardModel(
        cardExpiry: data.cardExpiry,
        cardNumber: data.cardNumber,
      ),
      status: Status.success,
    ));
  }
}
