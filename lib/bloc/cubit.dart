import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/bloc/states.dart';
import 'package:todoapp/screen/archive_screen.dart';
import 'package:todoapp/screen/done_screen.dart';
import 'package:todoapp/screen/task_screen.dart';

class AppCubit extends Cubit<AppStatus> {
  AppCubit() : super(initialstatus());

  static AppCubit get(context) => BlocProvider.of(context);

  Widget iconfloat = Icon(Icons.edit);
  bool isbottomshetshow = false;
  Database database;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivetasks = [];

  int currentindex = 0;
  List<Widget> Screen = [TaskScreen(), DoneScreen(), ArchiveScreen()];
  List<String> title = ["Tasks", "Done", "Archive"];

  void changeIndex(int index) {
    currentindex = index;
    emit(Changenavbar());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print("database greate ");
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT , date TEXT , time TEXT,status TEXT)')
          .then((value) {
        print("table greated");
      }).catchError((error) {
        print(error.toString());
      });
    }, onOpen: (database) {
      print("database open");
      getDataFromDatabase(database);
    }).then((value) {
      database = value;
      emit(Greatdatabase());
    });
  }

  InsertToDatabase(
      {@required String title,
      @required String time,
      @required String date}) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks (title,date,time,status)VALUES("$title","$date","$time","new")')
          .then((value) {
        print("$value insert correct");
        emit(Insertdatabase());
        getDataFromDatabase(database);
      }).catchError((error) {
        print("error");
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newtasks = [];
    donetasks = [];
    archivetasks = [];
    emit(loadingstate());
    database.rawQuery('SELECT * From tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newtasks.add(element);
        } else if (element['status'] == 'done') {
          donetasks.add(element);
        } else
          archivetasks.add(element);
      });
      emit(getdatabase());
    });
  }

  void Updatedatabase({@required String statu, @required int id}) async {
     database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$statu', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(updatedatabasestate());


    });
  }

  void Deletedatabase({ @required int id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {
      getDataFromDatabase(database);
      emit(updatedatabasestate());


    });
  }

  void changebottomsheet({@required Icon icon, @required bool Isshow}) {
    isbottomshetshow = Isshow;
    iconfloat = icon;
    emit(changebottomshet());
  }
}
