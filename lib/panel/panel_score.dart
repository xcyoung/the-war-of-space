import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game_status/game_status_bloc.dart';
import '../game_status/game_status_state.dart';

class ScorePanel extends StatelessWidget {
  const ScorePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameStatusBloc, GameStatusState>(
        buildWhen: (GameStatusState previousState, GameStatusState newState) {
      return previousState.status == GameStatus.playing;
    }, builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          state.score.toString(),
          style: const TextStyle(
              color: Colors.white, fontSize: 25, fontFamily: 'Bangers'),
        ),
      );
    });
  }
}
