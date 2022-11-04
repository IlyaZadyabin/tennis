import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tennis/game/models/player.dart';

part 'game_cubit.freezed.dart';
part 'game_state.dart';

enum PlayerType {
  player1,
  player2,
}

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState()) {
    nameController1 = TextEditingController();
    nameController2 = TextEditingController();

    nameController1.addListener(() {
      if (state.errorTextPlayer1?.isNotEmpty ?? false) {
        emit(state.copyWith(errorTextPlayer1: null));
      }
    });

    nameController2.addListener(() {
      if (state.errorTextPlayer2?.isNotEmpty ?? false) {
        emit(state.copyWith(errorTextPlayer2: null));
      }
    });
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
    final name1 = nameController1.text.trim();
    final name2 = nameController2.text.trim();
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
      emit(
        GameState(
          status: GameStateStatus.gameStarted,
          players: [Player(name: name1), Player(name: name2)],
        ),
      );
    }
  }

  Future<void> _gameWon(int playerIdx) async {
    final clickedPlayer = state.players[playerIdx];
    final otherPlayer = state.players[1 - playerIdx];
    final newClickedPlayer = clickedPlayer.copyWith(
      currentGameScore: '0',
      wonGames: clickedPlayer.wonGames + 1,
    );
    final newOtherPlayer = otherPlayer.copyWith(currentGameScore: '0');

    final updatedPlayers = [const Player(), const Player()]
      ..[playerIdx] = newClickedPlayer
      ..[1 - playerIdx] = newOtherPlayer;

    if (clickedPlayer.wonGames >= 5 &&
        clickedPlayer.wonGames - otherPlayer.wonGames >= 2) {
      emit(
        state.copyWith(
          players: updatedPlayers,
          winner: clickedPlayer,
          status: GameStateStatus.setWon,
        ),
      );
      await Future<Duration?>.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: GameStateStatus.initial));
    } else {
      emit(
        state.copyWith(
          players: updatedPlayers,
          winner: clickedPlayer,
          status: GameStateStatus.gameWon,
        ),
      );
      await Future<Duration?>.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: GameStateStatus.gameStarted));
    }
  }

  void clickTennis(int playerIdx) {
    var clickedPlayer = state.players[playerIdx];
    var otherPlayer = state.players[1 - playerIdx];

    var isGameWon = false;
    switch (clickedPlayer.currentGameScore) {
      case '0':
        clickedPlayer = clickedPlayer.copyWith(currentGameScore: '15');
        break;
      case '15':
        clickedPlayer = clickedPlayer.copyWith(currentGameScore: '30');
        break;
      case '30':
        clickedPlayer = clickedPlayer.copyWith(currentGameScore: '40');
        break;
      case '40':
        switch (otherPlayer.currentGameScore) {
          case 'A':
            otherPlayer = otherPlayer.copyWith(currentGameScore: '40');
            break;
          case '40':
            clickedPlayer = clickedPlayer.copyWith(currentGameScore: 'A');
            break;
          default:
            isGameWon = true;
            _gameWon(playerIdx);
        }
        break;
      case 'A':
        isGameWon = true;
        _gameWon(playerIdx);
    }
    if (!isGameWon) {
      emit(
        state.copyWith(
          players: [const Player(), const Player()]
            ..[playerIdx] = clickedPlayer
            ..[1 - playerIdx] = otherPlayer,
        ),
      );
    }
  }
}
