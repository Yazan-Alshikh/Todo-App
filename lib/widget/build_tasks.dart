import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/bloc/cubit.dart';
import 'package:todoapp/constance/tasks_list.dart';

Widget BuildTasks(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).Deletedatabase(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text("${model['time']}"),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model['title']}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${model['date']}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .Updatedatabase(statu: "done", id: model['id']);
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .Updatedatabase(statu: "archive", id: model['id']);
                },
                icon: Icon(
                  Icons.archive,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
    );
