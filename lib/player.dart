import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:the_war_of_space/bullet.dart';

import 'enemy.dart';

class Player extends SpriteAnimationComponent with HasGameRef, Draggable, CollisionCallbacks {
  Player({required Vector2 initPosition, required Vector2 size})
      : super(position: initPosition, size: size);

  late Timer _shootingTimer;

  @override
  CollisionCallback<PositionComponent>? get onCollisionCallback =>
          (Set<Vector2> intersectionPoints, PositionComponent other) {
        if (other is Enemy1) {
          EffectController ctrl = NoiseEffectController(duration: 1, frequency: 30);
          Effect effect = MoveByEffect(Vector2(4, 0), ctrl);
          add(effect);
        }
      };

  @override
  Future<void> onLoad() async {
    List<Sprite> sprites = [];
    for (int i = 1; i <= 2; i++) {
      sprites.add(await Sprite.load('player/me$i.png'));
    }
    final spriteAnimation = SpriteAnimation.spriteList(sprites, stepTime: 0.15);
    animation = spriteAnimation;

    add(RectangleHitbox()..debugMode = true);

    _shootingTimer = Timer(0.5, onTick: _addBullet, repeat: true);
  }

  @override
  void onMount() {
    super.onMount();
    _shootingTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _shootingTimer.update(dt);
  }

  @override
  void onRemove() {
    super.onRemove();
    _shootingTimer.stop();
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
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

  void _addBullet() {
    final Bullet1 bullet1 = Bullet1();
    bullet1.size = Vector2(5, 11);
    bullet1.priority = 1;
    priority = 2;
    bullet1.position = Vector2(position.x + size.x / 2, position.y);
    gameRef.add(bullet1);
  }
}
