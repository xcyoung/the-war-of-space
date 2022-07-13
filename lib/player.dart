import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart' show Colors, Curves, Offset;
import 'package:the_war_of_space/bullet.dart';
import 'package:the_war_of_space/game.dart';

import 'game_status/game_status_bloc.dart';
import 'game_status/game_status_state.dart';

class Player extends SpriteAnimationGroupComponent<GameStatus>
    with HasGameRef<SpaceGame>, Draggable, CollisionCallbacks {
  Player({required Vector2 initPosition, required Vector2 size})
      : super(
            position: initPosition,
            size: size,
            current: GameStatus.playing,
            removeOnFinish: {GameStatus.gameOver: true});

  int bulletType = 1;

  late Timer _shootingTimer;
  late Timer _bulletUpgradeTimer;

  @override
  Future<void> onLoad() async {
    priority = 100;

    List<Sprite> sprites = [];
    for (int i = 1; i <= 2; i++) {
      sprites.add(await Sprite.load('player/me$i.png'));
    }
    final spriteAnimation = SpriteAnimation.spriteList(sprites, stepTime: 0.15);

    List<Sprite> destroySprites = [];
    for (int i = 1; i <= 2; i++) {
      destroySprites.add(await Sprite.load('player/me_destroy_$i.png'));
    }
    final destroySpriteAnimation =
        SpriteAnimation.spriteList(destroySprites, stepTime: 0.15, loop: false);

    animations = {
      GameStatus.playing: spriteAnimation,
      GameStatus.gameOver: destroySpriteAnimation
    };

    add(RectangleHitbox()..debugMode = true);

    _shootingTimer =
        Timer(0.5, onTick: _addBullet, repeat: true, autoStart: false);
    _bulletUpgradeTimer = Timer(5, onTick: _downgradeBullet, autoStart: false);

    add(MoveEffect.to(Vector2(position.x, gameRef.size.y * 0.75),
        EffectController(duration: 1.5, curve: Curves.easeOutSine))
      ..onComplete = () {
        gameRef.gameStart();
      });

    add(FlameBlocListener<GameStatusBloc, GameStatusState>(
        listenWhen: (pState, nState) {
      return pState.status != nState.status;
    }, onNewState: (state) {
      if (state.status == GameStatus.playing) {
        _shootingTimer.start();
      } else if (state.status == GameStatus.gameOver) {
        _shootingTimer.stop();
        if (_bulletUpgradeTimer.isRunning()) _bulletUpgradeTimer.stop();
        current = GameStatus.gameOver;
      }
    }));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _shootingTimer.update(dt);
    _bulletUpgradeTimer.update(dt);
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    if (gameRef.gameStatusBloc.state.status != GameStatus.playing) return false;
    final willToPosition = position + info.delta.global;
    double x = willToPosition.x;
    double y = willToPosition.y;

    if (x < 0) {
      x = 0;
    } else if (x > gameRef.size.x - size.x) {
      x = gameRef.size.x - size.x;
    }
    if (y < 0) {
      y = 0;
    } else if (y > gameRef.size.y - size.y) {
      y = gameRef.size.y - size.y;
    }

    position = Vector2(x, y);
    return true;
  }

  void loss() {
    removeAll(children.whereType<ColorEffect>());
    removeAll(children.whereType<MoveByEffect>());

    ColorEffect collisionColorEffect = ColorEffect(
        Colors.white,
        const Offset(0.0, 0.5),
        EffectController(duration: 0.25, reverseDuration: 0.25));
    MoveByEffect collisionNoiseEffect = MoveByEffect(
        Vector2(4, 0), NoiseEffectController(duration: 0.5, frequency: 20));

    add(collisionNoiseEffect);
    add(collisionColorEffect);

    gameRef.playerLoss();
  }

  void upgradeBullet() {
    bulletType = 2;
    add(ColorEffect(Colors.blue.shade900, const Offset(0.3, 0.0),
        EffectController(duration: 0.15)));

    _bulletUpgradeTimer.start();
  }

  void _downgradeBullet() {
    bulletType = 1;
  }

  void _addBullet() {
    if (bulletType == 2) {
      final Bullet2 bullet2 = Bullet2(speed: 400, attack: 2);
      bullet2.priority = 1;
      bullet2.position = Vector2(position.x + size.x / 2 - 10, position.y + 10);

      final Bullet2 bullet2a = Bullet2(speed: 400, attack: 2);
      bullet2a.priority = 1;
      bullet2a.position =
          Vector2(position.x + size.x / 2 + 10, position.y + 10);

      gameRef.add(bullet2);
      gameRef.add(bullet2a);
    } else {
      final Bullet1 bullet1 = Bullet1(speed: 200, attack: 1);
      bullet1.priority = 1;
      bullet1.position = Vector2(position.x + size.x / 2, position.y);
      gameRef.add(bullet1);
    }
  }
}
