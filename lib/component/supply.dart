import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:the_war_of_space/component/player.dart';

abstract class Supply extends SpriteComponent with HasGameRef {
  Supply({position, size})
      : super(position: position, size: size, anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    add(MoveEffect.to(
        Vector2(position.x, gameRef.size.y), EffectController(speed: 40.0),
        onComplete: () {
      removeFromParent();
    }));

    add(RotateEffect.by(15 / 180 * pi,
        EffectController(duration: 2, reverseDuration: 2, infinite: true)));

    add(RectangleHitbox()..debugMode = true);
  }
}

class BulletSupply extends Supply with CollisionCallbacks {
  BulletSupply({position, size}) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bullet/bullet_supply.png');
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

class BombSupply extends Supply with CollisionCallbacks {
  BombSupply({position, size}) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bomb/bomb_supply.png');
  }
}
