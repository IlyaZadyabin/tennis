import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis/game/models/player.dart';
import 'package:tennis/game/view/cubit/game_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameCubit', () {
    test('Initial two players', () {
      expect(
        GameCubit().state.players.length,
        equals(2),
      );
    });

    blocTest<GameCubit, GameState>(
      "Test empty players' names",
      build: GameCubit.new,
      act: (cubit) => cubit.startGame(),
      expect: () => [
        isA<GameState>()
            .having(
              (state) => state.status,
              'status',
              equals(GameStateStatus.initial),
            )
            .having(
              (state) => state.errorTextPlayer2,
              'errorTextPlayer2',
              isNotEmpty,
            )
            .having(
              (state) => state.errorTextPlayer1,
              'errorTextPlayer1',
              isNotEmpty,
            )
      ],
    );

    blocTest<GameCubit, GameState>(
      'Test tennis click',
      build: GameCubit.new,
      seed: () => const GameState(
        players: [
          Player(name: 'Peter P', wonGames: 0, currentGameScore: '0'),
          Player(name: 'John L', wonGames: 0, currentGameScore: '0'),
        ],
        status: GameStateStatus.gameStarted,
      ),
      act: (cubit) => cubit.clickTennis(0),
      expect: () => [
        isA<GameState>().having(
          (state) => state.players[0].currentGameScore,
          'currentGameScore',
          equals('15'),
        )
      ],
    );
  });
}
