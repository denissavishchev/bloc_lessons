import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc(int initialState) : super(0) {
    on<CounterIncEvent>(_onIncrement);
    on<CounterDecEvent>(_onDecrement);
  }
  _onIncrement(CounterIncEvent event, Emitter<int> enit) {
    enit(state + 1);
  }
  _onDecrement(CounterDecEvent event, Emitter<int> enit) {
    if (state <= 0) return;
    enit(state - 1);
  }
}

abstract class CounterEvent {}
class CounterIncEvent extends CounterEvent{}
class CounterDecEvent extends CounterEvent{}