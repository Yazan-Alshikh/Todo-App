import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/bloc/cubit.dart';
import 'package:todoapp/bloc/states.dart';
import 'package:todoapp/widget/build_tasks.dart';

class DoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStatus>(
      listener: (context, state) {},
      builder: (context, state) {
        var get = AppCubit.get(context);
        return ListView.separated(
            itemBuilder: (context, index) => BuildTasks(get.donetasks[index],context),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
              padding: EdgeInsetsDirectional.only(start: 20),
            ),
            itemCount: get.donetasks.length);
      },
    );
  }
}
