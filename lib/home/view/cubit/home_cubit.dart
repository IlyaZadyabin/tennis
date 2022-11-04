import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tennis/home/models/player.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

enum PlayerType {
  player1,
  player2,
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState()) {
    nameController1 = TextEditingController();
    nameController2 = TextEditingController();
  }

  late TextEditingController nameController1;
  late TextEditingController nameController2;

  String? _nameError(String name) {
    String? errorText;
    if (name.isEmpty) {
      errorText = "Can't be empty";
    } else if (!name.contains(' ')) {
      errorText = 'Must contain first and last name';
    } else if (name.split(' ').length > 2) {
      errorText = 'Must contain only first and last name';
    } else if (name.split(' ').length == 2) {
      final firstName = name.split(' ')[0];
      final lastName = name.split(' ')[1];

      if (firstName.length < 3) {
        errorText = 'First name must be at least 3 characters long';
      }
      if (lastName.length < 3) {
        errorText = 'Last name must be at least 3 characters long';
      }
    }
    return errorText;
  }

  void startGame() {
    final name1 = nameController1.text;
    final name2 = nameController2.text;
    final errorTextPlayer1 = _nameError(name1);
    final errorTextPlayer2 = _nameError(name2);

    if (errorTextPlayer1 != null || errorTextPlayer2 != null) {
      emit(
        state.copyWith(
          errorTextPlayer1: errorTextPlayer1,
          errorTextPlayer2: errorTextPlayer2,
        ),
      );
    } else {
      final player1 = Player(
        firstName: name1.split(' ')[0],
        lastName: name1.split(' ')[1],
      );
      final player2 = Player(
        firstName: name2.split(' ')[0],
        lastName: name2.split(' ')[1],
      );

      emit(
        state.copyWith(
          status: HomeStateStatus.gameStarted,
          player1: player1,
          player2: player2,
          errorTextPlayer1: null,
          errorTextPlayer2: null,
        ),
      );
    }
  }

  Future<void> _gameWon(
    PlayerType playerType,
    Player clickedPlayer,
    Player otherPlayer,
  ) async {
    final newClickedPlayer = clickedPlayer.copyWith(
      currentGameScore: '0',
      wonGames: clickedPlayer.wonGames + 1,
    );
    final newOtherPlayer = otherPlayer.copyWith(currentGameScore: '0');
    final player1 =
        playerType == PlayerType.player1 ? newClickedPlayer : newOtherPlayer;
    final player2 =
        playerType == PlayerType.player2 ? newClickedPlayer : newOtherPlayer;

    if (clickedPlayer.wonGames >= 6 &&
        clickedPlayer.wonGames - otherPlayer.wonGames >= 2) {
      emit(
        state.copyWith(
          status: HomeStateStatus.setWon,
          player1: player1,
          player2: player2,
        ),
      );
    } else {
      emit(
        state.copyWith(
          player1: player1,
          player2: player2,
          status: HomeStateStatus.gameWon,
        ),
      );
      await Future<Duration?>.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: HomeStateStatus.gameStarted));
    }
  }

  void clickTennis(PlayerType playerType) {
    var clickedPlayer =
        playerType == PlayerType.player1 ? state.player1 : state.player2;
    var otherPlayer =
        playerType == PlayerType.player1 ? state.player2 : state.player1;

    var isGameWon = false;
    if (clickedPlayer.currentGameScore == '0') {
      clickedPlayer = clickedPlayer.copyWith(currentGameScore: '15');
    } else if (clickedPlayer.currentGameScore == '15') {
      clickedPlayer = clickedPlayer.copyWith(currentGameScore: '30');
    } else if (clickedPlayer.currentGameScore == '30') {
      clickedPlayer = clickedPlayer.copyWith(currentGameScore: '40');
    } else if (clickedPlayer.currentGameScore == '40') {
      if (otherPlayer.currentGameScore == 'A') {
        otherPlayer = otherPlayer.copyWith(currentGameScore: '40');
      } else if (otherPlayer.currentGameScore == '40') {
        clickedPlayer = clickedPlayer.copyWith(currentGameScore: 'A');
      } else {
        isGameWon = true;
        _gameWon(playerType, clickedPlayer, otherPlayer);
      }
    } else if (clickedPlayer.currentGameScore == 'A') {
      isGameWon = true;
      _gameWon(playerType, clickedPlayer, otherPlayer);
    }
    if (!isGameWon) {
      final player1 =
          playerType == PlayerType.player1 ? clickedPlayer : otherPlayer;
      final player2 =
          playerType == PlayerType.player2 ? clickedPlayer : otherPlayer;
      emit(
        state.copyWith(player1: player1, player2: player2),
      );
    }
  }
}
