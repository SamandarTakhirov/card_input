part of 'card_bloc.dart';

class CardState extends Equatable {
  const CardState({
    this.cardModel,
    this.status = Status.initial,
  });
  final CardModel? cardModel;
  final Status status;

  CardState copyWith({
    CardModel? cardModel,
    Status? status,
  }) =>
      CardState(
        cardModel: cardModel ?? this.cardModel,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [
        status,
        cardModel,
      ];
}
