import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:the_war_of_space/bullet.dart';
import 'package:the_war_of_space/player.dart';

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

class Enemy1 extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  Enemy1({required Vector2 initPosition, required Vector2 size})
      : super(position: initPosition, size: size, removeOnFinish: true);

  bool get destroyed => isRemoving || playing;

  int life = 1;

  @override
  Future<void> onLoad() async {
    List<Sprite> sprites = [];
    sprites.add(await Sprite.load('enemy/enemy1.png'));
    for (int i = 1; i <= 4; i++) {
      sprites.add(await Sprite.load('enemy/enemy1_down$i.png'));
    }

    playing = false;
    final spriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);
    animation = spriteAnimation;

    add(RectangleHitbox(
        size: Vector2(size.x * 0.8, size.y * 0.8),
        position: Vector2(size.x * 0.1, size.y * 0.1))
      ..debugMode = true);
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

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (destroyed) return;
    if (other is Player) {
      other.loss();
      playing = true;
    } else if (other is Bullet1) {
      other.loss();
      playing = true;
    }
  }
}
