import 'package:equatable/equatable.dart';

abstract class GameStatusEvent extends Equatable {
  const GameStatusEvent();
}

class GameReset extends GameStatusEvent {
  const GameReset();

  @override
  List<Object?> get props => [];
}

class GameStart extends GameStatusEvent {
  const GameStart();

  @override
  List<Object?> get props => [];
}

class PlayerLoss extends GameStatusEvent {
  const PlayerLoss();

  @override
  List<Object?> get props => [];
}

class EnemyDestroy extends GameStatusEvent {
  EnemyDestroy(this.enemyType);

  final int enemyType;

  @override
  List<Object?> get props => [enemyType];
}

class BombSupplyAdd extends GameStatusEvent {
  const BombSupplyAdd();

  @override
  List<Object?> get props => [];
}

class BombSupplyUse extends GameStatusEvent {
  const BombSupplyUse();

  @override
  List<Object?> get props => [];
}
