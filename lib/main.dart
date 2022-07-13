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
import 'package:the_war_of_space/panel/panel_live.dart';
import 'package:the_war_of_space/panel/panel_score.dart';
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
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const GameView()),
      ),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: GameWidget(
                game: Game(gameStatusBloc: context.read<GameStatusBloc>()))),
        SafeArea(
            child: Stack(
          children: [
            const Positioned(top: 4, right: 4, child: ScorePanel()),
            Positioned(
              bottom: 4,
              right: 4,
              left: 0,
              child: Row(
                children: [
                  Expanded(child: Container()),
                  const Expanded(child: LivePanel()),
                ],
              ),
            )
          ],
        ))
      ],
    );
  }
}

class Game extends FlameGame with HasDraggables, HasCollisionDetection {
  final GameStatusBloc gameStatusBloc;

  Game({required this.gameStatusBloc});

  late Player player;

  @override
  Future<void> onLoad() async {
    final ParallaxComponent parallax =
        await loadParallaxComponent([ParallaxImageData('background.png')]);
    add(parallax);

    await add(FlameMultiBlocProvider(providers: [
      FlameBlocProvider<GameStatusBloc, GameStatusState>.value(
          value: gameStatusBloc)
    ], children: [
      player = Player(
          initPosition: Vector2((size.x - 75) / 2, size.y + 100),
          size: Vector2(75, 100)),
      EnemyCreator(),
      //  clear all on initial
      FlameBlocListener<GameStatusBloc, GameStatusState>(
          listenWhen: (pState, nState) {
        return pState.status != nState.status &&
            nState.status == GameStatus.initial;
      }, onNewState: (state) {
        children.removeWhere((element) => element is! Player);
        add(player = Player(
            initPosition: Vector2((size.x - 75) / 2, size.y + 100),
            size: Vector2(75, 100)));
      }),
    ]));
  }

  void gameStart() {
    gameStatusBloc.add(const GameStart());
  }

  void playerLoss() {
    gameStatusBloc.add(const PlayerLoss());
  }

  void enemyDestroy(int enemyType) {
    gameStatusBloc.add(EnemyDestroy(enemyType));
  }
}
