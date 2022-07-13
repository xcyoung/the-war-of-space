import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:the_war_of_space/bullet.dart';
import 'package:the_war_of_space/main.dart';
import 'package:the_war_of_space/player.dart';
import 'package:the_war_of_space/supply.dart';

class EnemyCreator extends PositionComponent with HasGameRef {
  late Timer _createTimer;
  final Random _random = Random();

  final enemyAttrMapping = {
    1: EnemyAttr(size: Vector2(45, 45), life: 1, speed: 50.0),
    2: EnemyAttr(size: Vector2(50, 60), life: 2, speed: 30.0),
    3: EnemyAttr(size: Vector2(100, 150), life: 4, speed: 20.0)
  };

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
    final double random = _random.nextDouble();
    if (random < 0.05) {
      final size = Vector2(60, 75);
      if (width - x < size.x / 2) {
        x = width - size.x / 2;
      } else if (x < size.x / 2) {
        x = size.x / 2;
      }
      final Supply supply;
      if (_random.nextDouble() < 0.5) {
        supply = BombSupply(position: Vector2(x, -size.y), size: size);
      } else {
        supply = BulletSupply(position: Vector2(x, -size.y), size: size);
      }
      add(supply);
      return;
    }

    final EnemyAttr attr;
    final Enemy enemy;
    if (random >= 0.05 && random < 0.5) {
      attr = enemyAttrMapping[1]!;
      if (width - x < attr.size.x) x = width - x;
      enemy = Enemy1(
          initPosition: Vector2(x, -attr.size.y),
          size: attr.size,
          life: attr.life,
          speed: attr.speed);
    } else if (random >= 0.5 && random < 0.8) {
      attr = enemyAttrMapping[2]!;
      if (width - x < attr.size.x) x = width - x;
      enemy = Enemy2(
          initPosition: Vector2(x, -attr.size.y),
          size: attr.size,
          life: attr.life,
          speed: attr.speed);
    } else {
      attr = enemyAttrMapping[3]!;
      if (width - x < attr.size.x) x = width - x;
      enemy = Enemy3(
          initPosition: Vector2(x, -attr.size.y),
          size: attr.size,
          life: attr.life,
          speed: attr.speed);
    }
    add(enemy);
  }
}

enum EnemyState {
  idle,
  hit,
  down,
}

class EnemyAttr {
  Vector2 size;
  int life;
  double speed;

  EnemyAttr({required this.size, required this.life, required this.speed});
}

abstract class Enemy extends SpriteAnimationGroupComponent<EnemyState>
    with HasGameRef<Game>, CollisionCallbacks {
  Enemy(
      {required Vector2 initPosition,
      required Vector2 size,
      required this.life,
      required this.speed})
      : super(
            position: initPosition,
            size: size,
            current: EnemyState.idle,
            removeOnFinish: {EnemyState.down: true}) {
    animations = <EnemyState, SpriteAnimation>{};
  }

  int life;
  double speed;

  set _enemyState(EnemyState state) {
    if (state == EnemyState.hit) {
      animations?[state]?.reset();
    }
    current = state;
  }

  Future<SpriteAnimation> idleSpriteAnimation();

  Future<SpriteAnimation?> hitSpriteAnimation();

  Future<SpriteAnimation> downSpriteAnimation();

  RectangleHitbox rectangleHitbox();

  int enemyType();

  @override
  Future<void> onLoad() async {
    animations?[EnemyState.idle] = await idleSpriteAnimation();
    final hit = await hitSpriteAnimation();
    hit?.onComplete = () {
      _enemyState = EnemyState.idle;
    };
    if (hit != null) animations?[EnemyState.hit] = hit;
    animations?[EnemyState.down] = await downSpriteAnimation();

    add(MoveEffect.to(
        Vector2(position.x, gameRef.size.y), EffectController(speed: speed),
        onComplete: () {
      removeFromParent();
    }));

    add(rectangleHitbox()..debugMode = true);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (current == EnemyState.down) return;
    if (other is Player || other is Bullet) {
      if (current == EnemyState.idle) {
        int harm = 0;
        if (other is Player) {
          harm = 1;
          other.loss();
        } else if (other is Bullet) {
          harm = other.attack;
          other.loss();
        }

        life -= harm;
        if (life > 0) {
          _enemyState = EnemyState.hit;
        } else {
          _enemyState = EnemyState.down;
          gameRef.enemyDestroy(enemyType());
        }
      }
    }
  }
}

class Enemy1 extends Enemy {
  Enemy1(
      {required Vector2 initPosition,
      required Vector2 size,
      required life,
      required speed})
      : super(initPosition: initPosition, size: size, life: life, speed: speed);

  @override
  Future<SpriteAnimation> idleSpriteAnimation() async {
    List<Sprite> sprites = [];
    sprites.add(await Sprite.load('enemy/enemy1.png'));
    final idleSpriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);
    return idleSpriteAnimation;
  }

  @override
  Future<SpriteAnimation> downSpriteAnimation() async {
    List<Sprite> sprites = [];
    for (int i = 1; i <= 4; i++) {
      sprites.add(await Sprite.load('enemy/enemy1_down$i.png'));
    }
    final downSpriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);
    return downSpriteAnimation;
  }

  @override
  Future<SpriteAnimation?> hitSpriteAnimation() async {
    return null;
  }

  @override
  RectangleHitbox rectangleHitbox() {
    return RectangleHitbox(
        size: Vector2(size.x * 0.8, size.y * 0.8),
        position: Vector2(size.x * 0.1, size.y * 0.1));
  }

  @override
  int enemyType() => 1;
}

class Enemy2 extends Enemy {
  Enemy2(
      {required Vector2 initPosition,
      required Vector2 size,
      required life,
      required speed})
      : super(initPosition: initPosition, size: size, life: life, speed: speed);

  @override
  Future<SpriteAnimation> downSpriteAnimation() async {
    List<Sprite> sprites = [];
    for (int i = 1; i <= 4; i++) {
      sprites.add(await Sprite.load('enemy/enemy2_down$i.png'));
    }
    final downSpriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);
    return downSpriteAnimation;
  }

  @override
  Future<SpriteAnimation?> hitSpriteAnimation() async {
    List<Sprite> sprites = [];
    sprites.add(await Sprite.load('enemy/enemy2_hit.png'));
    sprites.add(await Sprite.load('enemy/enemy2.png'));
    final idleSpriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);
    return idleSpriteAnimation;
  }

  @override
  Future<SpriteAnimation> idleSpriteAnimation() async {
    List<Sprite> sprites = [];
    sprites.add(await Sprite.load('enemy/enemy2.png'));
    final idleSpriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);
    return idleSpriteAnimation;
  }

  @override
  RectangleHitbox rectangleHitbox() {
    return RectangleHitbox(
        size: Vector2(size.x, size.y * 0.9), position: Vector2(0, 0));
  }

  @override
  int enemyType() => 2;
}

class Enemy3 extends Enemy {
  Enemy3(
      {required Vector2 initPosition,
      required Vector2 size,
      required life,
      required speed})
      : super(initPosition: initPosition, size: size, life: life, speed: speed);

  @override
  Future<SpriteAnimation> downSpriteAnimation() async {
    List<Sprite> sprites = [];
    for (int i = 1; i < 6; i++) {
      sprites.add(await Sprite.load('enemy/enemy3_down$i.png'));
    }
    final downSpriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);
    return downSpriteAnimation;
  }

  @override
  Future<SpriteAnimation?> hitSpriteAnimation() async {
    List<Sprite> sprites = [];
    sprites.add(await Sprite.load('enemy/enemy3_hit.png'));
    final spriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: false);
    return spriteAnimation;
  }

  @override
  Future<SpriteAnimation> idleSpriteAnimation() async {
    List<Sprite> sprites = [];
    sprites.add(await Sprite.load('enemy/enemy3_n1.png'));
    sprites.add(await Sprite.load('enemy/enemy3_n2.png'));
    final idleSpriteAnimation =
        SpriteAnimation.spriteList(sprites, stepTime: 0.15, loop: true);
    return idleSpriteAnimation;
  }

  @override
  RectangleHitbox rectangleHitbox() {
    return RectangleHitbox(
        size: Vector2(size.x, size.y * 0.95), position: Vector2(0, 0));
  }

  @override
  int enemyType() => 3;
}
