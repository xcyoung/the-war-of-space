import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:the_war_of_space/enemy.dart';

class Bullet1 extends SpriteAnimationComponent with CollisionCallbacks {
  double speed = 200;

  Bullet1() : super();

  @override
  CollisionCallback<PositionComponent>? get onCollisionCallback =>
      (Set<Vector2> intersectionPoints, PositionComponent other) {
        if (other is Enemy1) {
          removeFromParent();
        }
      };

  @override
  Future<void> onLoad() async {
    List<Sprite> sprites = [];
    sprites.add(await Sprite.load('bullet/bullet1.png'));
    final SpriteAnimation spriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15);
    animation = spriteAnimation;

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    Vector2 ds = Vector2(0, -1) * speed * dt;

    position.add(ds);
    if (position.y < 0) {
      removeFromParent();
    }
  }
}
