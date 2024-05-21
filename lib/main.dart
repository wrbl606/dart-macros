import 'macros/macro_state.dart';
import 'macros/traceable.dart';

void main() async {
  final state = State();

  state.counter$.listen((val) => print('got $val'));

  5.times(() {
    state.bump();
  });
}

class State {
  @MacroState()
  var _counter = 0;

  @Traceable()
  void _bump() {
    counter++;
  }
}

extension on int {
  void times(void Function() task) {
    for (int i = 0; i < this; i++) {
      task();
    }
  }
}