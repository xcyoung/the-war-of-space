import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Bullet1 extends SpriteAnimationComponent with CollisionCallbacks {
  double speed = 200;
  final double maxRange;

  double _length = 0;

  Bullet1({required this.maxRange}) : super();

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
    _length += ds.length;
    position.add(ds);
    if (_length > maxRange) {
      _length = 0;
      removeFromParent();
    }
  }
}
