import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_war_of_space/game_status/game_status_bloc.dart';
import 'package:the_war_of_space/game_status/game_status_state.dart';

class LivePanel extends StatelessWidget {
  const LivePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameStatusBloc, GameStatusState>(
        buildWhen: (GameStatusState previousState, GameStatusState newState) {
      return previousState.lives != newState.lives &&
          previousState.status == GameStatus.playing;
    }, builder: (context, state) {
      int live = state.lives;

      return Wrap(
        spacing: 2,
        runSpacing: 5,
        alignment: WrapAlignment.end,
        children: List.generate(
            live,
            (index) => Container(
                  constraints:
                      const BoxConstraints(maxWidth: 35, maxHeight: 35),
                  child: const Image(
                      image: AssetImage('assets/images/player/life.png')),
                )).toList(),
      );
    });
  }
}
