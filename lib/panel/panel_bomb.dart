import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_war_of_space/game_status/game_status_bloc.dart';
import 'package:the_war_of_space/game_status/game_status_state.dart';

class BombPanel extends StatelessWidget {
  const BombPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameStatusBloc, GameStatusState>(
        builder: (context, state) {
      return Offstage(
        offstage: state.status != GameStatus.playing,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
                width: 45,
                height: 45,
                child: Image(image: AssetImage('assets/images/bomb/bomb.png'))),
            Text(
              ' x ${state.bombSupplyNumber}',
              style: const TextStyle(
                  color: Colors.white, fontSize: 25, fontFamily: 'Bangers'),
            )
          ],
        ),
      );
    });
  }
}
