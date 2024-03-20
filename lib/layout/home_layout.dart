import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_todo_app/components/defult_form_field.dart';
import 'package:sqflite_todo_app/shared/cubit/cubit.dart';
import 'package:sqflite_todo_app/shared/cubit/state.dart';

// 1. create Database
// 2. create tables
// 3. open database
// 4. insert to database
// 5. get from database
// 6.update in database
// 7.delete from database

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var scafoldKey = GlobalKey<ScaffoldState>();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var titelController = TextEditingController();

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Appcubit()..createDatabase(),
      child: BlocConsumer<Appcubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          Appcubit cubit = Appcubit.get(context); // on the bulider
          return Scaffold(
            key: scafoldKey,
            appBar: AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.deepPurple,
              title: Text(cubit.titels[cubit.currentIndex]),
            ),
            // if togle with 2 Screen play with true & false
            // if togle with 3 and more play with list
            body: ConditionalBuilder(
              condition: state is! AppGetLoadingDatabaseState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertIntoDatabase(
                        title: titelController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scafoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.grey[100],
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                deflutTextFormField(
                                  controller: titelController,
                                  type: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'titel must not be empty';
                                    }
                                    return null;
                                  },
                                  hint: 'task titel',
                                  prefix: Icons.title,
                                  prefixIconSize: 25,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                deflutTextFormField(
                                  controller: timeController,
                                  type: TextInputType.text,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then(
                                      (value) => timeController.text =
                                          value!.format(context).toString(),
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  hint: 'time task',
                                  prefix: Icons.watch_later_outlined,
                                  prefixIconSize: 25,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                deflutTextFormField(
                                  controller: dateController,
                                  type: TextInputType.text,
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2023-12-30'))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  hint: 'date task',
                                  prefix: Icons.calendar_today,
                                  prefixIconSize: 25,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              backgroundColor: Colors.deepPurple,
              child: Icon(
                cubit.fabIcon,
                color: Colors.white,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'Tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline), label: 'Done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined), label: 'Archived'),
                ]),
          );
        },
      ),
    );
  }
}
