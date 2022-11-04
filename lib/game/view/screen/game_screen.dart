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
    ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
        snackBarController;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(child: SinglePlayerPart(playerIdx: 0)),
                  SizedBox(width: 64),
                  Expanded(child: SinglePlayerPart(playerIdx: 1)),
                ],
              ),
              BlocConsumer<GameCubit, GameState>(
                listener: (context, state) {
                  if (state.status.isGameEnded || state.status.isSetEnded) {
                    snackBarController =
                        ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${state.winner.name} won the '
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
                  if (state.status.isInitial) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: ElevatedButton(
                        onPressed: context.read<GameCubit>().startGame,
                        child: const Text('Start game'),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
