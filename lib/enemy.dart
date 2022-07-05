import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class EnemyCreator extends PositionComponent with HasGameRef {
  late Timer _createTimer;
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    _createTimer = Timer(1, onTick: _createEnemy, repeat: true);
  }

  @override
  void onMount() {
    super.onMount();
    _createTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _createTimer.update(dt);
  }

  @override
  void onRemove() {
    super.onRemove();
    _createTimer.stop();
  }

  void _createEnemy() {
    final width = gameRef.size.x;
    double x = _random.nextDouble() * width;
    final Vector2 size = Vector2(50, 50);
    if (width - x < 50) {
      x = width - 50;
    }
    final enemy1 = Enemy1(initPosition: Vector2(x, -size.y), size: size);
    add(enemy1);
  }
}

class Enemy1 extends SpriteAnimationComponent with HasGameRef {
  Enemy1({required Vector2 initPosition, required Vector2 size})
      : super(position: initPosition, size: size);

  int life = 1;

  @override
  Future<void> onLoad() async {
    List<Sprite> sprites = [];
    sprites.add(await Sprite.load('enemy/enemy1.png'));
    final spriteAnimation = SpriteAnimation.spriteList(sprites, stepTime: 0.15);
    animation = spriteAnimation;

    add(RectangleHitbox()..debugMode = true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    Vector2 ds = Vector2(0, 1) * 100 * dt;
    position.add(ds);
    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }
}
