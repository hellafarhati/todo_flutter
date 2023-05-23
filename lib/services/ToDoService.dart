import 'dart:convert';

import 'package:http/http.dart' as http;

class ToDoService {
  static Future<bool> addTodo(Map todoItem) async {
    final url = "http://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(todoItem),
        headers: <String, String>{'Content-Type': 'application/json'});

    return response.statusCode == 201;
  }

  static Future<List?> fetchTodos(int pageNumber) async {
    final url = "http://api.nstack.in/v1/todos?page=$pageNumber&limit=10";
    print(url);
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> updateTodo(String id, Map todoItem) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final result = await http.put(uri,
        body: jsonEncode(todoItem),
        headers: <String, String>{'Content-Type': 'application/json'});

    return result.statusCode == 200;
  }


  static Future<bool> markTodoAsCompleted(String id, Map todoItem) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final result = await http.put(uri,
        body: jsonEncode(todoItem),
        headers: <String, String>{'Content-Type': 'application/json'});

    return result.statusCode == 200;
  }

  static Future<bool> deleteTodo(String id) async {
    final url = "http://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }
}
