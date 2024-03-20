import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_todo_app/components/conditional_builderScreens.dart';
import 'package:sqflite_todo_app/shared/cubit/cubit.dart';
import 'package:sqflite_todo_app/shared/cubit/state.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Appcubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = Appcubit.get(context).doneTasks;
        return taskBuilder(tasks: tasks);
      },
    );
  }
}
