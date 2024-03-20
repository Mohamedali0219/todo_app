import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_todo_app/components/conditional_builderScreens.dart';
import 'package:sqflite_todo_app/shared/cubit/cubit.dart';
import 'package:sqflite_todo_app/shared/cubit/state.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Appcubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = Appcubit.get(context).newTasks;
        return taskBuilder(tasks: tasks);
      },
    );
  }
}