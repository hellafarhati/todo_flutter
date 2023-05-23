import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:todo_s/services/ToDoService.dart';
import 'package:todo_s/widgets/TodoCard.dart';
import '../settings/ThemeSettings.dart';
import '../utils/Utils.dart';
import 'add_todo_page.dart';

class HomePage extends StatefulWidget {


  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  bool isPaginationLoading = true;

  var items = [];
  int page  = 1 ;

  final scrollController = ScrollController();


  void _toggleTheme (){
  final settings = Provider.of<ThemeSettings> (context, listen: false);

      settings. toggleTheme () ;
}


  @override
  void initState() {
    scrollController.addListener(_scrollListener);
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
        actions: [
          IconButton(onPressed: () {
            _toggleTheme();
          }, icon: Icon(
            Icons.dark_mode,
            color: Colors.indigo,
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor:  Colors.limeAccent[100],
          onPressed: NavigateToAddTODOPage, label: Text("Add TODO")
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          color: Colors.deepOrange,
          onRefresh: getAllTasks,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child : Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Icon(Icons.search_off_sharp ,
                  size: 45,
                  color: Colors.deepOrange,),

                  Text(
                    "No items to do",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),




                ],
              )


            ),
            child: ListView.builder(
              controller: scrollController,
                padding: EdgeInsets.all(16),
                itemCount: isPaginationLoading ? items.length + 1 : items.length  ,
                itemBuilder: (context, index) {
                if(index < items.length){
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return TodoCard(
                      index: index,
                      item: item,
                      navigateToEdit: NavigateToEditTODOPage,
                      navigateToDelete: deleteById);
                }
                else {
                  return Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent,));
                }

                }
                ),
          ),
        ),
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.deepOrange,
        )),
      ),
    );
  }

  Future<void> NavigateToAddTODOPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTODOPage(),
    );
    await Navigator.push(context, route);

    setState(() {
      isLoading = true;
    });
    getAllTasks();
  }

  Future<void> NavigateToEditTODOPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTODOPage.withParams(item),
    );
    await Navigator.push(context, route);

    setState(() {
      isLoading = true;
    });
    getAllTasks();
  }

  Future<void> getAllTasks() async {

    final dataList  = await ToDoService.fetchTodos(page);


    if (dataList != null) {


      setState(() {
        items = items+dataList;
        isLoading = false;
      });
    }else {
      showErrorMessage(context , "Something went wrong");
    }
  }

  Future<void> deleteById(String id) async {
    final isSuccess = ToDoService.deleteTodo(id);

    if (await isSuccess) {
      final filteredList =
          items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filteredList;
      });
    } else {
      showErrorMessage(context ,"An error occured ");
    }
  }



  Future <void> _scrollListener() async{
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent){

      setState(() {
        isPaginationLoading = true;
      });
      page++;
     await  getAllTasks();

      setState(() {
        isPaginationLoading = false;
      });
    }


  }
}
