import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_war_of_space/game_status/game_status_event.dart';
import 'package:the_war_of_space/game_status/game_status_state.dart';

class GameStatusBloc extends Bloc<GameStatusEvent, GameStatusState> {
  GameStatusBloc() : super(const GameStatusState.empty()) {
    on<GameReset>((event, emit) => emit(const GameStatusState.empty()));

    on<GameStart>((event, emit) {
      emit(state.copyWith(status: GameStatus.playing));
    });

    on<PlayerLoss>((event, emit) {
      if (state.lives > 1) {
        emit(state.copyWith(lives: state.lives - 1));
      } else {
        emit(state.copyWith(lives: 0, status: GameStatus.gameOver));
      }
    });

    on<EnemyDestroy>((event, emit) {
      emit(state.copyWith(score: state.score + event.enemyType * 100));
    });
  }
}
