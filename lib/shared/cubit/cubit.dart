import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_todo_app/screens/archived_tasks.dart';
import 'package:sqflite_todo_app/screens/done_tasks.dart';
import 'package:sqflite_todo_app/screens/new_tasks.dart';
import 'package:sqflite_todo_app/shared/cubit/state.dart';

class Appcubit extends Cubit<AppStates> {
  // super need thing to start there jop
  Appcubit() : super(AppInatialState());

  static Appcubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Widget> screens = const [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];

  List<String> titels = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  // why i give it database as parameter becuse it tell database not initalized
  // becuse object in onCreate & onOpen created before the big object in  create database

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      // if todo.db => onOpen else => onCreate & onOpen
      onCreate: (database, version) {
        // id interger
        // title String
        // date String
        // time String
        // status String
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT, date TEXT, time TEXT, status TEXT)')
            .then(
          (value) {
            print('database is created');
          },
        ).catchError((onError) {
          print('Error when create $onError');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);

        print('database is opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertIntoDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction(
      (txn) {
        txn.rawInsert(
            'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")');
        return Future.value();
      },
    ).then((value) {
      print('$value insert successfully');
      emit(AppInsertDatabaseState());
      getDataFromDatabase(database);
    }).catchError(
      (onError) {
        print('error when inserting new record ${onError.toString()}');
      },
    );
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetLoadingDatabaseState());
    database.rawQuery('SELECT * FROM tasks').then(
      (value) {
        value.forEach((element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archivedTasks.add(element);
          }
        });

        emit(AppGetDatabaseState());
      },
    );
  }

  updateDate({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppupdateDatabaseState());
    });
  }

  deleteData({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  IconData fabIcon = Icons.edit;
  bool isBottomSheetShow = false;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
