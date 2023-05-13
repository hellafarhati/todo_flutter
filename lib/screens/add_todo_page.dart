import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTODOPage extends StatefulWidget {
  const AddTODOPage({Key? key}) : super(key: key);

  @override
  State<AddTODOPage> createState() => _AddTODOPageState();
}

class _AddTODOPageState extends State<AddTODOPage> {

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add TODO"),
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
            ElevatedButton(
                onPressed:
                  addTODO,

               child: Text("Submit")),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Future <void> addTODO() async {
    print("start merthos");

    final url = "http://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);

    final body = {
      "title": title.text,
      "description": description.text,
      "is_completed": false
    };

    final result = await http.post(uri, body: jsonEncode(body)  ,headers:<String, String> {'Content-Type': 'application/json'});

    print(result.body);
    print(result.statusCode);



    if(result.statusCode == 201){
      title.text = "";
      description.text = "";
      showSuccesMessage("Created successfully");
    }else {
      showErrorMessage("An error occured");

    }




  }

  void showSuccesMessage(String message) {
    final snackbar = SnackBar(content: Text (message , style: TextStyle(color: Colors.white), ),backgroundColor: Colors.green,);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void showErrorMessage(String message) {
    final snackbar = SnackBar(content: Text (message , style: TextStyle(color: Colors.white), ),backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}


