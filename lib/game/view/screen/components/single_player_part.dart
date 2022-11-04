import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis/game/models/player.dart';
import 'package:tennis/game/view/cubit/game_cubit.dart';
import 'package:tennis/gen/assets.gen.dart';

class SinglePlayerPart extends StatelessWidget {
  const SinglePlayerPart({
    super.key,
    required this.player,
    required this.nameController,
    required this.errorText,
    required this.playerType,
  });

  final Player player;
  final TextEditingController nameController;
  final String? errorText;
  final PlayerType playerType;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<GameCubit>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (bloc.state.status.isInitial)
          TextField(
            decoration: InputDecoration(
              hintText: 'Name Surname',
              errorText: errorText,
            ),
            controller: nameController,
          ),
        if (bloc.state.status.isGameStarted) ...[
          Text(
            '${player.firstName} ${player.lastName}',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 16),
          Text('Games won: ${player.wonGames}'),
          const SizedBox(height: 16),
          Text('Current score: ${player.currentGameScore}'),
          const SizedBox(height: 32),
          IconButton(
            iconSize: 64,
            onPressed: () => bloc.clickTennis(playerType),
            icon: SvgPicture.asset(Assets.icons.tennisBall.path),
          ),
        ]
      ],
    );
  }
}