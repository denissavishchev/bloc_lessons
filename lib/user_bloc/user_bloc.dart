import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../counter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CounterBloc counterBloc;
  late final StreamSubscription counterBlocSubscription;

  UserBloc(this.counterBloc) : super(UserState()) {
    on<UserGetUsersEvent>(_onGetUser);
    on<UserGetUsersJobEvent>(_onGetUserJob);
    counterBlocSubscription = counterBloc.stream.listen((state) {
      if (state <= 0) {
        add(UserGetUsersEvent(0));
        add(UserGetUsersJobEvent(0));
      }
    });
  }

  @override
  Future<void> close() async {
    counterBlocSubscription.cancel();
    return super.close();
  }

  _onGetUser(UserGetUsersEvent event, Emitter<UserState> enit) async {
    enit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    final users = List.generate(event.count, (index) => User(name: 'user name', id: index.toString()));
    enit(state.copyWith(users: users));
  }

  _onGetUserJob(UserGetUsersJobEvent event, Emitter<UserState> enit) async {
    enit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    final job = List.generate(event.count, (index) => Job(name: 'job name', id: index.toString()));
    enit(state.copyWith(job: job));
  }

}