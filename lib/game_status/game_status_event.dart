import 'package:equatable/equatable.dart';

abstract class GameStatusEvent extends Equatable {
  const GameStatusEvent();
}

class GameReset extends GameStatusEvent {
  const GameReset();

  @override
  List<Object?> get props => [];
}

class PlayerLoss extends GameStatusEvent {
  const PlayerLoss();

  @override
  List<Object?> get props => [];
}