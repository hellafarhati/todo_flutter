import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_s/services/ToDoService.dart';
import 'package:todo_s/utils/Utils.dart';

class AddTODOPage extends StatefulWidget {
  final Map? todo;

  AddTODOPage.withParams(this.todo);

  const AddTODOPage({this.todo, Key? key}) : super(key: key);

  @override
  State<AddTODOPage> createState() => _AddTODOPageState();
}

class _AddTODOPageState extends State<AddTODOPage> {
  bool isEdit = false;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  late var todo;

  @override
  void initState() {
    todo = widget.todo;
    if (todo != null) {
      isEdit = true;

      title.text = todo['title'];
      description.text = todo['description'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit TODO" : "Add TODO"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextFormField(
              controller: title,
              decoration: InputDecoration(hintText: "Title"),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: description,
              decoration: InputDecoration(
                hintText: "Desciption",
              ),
              minLines: 3,
              maxLines: 5,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.limeAccent[100],
                ),
                onPressed: () {
                  isEdit ? updateTODO(todo['_id'] as String) : addTODO();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    isEdit ? "Update" : "Submit",
                    style: TextStyle(color: Colors.black54),
                  ),
                )),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Future<void> addTODO() async {
    final todoItem = {
      "title": title.text,
      "description": description.text,
      "is_completed": false
    };

    final isSuccess = await ToDoService.addTodo(todoItem);

    if (isSuccess) {
      title.text = "";
      description.text = "";
      showInfoMessage(context, "Created successfully");
    } else {
      showErrorMessage(context, "An error occured");
    }
  }

  Future<void> updateTODO(String id) async {
    final todoItem = {
      "title": title.text,
      "description": description.text,
      "is_completed": false
    };

    final isSuccess = await ToDoService.updateTodo(id, todoItem);

    if (isSuccess) {
      showInfoMessage(context, "Updated successfully");
    } else {
      showErrorMessage(context, "An error occured");
    }
  }
}
