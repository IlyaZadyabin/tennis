import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis/game/view/cubit/game_cubit.dart';
import 'package:tennis/game/view/screen/components/single_player_part.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameCubit(),
      child: _GameScreen(),
    );
  }
}

class _GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GameCubit>();
    ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
        snackBarController;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: BlocConsumer<GameCubit, GameState>(
            listener: (context, state) {
              if (state.status.isGameEnded || state.status.isSetEnded) {
                snackBarController = ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${state.winner.fullName} won the '
                      '${state.status.isGameEnded ? 'game' : 'set'}!',
                    ),
                  ),
                );
              } else {
                snackBarController?.close();
                snackBarController = null;
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SinglePlayerPart(
                          player: state.player1,
                          nameController: cubit.nameController1,
                          errorText: state.errorTextPlayer1,
                          playerType: PlayerType.player1,
                        ),
                      ),
                      const SizedBox(width: 64),
                      Expanded(
                        child: SinglePlayerPart(
                          player: state.player2,
                          nameController: cubit.nameController2,
                          errorText: state.errorTextPlayer2,
                          playerType: PlayerType.player2,
                        ),
                      ),
                    ],
                  ),
                  if (state.status.isInitial)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: ElevatedButton(
                        onPressed: cubit.startGame,
                        child: const Text('Start game'),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
