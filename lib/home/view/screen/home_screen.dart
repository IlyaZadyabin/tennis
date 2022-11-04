import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis/home/view/cubit/home_cubit.dart';
import 'package:tennis/home/view/screen/components/single_player_part.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: BlocBuilder<HomeCubit, HomeState>(
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
