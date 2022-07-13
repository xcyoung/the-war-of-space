import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_war_of_space/enemy.dart';
import 'package:the_war_of_space/game_status/game_status_bloc.dart';
import 'package:the_war_of_space/game_status/game_status_event.dart';
import 'package:the_war_of_space/game_status/game_status_state.dart';
import 'package:the_war_of_space/player.dart';

void main() {
  runApp(const MaterialApp(
    home: GamePage(),
  ));
}

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<GameStatusBloc>(create: (_) => GameStatusBloc())
        ],
        child: const GameView(),
      ),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
        game: Game(gameStatusBloc: context.read<GameStatusBloc>()));
  }
}

class Game extends FlameGame with HasDraggables, HasCollisionDetection {
  final GameStatusBloc gameStatusBloc;

  Game({required this.gameStatusBloc});

  @override
  Future<void> onLoad() async {
    final ParallaxComponent parallax =
        await loadParallaxComponent([ParallaxImageData('background.png')]);
    add(parallax);

    await add(FlameMultiBlocProvider(providers: [
      FlameBlocProvider<GameStatusBloc, GameStatusState>.value(
          value: gameStatusBloc)
    ], children: [
      Player(
          initPosition: Vector2(size.x / 2, size.y * 0.75),
          size: Vector2(75, 100)),
      //  clear all on initial
      FlameBlocListener<GameStatusBloc, GameStatusState>(
          listenWhen: (pState, nState) {
        return pState.status != nState.status &&
            nState.status == GameStatus.initial;
      }, onNewState: (state) {
        children.removeWhere((element) => element is! Player);
      }),
      FlameBlocListener<GameStatusBloc, GameStatusState>(onNewState: (state) {
        print(state);
      })
    ]));

    final enemyCreator = EnemyCreator();
    add(enemyCreator);
  }

  void playerLoss() {
    gameStatusBloc.add(const PlayerLoss());
  }
}
