import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:the_war_of_space/enemy.dart';
import 'package:the_war_of_space/player.dart';

void main() {
  runApp(GameWidget(game: Game()));
}

class Game extends FlameGame with HasDraggables {
  @override
  Future<void> onLoad() async {
    final ParallaxComponent parallax = await loadParallaxComponent(
        [ParallaxImageData('background.png')]);
    add(parallax);

    final player = Player(
        initPosition: Vector2(size.x / 2, size.y * 0.75),
        size: Vector2(75, 100));
    add(player);

    final enemyCreator = EnemyCreator();
    add(enemyCreator);
  }
}
