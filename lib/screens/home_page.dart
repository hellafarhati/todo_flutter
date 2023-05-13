import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'  as http;
import 'add_todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
          onPressed: NavigateToAddTODOPage ,
          label: Text(
        "Add TODO"
      )
      ),
      body: ListView.builder(
        itemCount: items.length,
          itemBuilder: (context , index){
          final item = items[index] as Map;
        return ListTile(

          title:Text(item['title']) ,
          subtitle: Text(item['description']),
        );
      }),
    );
  }

  NavigateToAddTODOPage() {
    final route = MaterialPageRoute(builder: (context) => AddTODOPage(),
    );
    Navigator.push(context, route);
  }

  Future<void> getAllTasks() async {
    final url = "http://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if(response.statusCode == 200){
      final json = jsonDecode(response.body) as Map;

      final result = json['items'] as List;

      setState(() {
        items = result;
      });

    }



    print(response.body);


  }



}
