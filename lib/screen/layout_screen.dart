import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/bloc/cubit.dart';
import 'package:todoapp/bloc/states.dart';


class TodoApp extends StatelessWidget {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStatus>(
          listener: (BuildContext context, AppStatus state) {
        if (state is Insertdatabase) Navigator.pop(context);
      }, builder: (BuildContext context, AppStatus state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldkey,
          appBar: AppBar(
            title: Text(cubit.title[cubit.currentindex]),
          ),
          floatingActionButton: FloatingActionButton(
            child: cubit.iconfloat,
            onPressed: () {
              if (cubit.isbottomshetshow) {
                if (formkey.currentState.validate()) {
                  cubit.InsertToDatabase(
                      date: datecontroller.text,
                      time: timecontroller.text,
                      title: titlecontroller.text);
                }
              } else {
                scaffoldkey.currentState
                    .showBottomSheet(
                        (context) => Container(
                              padding: EdgeInsets.all(20),
                              color: Colors.white,
                              child: Form(
                                key: formkey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "Title Must Not Be Empty";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      controller: titlecontroller,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.title),
                                          label: Text("Task Title"),
                                          border: OutlineInputBorder()),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "Time Must Not Be Empty";
                                        }
                                        return null;
                                      },
                                      controller: timecontroller,
                                      keyboardType: TextInputType.none,
                                      decoration: InputDecoration(
                                          prefixIcon:
                                              Icon(Icons.watch_later_outlined),
                                          label: Text("Time"),
                                          border: OutlineInputBorder()),
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timecontroller.text =
                                              value.format(context).toString();
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "Date Must Not Be Empty";
                                        }
                                        return null;
                                      },
                                      controller: datecontroller,
                                      keyboardType: TextInputType.none,
                                      decoration: InputDecoration(
                                          prefixIcon:
                                              Icon(Icons.calendar_today),
                                          label: Text("Date"),
                                          border: OutlineInputBorder()),
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2022-12-31'))
                                            .then((value) {
                                          datecontroller.text =
                                              DateFormat.yMMMd().format(value);
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                        elevation: 20)
                    .closed
                    .then((value) {
                  cubit.changebottomsheet(
                      icon: Icon(Icons.edit), Isshow: false);
                });
                cubit.changebottomsheet(icon: Icon(Icons.add), Isshow: true);
              }
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
              BottomNavigationBarItem(icon: Icon(Icons.check), label: "Done"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive), label: "Archive")
            ],
            currentIndex: cubit.currentindex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              AppCubit.get(context).changeIndex(index);
            },
          ),
          body: ConditionalBuilder(
            condition: state is! loadingstate,
            builder: (context) => cubit.Screen[cubit.currentindex],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );
      }),
    );
  }
}
