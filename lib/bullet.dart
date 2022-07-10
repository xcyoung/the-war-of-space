import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart' show Paint, Colors;

class Bullet1 extends SpriteAnimationComponent with CollisionCallbacks {
  double speed = 200;

  Bullet1() : super();

  @override
  Future<void> onLoad() async {
    List<Sprite> sprites = [];
    sprites.add(await Sprite.load('bullet/bullet1.png'));
    final SpriteAnimation spriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15);
    animation = spriteAnimation;

    add(MoveEffect.to(
        Vector2(position.x, -size.y), EffectController(speed: speed),
        onComplete: () {
      removeFromParent();
    }));

    add(RectangleHitbox());
  }

  void loss() {
    removeFromParent();
  }
}

class BulletT extends PositionComponent {
  double speed = 200;
  final Paint _paint = Paint();

  BulletT() : super();

  @override
  Future<void> onLoad() async {
    add(MoveEffect.to(
        Vector2(position.x, -size.y), EffectController(speed: speed),
        onComplete: () {
      removeFromParent();
    }));

    _paint
      ..color = const Color(0xff904e13)
      ..style = PaintingStyle.fill
      ..isAntiAlias = false;

    add(RectangleHitbox());
  }

  void loss() {
    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final path = Path()
      ..moveTo(2, 0)
      ..lineTo(1, 1)
      ..lineTo(0, 2)
      ..lineTo(0, 8)
      ..lineTo(1, 9)
      ..lineTo(2, 10)
      ..lineTo(3, 9)
      ..lineTo(4, 8)
      ..lineTo(4, 2)
      ..lineTo(3, 1);

    canvas.drawPath(path, _paint);
  }
}
