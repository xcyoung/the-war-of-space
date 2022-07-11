import 'dart:math';

import 'package:flame/components.dart';
import 'package:the_war_of_space/player.dart';
import 'package:the_war_of_space/supply.dart';

import 'bullet.dart';
import 'enemy.dart';

class ComponentManager extends PositionComponent with HasGameRef {
  late Timer _enemyCreateTimer;
  late Timer _supplyCreateTimer;
  late Timer _bulletCreateTimer;

  final Random _random = Random();
  late Player _player;

  final enemyAttrMapping = {
    1: EnemyAttr(size: Vector2(45, 45), life: 1, speed: 50.0),
    2: EnemyAttr(size: Vector2(50, 60), life: 2, speed: 30.0),
    3: EnemyAttr(size: Vector2(100, 150), life: 4, speed: 20.0)
  };

  @override
  Future<void> onLoad() async {
    _player = Player(
        initPosition: Vector2(gameRef.size.x / 2, gameRef.size.y * 0.75),
        size: Vector2(75, 100));
    add(_player);

    _enemyCreateTimer =
        Timer(1, onTick: _createEnemy, repeat: true, autoStart: false);
    _supplyCreateTimer =
        Timer(10, onTick: _createSupply, repeat: true, autoStart: false);
    _bulletCreateTimer =
        Timer(0.5, onTick: _createBullet, repeat: true, autoStart: false);
  }

  @override
  void onMount() {
    super.onMount();
    _enemyCreateTimer.start();
    _supplyCreateTimer.start();
    _bulletCreateTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _enemyCreateTimer.update(dt);
  }

  @override
  void onRemove() {
    super.onRemove();
    _enemyCreateTimer.stop();
  }

  _createEnemy() {
    final width = gameRef.size.x;
    double x = _random.nextDouble() * width;
    final double random = _random.nextDouble();

    final EnemyAttr attr;
    final Enemy enemy;
    if (random < 0.5) {
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

  _createSupply() {
    final width = gameRef.size.x;
    double x = _random.nextDouble() * width;
    final double random = _random.nextDouble();

    if (random <= 0.8) {
      final size = Vector2(60, 75);
      if (width - x < size.x / 2) {
        x = width - size.x / 2;
      } else if (x < size.x / 2) {
        x = size.x / 2;
      }
      final supply = BulletSupply(position: Vector2(x, -size.y), size: size);
      add(supply);
    }
  }

  _createBullet() {
    final position = _player.position;
    final size = _player.size;
    if (_player.bulletType == 2) {
      final Bullet2 bullet2 = Bullet2(speed: 400, attack: 2);
      bullet2.priority = 1;
      bullet2.position = Vector2(position.x + size.x / 2 - 10, position.y + 10);

      final Bullet2 bullet2a = Bullet2(speed: 400, attack: 2);
      bullet2a.priority = 1;
      bullet2a.position =
          Vector2(position.x + size.x / 2 + 10, position.y + 10);

      gameRef.add(bullet2);
      gameRef.add(bullet2a);
    } else {
      final Bullet1 bullet1 = Bullet1(speed: 200, attack: 1);
      bullet1.priority = 1;
      bullet1.position = Vector2(position.x + size.x / 2, position.y);
      gameRef.add(bullet1);
    }
  }
}
