part of 'home_cubit.dart';

enum HomeStateStatus {
  initial,
  gameStarted,
  gameWon,
  setWon;

  bool get isInitial => this == HomeStateStatus.initial;
  bool get isGameStarted => this == HomeStateStatus.gameStarted;
  bool get isGameEnded => this == HomeStateStatus.gameWon;
  bool get isSetEnded => this == HomeStateStatus.setWon;
}

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStateStatus.initial) HomeStateStatus status,
    @Default(Player()) Player player1,
    @Default(Player()) Player player2,
    String? errorTextPlayer1,
    String? errorTextPlayer2,
  }) = _HomeState;
}
