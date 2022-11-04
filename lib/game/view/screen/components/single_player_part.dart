import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis/game/view/cubit/game_cubit.dart';
import 'package:tennis/gen/assets.gen.dart';

class SinglePlayerPart extends StatelessWidget {
  const SinglePlayerPart({
    super.key,
    required this.playerIdx,
  });

  final int playerIdx;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        final cubit = context.read<GameCubit>();
        final player = state.players[playerIdx];

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.status.isInitial)
              TextField(
                decoration: InputDecoration(
                  hintText: 'Name Surname',
                  errorText: playerIdx == 0
                      ? state.errorTextPlayer1
                      : state.errorTextPlayer2,
                  errorMaxLines: 3,
                ),
                controller: playerIdx == 0
                    ? cubit.nameController1
                    : cubit.nameController2,
              ),
            if (state.status.isGameStarted) ...[
              Text(
                player.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16),
              Text('Games won: ${player.wonGames}'),
              const SizedBox(height: 16),
              Text('Current score: ${player.currentGameScore}'),
              const SizedBox(height: 32),
              IconButton(
                iconSize: 64,
                onPressed: () => cubit.clickTennis(playerIdx),
                icon: SvgPicture.asset(Assets.icons.tennisBall.path),
              ),
            ]
          ],
        );
      },
    );
  }
}
