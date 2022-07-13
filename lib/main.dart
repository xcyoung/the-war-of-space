import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_war_of_space/component/game.dart';
import 'package:the_war_of_space/game_status/game_status_bloc.dart';
import 'package:the_war_of_space/menu/menu_reset.dart';
import 'package:the_war_of_space/panel/panel_bomb.dart';
import 'package:the_war_of_space/panel/panel_live.dart';
import 'package:the_war_of_space/panel/panel_score.dart';

void main() {
  runApp(const MaterialApp(
    home: GamePage(),
  ));
}

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<GameStatusBloc>(create: (_) => GameStatusBloc())
        ],
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const GameView()),
      ),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: GameWidget(
          game: SpaceGame(gameStatusBloc: context.read<GameStatusBloc>()),
          overlayBuilderMap: {
            'menu_reset': (_, game) {
              return ResetMenu(game: game as SpaceGame);
            }
          },
        )),
        SafeArea(
            child: Stack(
          children: [
            const Positioned(top: 4, right: 4, child: ScorePanel()),
            Positioned(
              bottom: 4,
              right: 4,
              left: 4,
              child: Row(
                children: const [
                  Expanded(child: BombPanel()),
                  Expanded(child: LivePanel()),
                ],
              ),
            )
          ],
        ))
      ],
    );
  }
}
