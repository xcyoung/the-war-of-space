import 'package:flutter/material.dart';
import 'package:the_war_of_space/game.dart';

class ResetMenu extends StatelessWidget {
  const ResetMenu({Key? key, required this.game}) : super(key: key);

  final SpaceGame game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                    fontFamily: 'Bangers', fontSize: 28, color: Colors.white),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                game.gameStatusBloc.state.score.toString(),
                style: const TextStyle(
                    fontFamily: 'Bangers', fontSize: 24, color: Colors.white),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                  onPressed: () {
                    game.gameReset();
                  },
                  child: const Text(
                    'Replay',
                    style: TextStyle(
                        fontFamily: 'Bangers',
                        fontSize: 22,
                        color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
