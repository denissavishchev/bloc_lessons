import 'package:bloc_lessons/user_bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_bloc.dart';

class BlocScreen extends StatelessWidget {
  const BlocScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterBloc = CounterBloc(0)..add(CounterIncEvent());
    final userBloc = UserBloc(counterBloc);
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(
            create: (context) => counterBloc,),
        BlocProvider<UserBloc>(
            create: (context) => userBloc,)
      ],
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<UserBloc, UserState>(
                bloc: userBloc,
                builder: (context, state) {
                  final users = state.users;
                  final job = state.job;
                  return Column(
                    children: [
                      if (state.isLoading)
                        const CircularProgressIndicator(),
                      if (users.isNotEmpty)
                        ...users.map((e) => Text(e.name)),
                      if (job.isNotEmpty)
                        ...job.map((e) => Text(e.name)),
                    ],
                  );
                },
              ),
              BlocBuilder<CounterBloc, int>(
                bloc: counterBloc,
                builder: (context, state) {
                  return Text(state.toString());
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      counterBloc.add(CounterIncEvent());
                    },
                    icon: const Icon(Icons.add_circle),
                  ),
                  IconButton(
                    onPressed: () {
                      counterBloc.add(CounterDecEvent());
                    },
                    icon: const Icon(Icons.remove_circle),
                  ),
                  IconButton(
                    onPressed: () {
                      userBloc.add(UserGetUsersEvent(counterBloc.state));
                    },
                    icon: const Icon(Icons.person),
                  ),
                  IconButton(
                    onPressed: () {
                      userBloc.add(UserGetUsersJobEvent(counterBloc.state));
                    },
                    icon: const Icon(Icons.work),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
