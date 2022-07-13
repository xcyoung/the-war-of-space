import 'package:equatable/equatable.dart';

enum GameStatus {
  initial,
  playing,
  gameOver
}

class GameStatusState extends Equatable {
  final int score;
  final int lives;
  final GameStatus status;
  final int bombSupplyNumber;

  const GameStatusState(
      {required this.score,
      required this.lives,
      required this.status,
      required this.bombSupplyNumber});

  const GameStatusState.empty()
      : this(
          score: 0,
          lives: 3,
          status: GameStatus.initial,
          bombSupplyNumber: 0,
        );

  GameStatusState copyWith({
    int? score,
    int? lives,
    GameStatus? status,
    int? bombSupplyNumber,
  }) {
    return GameStatusState(
      score: score ?? this.score,
      lives: lives ?? this.lives,
      status: status ?? this.status,
      bombSupplyNumber: bombSupplyNumber ?? this.bombSupplyNumber,
    );
  }

  @override
  List<Object?> get props => [score, lives, status, bombSupplyNumber];

  @override
  String toString() {
    return 'GameStatusState{score: $score, lives: $lives, status: $status, bombSupplyNumber: $bombSupplyNumber}';
  }
}
