import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tennis/game/view/cubit/game_cubit.dart';
import 'package:tennis/game/view/screen/game_screen.dart';

import '../../helpers/helpers.dart';

class MockGameCubit extends MockCubit<GameState> implements GameCubit {}

void main() {
  group('GameScreen', () {
    late GameCubit gameCubit;
    setUp(() {
      gameCubit = GameCubit();
    });

    testWidgets('renders initial state', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: gameCubit,
          child: const GameScreen(),
        ),
      );
      expect(find.widgetWithText(ElevatedButton, 'Start game'), findsOneWidget);
    });
  });
}
