import 'package:flutter/material.dart';

import '../services/ToDoService.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({Key? key, required this.index, required this.item, required this.navigateToEdit, required this.navigateToDelete   }) : super(key: key);

  final int index ;
  final Map item;
  final Function(Map) navigateToEdit;

  final Function(String) navigateToDelete;

  @override
  Widget build(BuildContext context) {
    final id = item['_id'];

    return  Card(
      color:item['is_completed'] ? Colors.green : Colors.red ,
      elevation: 8,
      shadowColor: Colors.lime,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(child: Text("${index + 1}" , style: TextStyle(color: Colors.white),) , backgroundColor: Colors.blue,),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          onSelected: (value) {
            print("value" + value);

            if (value == "edit") {
              navigateToEdit(item);
            } else if (value == "delete") {
              navigateToDelete(id);
            }
            else if (value == "complete") {
              markTODOAsRead(item["_id"]);
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text("Edit"),
                value: "edit",
              ),
              PopupMenuItem(
                child: Text("Delete"),
                value: "delete",
              ),
              PopupMenuItem(
                child: Text("Mark as Completed"),
                value: "complete",
              ),
            ];
          },
        ),
      ),
    );

  }

  Future<void> markTODOAsRead(String id) async {
    final todoItem = {
      "title": item['title'],
      "description": item['description'],
      "is_completed": true
    };

    final isSuccess = await ToDoService.markTodoAsCompleted(id, todoItem);

    if (isSuccess) {
      print("succes");
     } else {
      print("error");

    }
  }


}
