import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:the_war_of_space/player.dart';

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

class BulletSupply extends SpriteComponent with HasGameRef, CollisionCallbacks {
  BulletSupply({position, size})
      : super(position: position, size: size, anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bullet/bullet_supply.png');
    anchor = Anchor.topCenter;

    add(MoveEffect.to(
        Vector2(position.x, gameRef.size.y), EffectController(speed: 40.0),
        onComplete: () {
      removeFromParent();
    }));

    add(RotateEffect.by(15 / 180 * pi,
        EffectController(duration: 2, reverseDuration: 2, infinite: true)));

    add(RectangleHitbox()..debugMode = true);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      other.upgradeBullet();
      removeFromParent();
    }
  }
}
