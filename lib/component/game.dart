import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:the_war_of_space/component/bullet.dart';
import 'package:the_war_of_space/component/player.dart';
import 'package:the_war_of_space/component/supply.dart';

import './enemy.dart';
import '../game_status/game_status_bloc.dart';
import '../game_status/game_status_event.dart';
import '../game_status/game_status_state.dart';

class GameStatusController extends Component with HasGameRef<SpaceGame> {
  @override
  Future<void> onLoad() async {
    add(FlameBlocListener<GameStatusBloc, GameStatusState>(
        listenWhen: (pState, nState) {
      return pState.status != nState.status;
    }, onNewState: (state) {
      if (state.status == GameStatus.initial) {
        gameRef.resumeEngine();
        gameRef.overlays.remove('menu_reset');

        if (parent == null) return;
        parent!.removeAll(parent!.children.where((element) {
          return element is Enemy || element is Supply || element is Bullet;
        }));
        parent!.add(gameRef.player = Player(
            initPosition:
                Vector2((gameRef.size.x - 75) / 2, gameRef.size.y + 100),
            size: Vector2(75, 100)));
      } else if (state.status == GameStatus.gameOver) {
        Future.delayed(const Duration(milliseconds: 600)).then((value) {
          gameRef.pauseEngine();
          gameRef.overlays.add('menu_reset');
        });
      }
    }));
    add(FlameBlocListener<GameStatusBloc, GameStatusState>(
        listenWhen: (pState, nState) {
      return pState.bombSupplyNumber > nState.bombSupplyNumber;
    }, onNewState: (state) {
      if (parent == null) return;

      parent!.children.whereType<Enemy>().forEach((element) {
        element.forcedDestruction();
      });
    }));
  }
}

class SpaceGame extends FlameGame with HasDraggables, HasCollisionDetection {
  final GameStatusBloc gameStatusBloc;

  SpaceGame({required this.gameStatusBloc});

  late Player player;

  @override
  Future<void> onLoad() async {
    final ParallaxComponent parallax = await loadParallaxComponent(
        [ParallaxImageData('background.png')],
        repeat: ImageRepeat.repeatY, baseVelocity: Vector2(0, 25));
    add(parallax);

    await add(FlameMultiBlocProvider(providers: [
      FlameBlocProvider<GameStatusBloc, GameStatusState>.value(
          value: gameStatusBloc)
    ], children: [
      player = Player(
          initPosition: Vector2((size.x - 75) / 2, size.y + 100),
          size: Vector2(75, 100)),
      EnemyCreator(),
      GameStatusController(),
    ]));
  }

  void gameReset() {
    gameStatusBloc.add(const GameReset());
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

  void bombSupplyAdd() {
    gameStatusBloc.add(const BombSupplyAdd());
  }
}
