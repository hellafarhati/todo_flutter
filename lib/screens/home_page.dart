import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  var items = [];

  @override
  void initState() {
    getAllTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "TODOs",
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: NavigateToAddTODOPage, label: Text("Add TODO")),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          color: Colors.deepOrange,
          onRefresh: getAllTasks,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return ListTile(


                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      print("value"+value);

                      if (value == "edit") {
                        NavigateToEditTODOPage(item);
                      } else if (value == "delete") {
                        deleteById(id);

                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(child: Text("Edit") , value: "edit",),
                        PopupMenuItem(child: Text("Delete") , value: "delete",)
                      ];
                    },
                  ),
                );
              }),
        ),
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.deepOrange,
        )),
      ),
    );
  }

  Future <void> NavigateToAddTODOPage() async{
    final route = MaterialPageRoute(
      builder: (context) => AddTODOPage(),
    );
    await Navigator.push(context, route);

    setState(() {
      isLoading = true;
    });
    getAllTasks();

  }

 void NavigateToEditTODOPage(Map item)  {
    final route = MaterialPageRoute(
      builder: (context) => AddTODOPage.withParams(item),
    );
      Navigator.push(context, route);

    setState(() {
      isLoading = true;
    });
    getAllTasks();

  }

  Future<void> getAllTasks() async {
    final url = "http://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;

      final result = json['items'] as List;

      setState(() {
        items = result;
        isLoading = false;
      });
    }


  }

  Future <void> deleteById(String id)  async{
    final url = "http://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);

    final response = await http.delete(uri);

    if(response.statusCode == 200){
      final filteredList = items.where((element) => element['_id'] != id ).toList();
      setState(() {
        items = filteredList;
      });


    }
    else {
      showErrorMessage("An error occured ");
    }




  }

  void showErrorMessage(String message) {
    final snackbar = SnackBar(content: Text (message , style: TextStyle(color: Colors.white), ),backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}


