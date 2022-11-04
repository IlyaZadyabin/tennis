import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';

@freezed
class Player with _$Player {
  const factory Player({
    @Default('') String name,
    @Default(0) int wonGames,
    @Default('0') String currentGameScore,
  }) = _Player;
}
