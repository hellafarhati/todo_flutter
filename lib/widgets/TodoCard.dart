import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({Key? key, required this.index, required this.item, required this.navigateToEdit, required this.navigateToDelete }) : super(key: key);

  final int index ;
  final Map item;
  final Function(Map) navigateToEdit;
  final Function(String) navigateToDelete;

  @override
  Widget build(BuildContext context) {
    final id = item['_id'];

    return  Card(
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
              )
            ];
          },
        ),
      ),
    );

  }


}
