import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

abstract class Bullet extends SpriteAnimationComponent {
  Bullet({required this.speed, required this.attack})
      : super(size: Vector2(5, 11));

  double speed;
  int attack;

  Future<SpriteAnimation> bulletAnimation();

  @override
  Future<void> onLoad() async {
    animation = await bulletAnimation();

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

class Bullet1 extends Bullet {
  Bullet1({required super.speed, required super.attack});

  @override
  Future<SpriteAnimation> bulletAnimation() async {
    List<Sprite> sprites = [];
    sprites.add(await Sprite.load('bullet/bullet1.png'));
    final SpriteAnimation spriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15);
    return spriteAnimation;
  }
}

class Bullet2 extends Bullet {
  Bullet2({required super.speed, required super.attack});

  @override
  Future<SpriteAnimation> bulletAnimation() async {
    List<Sprite> sprites = [];
    sprites.add(await Sprite.load('bullet/bullet2.png'));
    final SpriteAnimation spriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15);
    return spriteAnimation;
  }
}
