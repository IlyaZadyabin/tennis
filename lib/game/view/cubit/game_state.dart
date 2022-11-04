part of 'game_cubit.dart';

enum GameStateStatus {
  initial,
  gameStarted,
  gameWon,
  setWon;

  bool get isInitial => this == GameStateStatus.initial;
  bool get isGameStarted => this == GameStateStatus.gameStarted;
  bool get isGameEnded => this == GameStateStatus.gameWon;
  bool get isSetEnded => this == GameStateStatus.setWon;
}

@freezed
class GameState with _$GameState {
  const factory GameState({
    @Default(GameStateStatus.initial) GameStateStatus status,
    @Default(Player()) Player player1,
    @Default(Player()) Player player2,
    @Default(Player()) Player winner,
    String? errorTextPlayer1,
    String? errorTextPlayer2,
  }) = _GameState;
}
